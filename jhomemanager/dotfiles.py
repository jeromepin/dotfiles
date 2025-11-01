import dataclasses
import os
import pathlib

from .installationstage import InstallationStage
from .shell import TermincalColors, tree_print

HOME = pathlib.Path(os.path.expanduser("~"))


class DotFilesInstallationStage(InstallationStage):
    @dataclasses.dataclass
    class SourceDotfile:
        source: str
        recursive: bool = False

    FILES: dict[str, str | SourceDotfile] = {}

    def _symlink(
        self, source: pathlib.Path, destination: pathlib.Path, tree_print_level: int = 0
    ):
        tree_print(
            f"Symlinking {TermincalColors.CYAN}{destination}{TermincalColors.RESET} --> {TermincalColors.CYAN}{source}{TermincalColors.RESET}",
            indent_level=tree_print_level,
        )

        if source.is_file():
            destination.parent.mkdir(parents=True, exist_ok=True)

        destination.unlink(missing_ok=True)

        destination.symlink_to(source.absolute())

    def _symlink_directory(self, source: pathlib.Path, destination: pathlib.Path):
        if source.is_dir():
            tree_print(
                f"Creating {TermincalColors.CYAN}{destination}{TermincalColors.RESET}",
                indent_level=0,
            )
            destination.mkdir(parents=True, exist_ok=True)

        for f in source.rglob("*"):
            if f.is_file():
                self._symlink(f, HOME / f, tree_print_level=1)
            elif f.is_dir():
                (HOME / f).mkdir(parents=True, exist_ok=True)

    def exec(self) -> None:
        super().exec()
        for destination, source in self.FILES.items():
            if isinstance(source, str):
                self._symlink(
                    pathlib.Path(source), HOME / destination, tree_print_level=0
                )
            elif isinstance(source, DotFilesInstallationStage.SourceDotfile):
                self._symlink_directory(pathlib.Path(source.source), HOME / destination)
