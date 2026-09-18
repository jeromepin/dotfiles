import dataclasses
import typing

from .packages import IPackage
from .shell import (
    TermincalColors,
    run_shell_command,
    run_shell_command_with_pty,
    tree_print,
)


@dataclasses.dataclass
class IPackageManager:
    package_type: typing.ClassVar[type[IPackage]]

    def list_installed_packages(self) -> list: ...

    def install(self): ...

    def remove(self): ...

    def _run(self, command: list[str]): ...


@dataclasses.dataclass
class EgetPackageManager(IPackageManager):
    binaries: list[str]

    def _run(self, command: list[str]):
        run_shell_command_with_pty(["eget"] + command)

    def _install(self, repository: str):
        tree_print(
            f"Installing {TermincalColors.GREEN}{repository}{TermincalColors.RESET}",
            indent_level=2,
        )
        self._run([repository])

    def install(self, update: bool = False):
        tree_print("Installing Eget binaries")
        for binary in self.binaries:
            self._install(binary)
