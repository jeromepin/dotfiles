from __future__ import annotations

import dataclasses
import json
import typing

from .packages import NixPackage
from .shell import CommandError, JHomeManagerError, TerminalColors, is_dry_run, run, run_interactive, tree_print


@dataclasses.dataclass(frozen=True)
class ProfileElement:
    name: str  # what `nix profile remove/upgrade` expects, e.g. `fira-code-1`
    package: NixPackage | None  # None when not installed from a `legacyPackages` attribute (not managed here)


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
            result.append(ProfileElement(name, package))
        return result

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

        if to_remove:
            tree_print(f"Removing [{len(to_remove)}]", indent_level=1)
            for element in to_remove:
                tree_print(f"{TerminalColors.RED}- {element.name}{TerminalColors.RESET} ({element.package})", indent_level=2)
            run_interactive(["nix", "profile", "remove", *(e.name for e in to_remove)])

        if to_install:
            tree_print(f"Installing [{len(to_install)}]", indent_level=1)
            for package in to_install:
                tree_print(f"{TerminalColors.GREEN}+ {package}{TerminalColors.RESET}", indent_level=2)
            try:
                run_interactive(["nix", "profile", "install", *(p.reference for p in to_install)])
            except CommandError:
                if to_remove and not is_dry_run():
                    tree_print(f"{TerminalColors.RED}Install failed, rolling back the removals{TerminalColors.RESET}", indent_level=1)
                    run_interactive(["nix", "profile", "rollback"])
                raise

        if upgrade and kept:
            tree_print(f"Upgrading [{len(kept)}] within their channel", indent_level=1)
            run_interactive(["nix", "profile", "upgrade", *(e.name for e in kept)])
