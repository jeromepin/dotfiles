from __future__ import annotations

import json
import pathlib
import tempfile
import typing

from .shell import TerminalColors, binary_path, run, run_interactive, tree_print

HOMEBREW_KINDS = ("tap", "brew", "cask")
HOMEBREW_BUILTIN_TAPS = {"homebrew/core", "homebrew/cask", "homebrew/bundle", "homebrew/services"}


def _lines(output: bytes) -> set[str]:
    return {line.strip().lower() for line in output.decode("utf-8").splitlines() if line.strip()}


def _tap_of(name: str) -> str | None:
    parts = name.split("/")
    return "/".join(parts[:2]) if len(parts) == 3 else None


class HomebrewPackageManager:
    def __init__(self, packages: typing.Iterable[str]):
        self.declared: dict[str, set[str]] = {kind: set() for kind in HOMEBREW_KINDS}
        self.lines = []
        for entry in sorted(set(packages)):
            kind, _, name = entry.partition(" ")
            if kind not in HOMEBREW_KINDS or not name:
                raise ValueError(f"Invalid Homebrew entry {entry!r}, expected one of {HOMEBREW_KINDS} followed by a name")
            self.declared[kind].add(name.lower())
            self.lines.append(f'{kind} "{name}"')

    def _installed(self, brew: str) -> dict[str, set[str]]:
        return {
            "tap": _lines(run([brew, "tap"], mutates=False).stdout),
            "brew": _lines(run([brew, "list", "--formula", "--full-name", "-1"], mutates=False).stdout),
            "cask": _lines(run([brew, "list", "--cask", "--full-name", "-1"], mutates=False).stdout),
        }

    @staticmethod
    def _available_versions(brew: str, formulae: list[str], casks: list[str]) -> dict[str, str]:
        versions = {}
        if formulae:
            # Fails for formulae of a tap that isn't tapped yet: versions are then unknown
            result = run([brew, "info", "--json=v2", "--formula", *formulae], mutates=False, check=False)
            if result.returncode == 0:
                for f in json.loads(result.stdout)["formulae"]:
                    versions[f["full_name"].lower()] = f["versions"]["stable"]
        if casks:
            result = run([brew, "info", "--json=v2", "--cask", *casks], mutates=False, check=False)
            if result.returncode == 0:
                for c in json.loads(result.stdout)["casks"]:
                    versions[c["full_token"].lower()] = c["version"]
        return versions

    @staticmethod
    def _outdated(brew: str) -> dict[str, tuple[str, str]]:
        """name -> (installed version, available version)"""
        data = json.loads(run([brew, "outdated", "--json=v2"], mutates=False).stdout)
        outdated = {}
        for f in data["formulae"]:
            outdated[f["name"].lower()] = (", ".join(f["installed_versions"]), f["current_version"])
        for c in data["casks"]:
            outdated[c["name"].lower()] = (", ".join(c["installed_versions"]), c["current_version"])
        return outdated

    def _print_plan(self, brew: str, installed: dict[str, set[str]], upgrade: bool) -> bool:
        """Print what `brew bundle install` would do; return whether it has anything to do."""
        missing = {kind: sorted(self.declared[kind] - installed[kind]) for kind in HOMEBREW_KINDS}
        versions = self._available_versions(brew, missing["brew"], missing["cask"])
        for kind in HOMEBREW_KINDS:
            for name in missing[kind]:
                version = f" {versions[name]}" if name in versions else ""
                tree_print(f"{TerminalColors.GREEN}+ {kind} {name}{version}{TerminalColors.RESET}", indent_level=1)

        upgrades = []
        if upgrade:
            # Refresh Homebrew's index (metadata only) so the plan matches what will be installed
            run([brew, "update", "--quiet"], mutates=False)
            # `brew outdated` uses full names for tap formulae (user/tap/name), like the declarations
            declared_names = self.declared["brew"] | self.declared["cask"]
            upgrades = sorted(
                (name, versions)
                for name, versions in self._outdated(brew).items()
                if name in declared_names
            )
            for name, (old, new) in upgrades:
                tree_print(f"{TerminalColors.CYAN}↑ {name}: {old} -> {new}{TerminalColors.RESET}", indent_level=1)

        return any(missing.values()) or bool(upgrades)

    def _print_undeclared(self, brew: str, installed: dict[str, set[str]]) -> None:
        """Only what was installed directly: dependencies come and go with their parents."""
        declared_taps = self.declared["tap"] | HOMEBREW_BUILTIN_TAPS | {
            tap for name in self.declared["brew"] | self.declared["cask"] if (tap := _tap_of(name))
        }
        undeclared = (
            [f"brew {n}" for n in sorted(_lines(run([brew, "leaves", "--installed-on-request"], mutates=False).stdout) - self.declared["brew"])]
            + [f"cask {n}" for n in sorted(installed["cask"] - self.declared["cask"])]
            + [f"tap {n}" for n in sorted(installed["tap"] - declared_taps)]
        )
        if undeclared:
            tree_print(
                f"{TerminalColors.YELLOW}Installed directly but not declared: {', '.join(undeclared)}{TerminalColors.RESET}",
                indent_level=1,
            )

    def apply(self, upgrade: bool = False) -> None:
        tree_print(f"Homebrew packages [{len(self.lines)}]")
        brew = str(binary_path("brew"))
        installed = self._installed(brew)

        if not self._print_plan(brew, installed, upgrade):
            tree_print(f"{TerminalColors.GREEN}Everything up to date{TerminalColors.RESET}", indent_level=1)
        else:
            with tempfile.TemporaryDirectory() as tmp:
                brewfile = pathlib.Path(tmp) / "Brewfile"
                brewfile.write_text("\n".join(self.lines) + "\n")
                cmd = [brew, "bundle", "install", f"--file={brewfile}"]
                if not upgrade:
                    cmd.append("--no-upgrade")
                run_interactive(cmd)
            installed = self._installed(brew)

        # Never removed automatically: Homebrew also holds things installed by hand
        self._print_undeclared(brew, installed)


class EgetPackageManager:
    def __init__(self, binaries: typing.Iterable[str]):
        self.binaries = sorted(set(binaries))

    def apply(self, upgrade: bool = False) -> None:
        if not self.binaries:
            return
        tree_print(f"Eget binaries [{len(self.binaries)}]")
        eget = str(binary_path("eget"))
        for binary in self.binaries:
            tree_print(f"{TerminalColors.CYAN}{binary}{TerminalColors.RESET}", indent_level=1)
            run_interactive([eget, "--upgrade-only", binary])
