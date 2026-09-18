import dataclasses
import tempfile
import typing

from .nixpackagemanager import NixPackageManager
from .packagemanager import EgetPackageManager
from .shell import (
    TermincalColors,
    binary_path,
    run_shell_command,
    tree_print,
)


@dataclasses.dataclass
class IPackageList:
    CURRENT_NIX_STABLE_BRANCH: typing.ClassVar[str]
    COMMON_HOMEBREW_PACKAGES: typing.ClassVar[list[str]] = dataclasses.field(
        init=False, repr=False
    )
    COMMON_NIX_PACKAGES: typing.ClassVar[list[str]] = dataclasses.field(
        init=False, repr=False
    )

    HOMEBREW_PACKAGES: typing.ClassVar[list[str]] = dataclasses.field(
        init=False, repr=False
    )
    NIX_PACKAGES: typing.ClassVar[list[str]] = dataclasses.field(init=False, repr=False)
    EGET_BINARIES: typing.ClassVar[list[str]] = dataclasses.field(
        init=False,
        repr=False,
    )

    HOMEBREW_BIN_PATH = str(binary_path("brew"))

    def install_homebrew_packages(self, update: bool = False, upgrade: bool = False):
        packages = sorted(self.COMMON_HOMEBREW_PACKAGES + self.HOMEBREW_PACKAGES)
        tree_print(f"Installing Homebrew Casks [{len(packages)}]")

        with tempfile.NamedTemporaryFile(delete=False) as f:
            for package in packages:
                tree_print(
                    f"{TermincalColors.CYAN}{package}{TermincalColors.RESET}",
                    indent_level=1,
                )
                kind, name = package.split(" ")
                formatted_line = f'{kind} "{name}"\n'.encode("utf-8")
                f.write(formatted_line)

            f.flush()

            cmd = [self.HOMEBREW_BIN_PATH, "bundle", "install", f"--file={str(f.name)}"]
            if not upgrade:
                cmd.append("--no-upgrade")
            output = run_shell_command(
                cmd,
            )

            if len(output.stdout.decode("utf-8")) > 0:
                tree_print(
                    f"{TermincalColors.GREEN}{output.stdout.decode('utf-8')}{TermincalColors.RESET}",
                    indent_level=1,
                )
            if len(output.stderr.decode("utf-8")) > 0:
                tree_print(
                    f"{TermincalColors.RED}{output.stderr.decode('utf-8')}{TermincalColors.RESET}",
                    indent_level=1,
                )

        # installed_casks = []
        # if not upgrade:
        #     installed_casks: list[str] = (
        #         run_shell_command(
        #             [self.HOMEBREW_BIN_PATH, "list", "--cask", "-1"],
        #         )
        #         .stdout.decode("utf-8")
        #         .split("\n")
        #     )

        # for cask in sorted(self.COMMON_HOMEBREW_CASKS + self.HOMEBREW_CASKS):
        #     tree_print(
        #         f"{TermincalColors.CYAN}{cask}{TermincalColors.RESET}", indent_level=1
        #     )

        #     if not upgrade and cask in installed_casks:
        #         tree_print(
        #             f"{TermincalColors.GREEN}Already installed !{TermincalColors.RESET}",
        #             indent_level=2,
        #         )
        #         continue

        #     run_shell_command(
        #         [self.HOMEBREW_BIN_PATH, "install", "--cask", cask],
        #     )

    def install_nix_packages(self, update: bool = False, upgrade: bool = False):
        nix = NixPackageManager(
            current_stable_branch=self.CURRENT_NIX_STABLE_BRANCH,
            packages=self.COMMON_NIX_PACKAGES + self.NIX_PACKAGES,
        )

        if upgrade:
            nix.upgrade()
        else:
            nix.install(update)
            nix.remove()

    def install_eget_packages(self):
        eget = EgetPackageManager(
            binaries=self.EGET_BINARIES,
        )

        eget.install()

    def install(self, update: bool = False, upgrade: bool = False):
        self.install_homebrew_packages(update, upgrade)
        self.install_nix_packages(update, upgrade)
        self.install_eget_packages()
