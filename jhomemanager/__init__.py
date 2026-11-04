from __future__ import annotations

import typing

from .cli import main
from .dotfiles import DotFilesInstallationStage
from .installationstage import InstallationStage
from .packagelist import IPackageList
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
    "DotFilesInstallationStage",
    "InstallationStage",
    "IPackageList",
    "JHomeManagerError",
    "MacOSDefault",
    "MacOSDefaults",
    "MacOSUserLaunchAgent",
    "TerminalColors",
    "for_this_machine",
    "get_machine_name",
    "is_dry_run",
    "main",
    "run",
    "run_interactive",
    "tree_print",
]

T = typing.TypeVar("T")


def get_machine_name() -> str:
    return run(["scutil", "--get", "ComputerName"], mutates=False).stdout.decode("utf-8").strip()


def for_this_machine(mapping: dict[str, T]) -> T:
    name = get_machine_name()
    if name not in mapping:
        raise JHomeManagerError(
            f"Unknown machine {name!r} (from `scutil --get ComputerName`). Known machines: {', '.join(mapping)}"
        )
    return mapping[name]
