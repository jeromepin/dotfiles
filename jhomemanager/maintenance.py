from __future__ import annotations

import pathlib
import shutil
import tempfile

from .installationstage import InstallationStage
from .shell import TerminalColors, run_interactive, tree_print

NIX_INSTALLER_PKG_URL = "https://install.determinate.systems/nix-installer-pkg/stable/Universal"
HOMEBREW_INSTALLER_URL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"


def _installed(binary: str, *known_paths: str) -> bool:
    # Known paths: right after an install, the current shell's PATH doesn't have them yet
    return shutil.which(binary) is not None or any(pathlib.Path(p).exists() for p in known_paths)


class BootstrapInstallationStage(InstallationStage):
    TITLE = "bootstrap"
    REQUIRED_BINARIES = ("curl",)
    HELP = "first run on a new Mac: install Nix and Homebrew"
    DESCRIPTION = """\
First run on a new Mac: install what the other commands need, when missing.
  - Nix, with the Determinate Systems macOS installer (asks for your password).
  - Homebrew, with its official install script.
Works with the Mac's built-in Python. Then open a new shell and run ./install.py."""

    def _nix(self) -> None:
        tree_print("Nix")
        if _installed("nix", "/nix/var/nix/profiles/default/bin/nix"):
            tree_print(f"{TerminalColors.GREEN}Already installed{TerminalColors.RESET}", indent_level=1)
            return
        with tempfile.TemporaryDirectory() as tmp:
            pkg = pathlib.Path(tmp) / "DeterminateNix.pkg"
            run_interactive(["curl", "-fsSL", "-o", str(pkg), NIX_INSTALLER_PKG_URL])
            run_interactive(["sudo", "installer", "-pkg", str(pkg), "-target", "/"])

    def _homebrew(self) -> None:
        tree_print("Homebrew")
        if _installed("brew", "/opt/homebrew/bin/brew", "/usr/local/bin/brew"):
            tree_print(f"{TerminalColors.GREEN}Already installed{TerminalColors.RESET}", indent_level=1)
            return
        run_interactive(["/bin/bash", "-c", f'/bin/bash -c "$(curl -fsSL {HOMEBREW_INSTALLER_URL})"'])

    def exec(self) -> None:
        super().exec()
        self._nix()
        self._homebrew()
        tree_print(f"{TerminalColors.YELLOW}Open a new shell, then run ./install.py{TerminalColors.RESET}")


class GarbageCollectionStage(InstallationStage):
    TITLE = "gc"
    REQUIRED_BINARIES = ("nix",)
    HISTORY_KEPT = "30d"
    HELP = f"free disk space: delete Nix profile history older than {HISTORY_KEPT} and unused store paths"
    DESCRIPTION = f"""\
Free disk space used by Nix:
  - delete the profile history older than {HISTORY_KEPT} (`nix profile rollback` can't go
    further back afterwards),
  - delete the store paths nothing uses anymore."""

    def exec(self) -> None:
        super().exec()
        tree_print(f"Deleting profile history older than {self.HISTORY_KEPT}")
        run_interactive(["nix", "profile", "wipe-history", "--older-than", self.HISTORY_KEPT])
        tree_print("Deleting unused store paths")
        run_interactive(["nix", "store", "gc"])
