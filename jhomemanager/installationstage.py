from __future__ import annotations

from .shell import binary_path


class InstallationStage:
    REQUIRED_BINARIES: tuple[str, ...] = ()
    TITLE: str | None = None  # defaults to the class name
    HELP = ""  # one line, in `install.py --help`
    DESCRIPTION: str | None = None  # in `install.py <command> --help`, defaults to HELP

    @property
    def help(self) -> str:
        return self.HELP

    @property
    def description(self) -> str:
        return self.DESCRIPTION or self.help

    def exec(self) -> None:
        print(f"\n[{(self.TITLE or self.__class__.__name__).upper()}]")
        for binary in self.REQUIRED_BINARIES:
            binary_path(binary)
