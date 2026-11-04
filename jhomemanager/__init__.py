from __future__ import annotations

from .cli import main
from .config import get_machine_name
from .dotfiles import DotFilesInstallationStage
from .installationstage import InstallationStage
from .maintenance import BootstrapInstallationStage, GarbageCollectionStage
from .packagesstage import PackagesInstallationStage
from .paths import HOME, REPO_ROOT
from .shell import (
    JHomeManagerError,
    TerminalColors,
    is_dry_run,
    run,
    run_interactive,
    tree_print,
)
from .systemconfig import MacOSDefault, MacOSDefaults, MacOSUserLaunchAgent

__all__ = [
    "HOME",
    "REPO_ROOT",
    "BootstrapInstallationStage",
    "DotFilesInstallationStage",
    "GarbageCollectionStage",
    "InstallationStage",
    "JHomeManagerError",
    "MacOSDefault",
    "MacOSDefaults",
    "MacOSUserLaunchAgent",
    "PackagesInstallationStage",
    "TerminalColors",
    "get_machine_name",
    "is_dry_run",
    "main",
    "run",
    "run_interactive",
    "tree_print",
]
