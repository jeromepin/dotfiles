from __future__ import annotations

import dataclasses
import datetime
import os
import pathlib
import typing

from .installationstage import InstallationStage
from .paths import HOME, REPO_ROOT
from .shell import TerminalColors, is_dry_run, run, tree_print


class DotFilesInstallationStage(InstallationStage):
    REQUIRED_BINARIES = ("git",)

    @dataclasses.dataclass(frozen=True)
    class SourceDotfile:
        source: str
        recursive: bool = False

    # destination (relative to $HOME): source (relative to the repository)
    FILES: typing.ClassVar[dict[str, str | DotFilesInstallationStage.SourceDotfile]] = {}

    def __init__(self) -> None:
        self._unchanged = 0
        self._backup_suffix = datetime.datetime.now().strftime("backup-%Y%m%d%H%M%S")

    def _tracked_files(self, directory: pathlib.Path) -> list[pathlib.Path]:
        """Files tracked by git or not ignored, so .DS_Store & co are never linked."""
        output = run(
            [
                "git", "-C", str(REPO_ROOT), "ls-files", "-z",
                "--cached", "--others", "--exclude-standard",
                "--", str(directory.relative_to(REPO_ROOT)),
            ],
            mutates=False,
        ).stdout.decode("utf-8")
        return sorted({REPO_ROOT / p for p in output.split("\0") if p})

    def _symlink(self, source: pathlib.Path, destination: pathlib.Path, indent_level: int = 0) -> None:
        if not source.exists():
            raise FileNotFoundError(f"Dotfile source {source} does not exist")

        if destination.is_symlink() and pathlib.Path(os.readlink(destination)) == source:
            self._unchanged += 1
            return

        tree_print(
            f"Linking {TerminalColors.CYAN}{destination}{TerminalColors.RESET} --> {TerminalColors.CYAN}{source}{TerminalColors.RESET}",
            indent_level=indent_level,
        )
        if destination.exists() and not destination.is_symlink():
            backup = destination.with_name(f"{destination.name}.{self._backup_suffix}")
            tree_print(
                f"{TerminalColors.YELLOW}Moving existing {destination} to {backup}{TerminalColors.RESET}",
                indent_level=indent_level + 1,
            )
            if not is_dry_run():
                destination.rename(backup)

        if is_dry_run():
            return

        destination.parent.mkdir(parents=True, exist_ok=True)
        if destination.is_symlink():
            destination.unlink()
        destination.symlink_to(source)

    def _symlink_directory(self, source: pathlib.Path, destination: pathlib.Path) -> None:
        tree_print(f"Populating {TerminalColors.CYAN}{destination}{TerminalColors.RESET}")
        # A symlink to a directory would make us write links into the repository itself
        if destination.is_symlink():
            tree_print(f"Replacing symlink {destination} with a real directory", indent_level=1)
            if not is_dry_run():
                destination.unlink()

        for f in self._tracked_files(source):
            self._symlink(f, destination / f.relative_to(source), indent_level=1)

    def exec(self) -> None:
        super().exec()
        for destination, source in self.FILES.items():
            if isinstance(source, str):
                self._symlink(REPO_ROOT / source, HOME / destination)
            elif source.recursive:
                self._symlink_directory(REPO_ROOT / source.source, HOME / destination)
            else:
                self._symlink(REPO_ROOT / source.source, HOME / destination)

        tree_print(f"{TerminalColors.GREEN}{self._unchanged} links already up to date{TerminalColors.RESET}")
