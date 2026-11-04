from __future__ import annotations

import os
import pathlib
import shlex
import shutil
import subprocess
import sys

_DRY_RUN = False


class JHomeManagerError(RuntimeError):
    pass


class CommandError(JHomeManagerError):
    pass


def set_dry_run(value: bool) -> None:
    global _DRY_RUN
    _DRY_RUN = value


def is_dry_run() -> bool:
    return _DRY_RUN


class TerminalColors:
    _enabled = sys.stdout.isatty() and "NO_COLOR" not in os.environ
    BLUE = "\033[94m" if _enabled else ""
    CYAN = "\033[96m" if _enabled else ""
    GREEN = "\033[92m" if _enabled else ""
    YELLOW = "\033[93m" if _enabled else ""
    RED = "\033[91m" if _enabled else ""
    RESET = "\033[0m" if _enabled else ""


def tree_print(c, indent_level: int = 0, tree_char: str = "└──") -> None:
    print(f"{indent_level * 4 * ' '}{tree_char} {c}")


def _print_dry_run(command: list[str]) -> None:
    tree_print(
        f"{TerminalColors.YELLOW}[dry-run]{TerminalColors.RESET} {shlex.join(command)}",
        indent_level=2,
    )


def binary_path(binary: str) -> pathlib.Path:
    possible_path = shutil.which(binary)
    if not possible_path:
        raise JHomeManagerError(f"{binary}: not found in PATH")
    return pathlib.Path(possible_path)


def run(
    command: list[str],
    *,
    mutates: bool = True,
    check: bool = True,
    input: bytes | None = None,
) -> subprocess.CompletedProcess:
    """
    Run a command and capture its output.
    Commands that change the system (`mutates=True`) are only printed in dry-run mode.
    """
    if mutates and _DRY_RUN:
        _print_dry_run(command)
        return subprocess.CompletedProcess(command, 0, b"", b"")

    result = subprocess.run(command, capture_output=True, input=input)
    if check and result.returncode != 0:
        raise CommandError(
            f"`{shlex.join(command)}` failed with exit code {result.returncode}:\n"
            f"{result.stderr.decode('utf-8', errors='replace').strip()}"
        )
    return result


def run_interactive(command: list[str], *, mutates: bool = True) -> None:
    """
    Run a command attached to the current terminal (no capture).
    This preserves progress bars, colors and password prompts.
    """
    if mutates and _DRY_RUN:
        _print_dry_run(command)
        return

    sys.stdout.flush()
    exit_code = subprocess.run(command).returncode
    if exit_code != 0:
        raise CommandError(f"`{shlex.join(command)}` failed with exit code {exit_code}")
