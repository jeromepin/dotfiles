from __future__ import annotations

import pathlib
import tempfile
import typing

from .shell import TerminalColors, binary_path, run, run_interactive, tree_print

HOMEBREW_KINDS = ("tap", "brew", "cask")


class HomebrewPackageManager:
    def __init__(self, packages: typing.Iterable[str]):
        self.lines = []
        for entry in sorted(set(packages)):
            kind, _, name = entry.partition(" ")
            if kind not in HOMEBREW_KINDS or not name:
                raise ValueError(f"Invalid Homebrew entry {entry!r}, expected one of {HOMEBREW_KINDS} followed by a name")
            self.lines.append(f'{kind} "{name}"')

    def apply(self, upgrade: bool = False) -> None:
        tree_print(f"Homebrew packages [{len(self.lines)}]")
        brew = str(binary_path("brew"))

        with tempfile.TemporaryDirectory() as tmp:
            brewfile = pathlib.Path(tmp) / "Brewfile"
            brewfile.write_text("\n".join(self.lines) + "\n")

            check = run([brew, "bundle", "check", f"--file={brewfile}", "--no-upgrade"], mutates=False, check=False)
            if check.returncode == 0 and not upgrade:
                tree_print(f"{TerminalColors.GREEN}Everything installed{TerminalColors.RESET}", indent_level=1)
            else:
                cmd = [brew, "bundle", "install", f"--file={brewfile}"]
                if not upgrade:
                    cmd.append("--no-upgrade")
                run_interactive(cmd)

            # Never remove automatically: Homebrew also holds things installed by hand
            # Exits 1 both when something would be removed and on real errors
            cleanup = run([brew, "bundle", "cleanup", f"--file={brewfile}"], mutates=False, check=False)
            if cleanup.returncode != 0 and not cleanup.stdout.strip():
                tree_print(
                    f"{TerminalColors.YELLOW}Could not list undeclared packages: "
                    f"{cleanup.stderr.decode('utf-8').strip()}{TerminalColors.RESET}",
                    indent_level=1,
                )
            undeclared = [
                line for line in cleanup.stdout.decode("utf-8").splitlines()
                if line and not line.startswith(("Would ", "Run `brew bundle cleanup"))
            ]
            if undeclared:
                tree_print(
                    f"{TerminalColors.YELLOW}Installed but not declared: {', '.join(undeclared)}{TerminalColors.RESET}",
                    indent_level=1,
                )


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
