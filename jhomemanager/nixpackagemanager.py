from __future__ import annotations

import dataclasses
import json
import pathlib
import typing

from .packages import NixPackage
from .shell import CommandError, JHomeManagerError, TerminalColors, is_dry_run, run, run_interactive, tree_print


def _version_from_store_paths(store_paths: list[str]) -> str | None:
    """
    /nix/store/<hash>-postgresql-16.15 -> 16.15, like `builtins.parseDrvName`.
    Extra outputs (`-man`, `-dev`...) have longer names, so the shortest one is the main output.
    """
    names = [pathlib.PurePath(p).name.split("-", 1)[-1] for p in store_paths]
    if not names:
        return None
    parts = min(names, key=len).split("-")
    for i, part in enumerate(parts[1:], start=1):
        if part[:1].isdigit():
            return "-".join(parts[i:])
    return None


def _nix_string(value: str) -> str:
    return json.dumps(value).replace("${", "\\${")


@dataclasses.dataclass(frozen=True)
class ProfileElement:
    name: str  # what `nix profile remove/upgrade` expects, e.g. `fira-code-1`
    package: NixPackage | None  # None when not installed from a `legacyPackages` attribute (not managed here)
    version: str | None = None


class NixPackageManager:
    """
    Reconciles the user's Nix profile with the wanted package list:
    every package installed from a `legacyPackages` attribute that is not wanted is removed.
    """

    def __init__(self, packages: typing.Iterable[str], stable_branch: str):
        if not stable_branch:
            raise JHomeManagerError("`CURRENT_NIX_STABLE_BRANCH` is not set")
        self.wanted = {NixPackage.from_spec(p, stable_branch) for p in packages}

    @staticmethod
    def installed() -> list[ProfileElement]:
        data = json.loads(run(["nix", "profile", "list", "--json"], mutates=False).stdout)
        elements = data.get("elements", {})
        if not isinstance(elements, dict):
            raise JHomeManagerError("Unsupported `nix profile list --json` format, Nix >= 2.20 is required")

        result = []
        for name, attrs in elements.items():
            # attrPath = legacyPackages.<system>.<attr>
            parts = (attrs.get("attrPath") or "").split(".", 2)
            package = None
            if len(parts) == 3 and parts[0] == "legacyPackages" and attrs.get("originalUrl"):
                package = NixPackage(attrs["originalUrl"].removeprefix("flake:"), parts[2])
            result.append(ProfileElement(name, package, _version_from_store_paths(attrs.get("storePaths") or [])))
        return result

    @staticmethod
    def latest_versions(packages: typing.Iterable[NixPackage]) -> dict[NixPackage, str | None]:
        """Version each package would have if installed now: one evaluation per flake (channel)."""
        by_flake: dict[str, list[NixPackage]] = {}
        for package in packages:
            by_flake.setdefault(package.flake, []).append(package)

        versions: dict[NixPackage, str | None] = {}
        for flake, flake_packages in sorted(by_flake.items()):
            tree_print(f"Resolving versions from {TerminalColors.CYAN}{flake}{TerminalColors.RESET}", indent_level=1)
            fields = []
            for p in flake_packages:
                selector = ".".join(_nix_string(part) for part in p.attr.split("."))
                fields.append(
                    f"{_nix_string(p.attr)} = let r = builtins.tryEval (pkgs.{selector}.version or null); "
                    f"in if r.success then r.value else null;"
                )
            expr = (
                f"let pkgs = (builtins.getFlake {_nix_string(flake)}).legacyPackages.${{builtins.currentSystem}}; "
                f"in {{ {' '.join(fields)} }}"
            )
            result = run(["nix", "eval", "--impure", "--json", "--expr", expr], mutates=False, check=False)
            if result.returncode != 0:
                tree_print(
                    f"{TerminalColors.YELLOW}Could not resolve versions: {result.stderr.decode('utf-8').strip().splitlines()[-1:]}{TerminalColors.RESET}",
                    indent_level=2,
                )
                continue
            resolved = json.loads(result.stdout)
            for p in flake_packages:
                versions[p] = resolved.get(p.attr)
        return versions

    def apply(self, upgrade: bool = False) -> None:
        tree_print("Nix packages (https://status.nixos.org/)")

        present: set[NixPackage] = set()
        kept: list[ProfileElement] = []
        to_remove: list[ProfileElement] = []
        unmanaged: list[ProfileElement] = []
        for element in self.installed():
            if element.package is None:
                unmanaged.append(element)
            elif element.package in self.wanted and element.package not in present:
                present.add(element.package)
                kept.append(element)
            else:  # unwanted, or a duplicate of a wanted package
                to_remove.append(element)
        to_install = sorted(self.wanted - present)

        for element in unmanaged:
            tree_print(
                f"{TerminalColors.YELLOW}Ignoring {element.name} (not installed from a nixpkgs attribute){TerminalColors.RESET}",
                indent_level=1,
            )

        if not to_remove and not to_install and not upgrade:
            tree_print(f"{TerminalColors.GREEN}{len(present)} packages up to date{TerminalColors.RESET}", indent_level=1)
            return

        latest = self.latest_versions([*to_install, *(e.package for e in kept if upgrade and e.package)])
        self._print_plan(to_remove, to_install, kept if upgrade else [], latest)

        if to_remove:
            run_interactive(["nix", "profile", "remove", *(e.name for e in to_remove)])

        if to_install:
            try:
                run_interactive(["nix", "profile", "install", *(p.reference for p in to_install)])
            except CommandError:
                if to_remove and not is_dry_run():
                    tree_print(f"{TerminalColors.RED}Install failed, rolling back the removals{TerminalColors.RESET}", indent_level=1)
                    run_interactive(["nix", "profile", "rollback"])
                raise

        if upgrade and kept:
            run_interactive(["nix", "profile", "upgrade", *(e.name for e in kept)])

    @staticmethod
    def _print_plan(
        to_remove: list[ProfileElement],
        to_install: list[NixPackage],
        to_upgrade: list[ProfileElement],
        latest: dict[NixPackage, str | None],
    ) -> None:
        def v(version: str | None) -> str:
            return version or "?"

        # The same attribute removed from one channel and installed from another is a move
        installs_by_attr = {p.attr: p for p in to_install}
        moved: set[NixPackage] = set()
        for element in to_remove:
            assert element.package is not None
            target = installs_by_attr.get(element.package.attr)
            if target:
                moved.add(target)
                tree_print(
                    f"{TerminalColors.CYAN}~ {element.package.attr}: {v(element.version)} -> {v(latest.get(target))}"
                    f"{TerminalColors.RESET} ({element.package.flake} -> {target.flake})",
                    indent_level=1,
                )
            else:
                tree_print(f"{TerminalColors.RED}- {element.package} {v(element.version)}{TerminalColors.RESET}", indent_level=1)

        for package in to_install:
            if package not in moved:
                tree_print(f"{TerminalColors.GREEN}+ {package} {v(latest.get(package))}{TerminalColors.RESET}", indent_level=1)

        bumps = 0
        for element in to_upgrade:
            assert element.package is not None
            new = latest.get(element.package)
            if new and new != element.version:
                bumps += 1
                tree_print(f"{TerminalColors.CYAN}↑ {element.package.attr}: {v(element.version)} -> {new}{TerminalColors.RESET}", indent_level=1)
        if to_upgrade:
            tree_print(f"{len(to_upgrade)} packages upgraded within their channel, {bumps} with a new version", indent_level=1)
