from __future__ import annotations

import dataclasses
import json
import pathlib
import shutil
import tempfile
import typing

from .shell import CommandError, JHomeManagerError, TerminalColors, is_dry_run, run, run_interactive, tree_print

MANIFEST_FILE = "jhome-manifest.json"  # written by flake.nix at the root of each environment


@dataclasses.dataclass(frozen=True)
class ManifestEntry:
    channel: str | None  # None for packages installed before the flake (unknown channel)
    attr: str
    version: str | None


@dataclasses.dataclass(frozen=True)
class ProfileElement:
    name: str  # what `nix profile remove/upgrade` expects
    original_url: str
    attr_path: str
    store_path: pathlib.Path | None

    @property
    def manifest(self) -> list[ManifestEntry] | None:
        if self.store_path is None or not (self.store_path / MANIFEST_FILE).exists():
            return None
        return [ManifestEntry(**e) for e in json.loads((self.store_path / MANIFEST_FILE).read_text())]


def _version_from_store_path(store_path: pathlib.Path) -> str | None:
    """/nix/store/<hash>-postgresql-16.15 -> 16.15, like `builtins.parseDrvName`."""
    parts = store_path.name.split("-")[1:]
    for i, part in enumerate(parts[1:], start=1):
        if part[:1].isdigit():
            version = parts[i:]
            # Drop an output name glued at the end: jq-1.8.1-man, crane-0.22.0-crane
            while len(version) > 1 and version[-1].isalpha():
                version.pop()
            return "-".join(version)
    return None


def _profile_elements() -> list[ProfileElement]:
    data = json.loads(run(["nix", "profile", "list", "--json"], mutates=False).stdout)
    elements = data.get("elements", {})
    if not isinstance(elements, dict):
        raise JHomeManagerError("Unsupported `nix profile list --json` format, Nix >= 2.20 is required")

    result = []
    for name, attrs in elements.items():
        # Extra outputs (`-man`, `-dev`...) have longer names: the shortest store path is the main output
        store_paths = sorted((pathlib.Path(p) for p in attrs.get("storePaths") or []), key=lambda p: len(p.name))
        result.append(
            ProfileElement(
                name=name,
                original_url=attrs.get("originalUrl") or "",
                attr_path=attrs.get("attrPath") or "",
                store_path=store_paths[0] if store_paths else None,
            )
        )
    return result


