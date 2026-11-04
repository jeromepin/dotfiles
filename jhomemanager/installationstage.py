from __future__ import annotations

from .shell import binary_path


class InstallationStage:
    REQUIRED_BINARIES: tuple[str, ...] = ()

    def exec(self) -> None:
        print(f"\n[{self.__class__.__name__.upper()}]")
        for binary in self.REQUIRED_BINARIES:
            binary_path(binary)