class NixProfileManager:
    """
    Keeps exactly one entry in the user's Nix profile: the environment built by flake.nix for this host.
    Packages installed one by one from nixpkgs (before the flake) are removed when it's installed.
    """

    def __init__(self, flake_dir: pathlib.Path, host: str):
        self.flake_dir = flake_dir
        self.host = host

    def apply(self, upgrade: bool = False) -> None:
        tree_print(f"Nix packages ({self.flake_dir.name}/flake.nix, host {TerminalColors.CYAN}{self.host}{TerminalColors.RESET})")
        with tempfile.TemporaryDirectory() as tmp:
            flake_dir = self.flake_dir
            if upgrade:
                # resolve(): Nix refuses paths under /var, a symlink to /private/var
                flake_dir = self._update_lock(pathlib.Path(tmp).resolve())
            self._apply(flake_dir)

    def _update_lock(self, tmp: pathlib.Path) -> pathlib.Path:
        """Move every channel to its latest commit. In dry-run, on a copy so the plan shows the result."""
        lock_file = self.flake_dir / "flake.lock"
        if is_dry_run():
            copy = tmp / self.flake_dir.name
            shutil.copytree(self.flake_dir, copy)
            tree_print("Updating channels (on a copy of flake.lock)", indent_level=1)
            run(["nix", "flake", "update", "--flake", f"path:{copy}"], mutates=False)
            return copy

        before = lock_file.read_bytes()
        tree_print("Updating channels", indent_level=1)
        run_interactive(["nix", "flake", "update", "--flake", f"path:{self.flake_dir}"])
        if lock_file.read_bytes() != before:
            tree_print(f"{TerminalColors.YELLOW}{lock_file} changed: commit it{TerminalColors.RESET}", indent_level=1)
        return self.flake_dir

    def _apply(self, flake_dir: pathlib.Path) -> None:
        system = run(["nix", "eval", "--impure", "--raw", "--expr", "builtins.currentSystem"], mutates=False).stdout.decode()
        attr_path = f"packages.{system}.{self.host}"
        url = f"path:{self.flake_dir}"  # recorded in the profile, used by `nix profile upgrade`
        eval_url = f"path:{flake_dir}"  # a temporary copy when planning an upgrade

        target = pathlib.Path(run(["nix", "eval", "--raw", f"{eval_url}#{attr_path}.outPath"], mutates=False).stdout.decode())
        new_manifest = [
            ManifestEntry(**e)
            for e in json.loads(run(["nix", "eval", "--json", f"{eval_url}#manifests.{system}.{self.host}"], mutates=False).stdout)
        ]

        current: ProfileElement | None = None
        to_remove: list[ProfileElement] = []
        for element in _profile_elements():
            if element.manifest is not None:  # an environment built by flake.nix
                if current is None and element.original_url == url and element.attr_path == attr_path:
                    current = element
                else:  # other host, moved repository, duplicate
                    to_remove.append(element)
            elif element.attr_path.startswith("legacyPackages."):  # installed one by one, before the flake
                to_remove.append(element)
            else:
                tree_print(
                    f"{TerminalColors.YELLOW}Ignoring {element.name} ({element.original_url}){TerminalColors.RESET}",
                    indent_level=1,
                )

        if current is not None:
            old_manifest = current.manifest or []
        else:
            old_manifest = [
                ManifestEntry(
                    None,
                    e.attr_path.split(".", 2)[2].removeprefix("pkgs."),
                    _version_from_store_path(e.store_path) if e.store_path else None,
                )
                for e in to_remove
                if e.attr_path.startswith("legacyPackages.")
            ]

        if current is not None and current.store_path == target and not to_remove:
            tree_print(f"{TerminalColors.GREEN}{len(new_manifest)} packages up to date{TerminalColors.RESET}", indent_level=1)
            return

        self._print_plan(old_manifest, new_manifest)
        if to_remove:
            tree_print(f"Replacing {len(to_remove)} profile entries with the {self.host} environment", indent_level=1)
            run_interactive(["nix", "profile", "remove", *(e.name for e in to_remove)])
        try:
            if current is not None:
                run_interactive(["nix", "profile", "upgrade", current.name])
            else:
                run_interactive(["nix", "profile", "install", f"{url}#{attr_path}"])
        except CommandError:
            if to_remove and not is_dry_run():
                tree_print(f"{TerminalColors.RED}Failed, rolling back the removals{TerminalColors.RESET}", indent_level=1)
                run_interactive(["nix", "profile", "rollback"])
            raise

    @staticmethod
    def _print_plan(old: typing.Sequence[ManifestEntry], new: typing.Sequence[ManifestEntry]) -> None:
        def v(version: str | None) -> str:
            return version or "?"

        old_by_attr = {e.attr: e for e in old}
        new_by_attr = {e.attr: e for e in new}
        changes = 0
        for attr in sorted(old_by_attr.keys() | new_by_attr.keys()):
            o, n = old_by_attr.get(attr), new_by_attr.get(attr)
            if o is None and n is not None:
                line = f"{TerminalColors.GREEN}+ {n.channel}.{attr} {v(n.version)}"
            elif n is None and o is not None:
                line = f"{TerminalColors.RED}- {attr} {v(o.version)}"
            elif o is not None and n is not None and (o.version != n.version or (o.channel and o.channel != n.channel)):
                moved = f" ({o.channel} -> {n.channel})" if o.channel and o.channel != n.channel else ""
                line = f"{TerminalColors.CYAN}~ {attr}: {v(o.version)} -> {v(n.version)}{moved}"
            else:
                continue
            changes += 1
            tree_print(f"{line}{TerminalColors.RESET}", indent_level=1)

        if not changes:
            tree_print("Same versions, rebuilt dependencies", indent_level=1)
