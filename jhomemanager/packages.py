import dataclasses
import tempfile
import typing

from .shell import TermincalColors, run_shell_command, tree_print, binary_path


@dataclasses.dataclass
class IPackageList:
    CURRENT_NIX_STABLE_BRANCH: typing.ClassVar[str]
    COMMON_HOMEBREW_CASKS: typing.ClassVar[list[str]] = dataclasses.field(
        init=False, repr=False
    )
    COMMON_NIX_PACKAGES: typing.ClassVar[list[str]] = dataclasses.field(
        init=False, repr=False
    )

    HOMEBREW_CASKS: typing.ClassVar[list[str]] = dataclasses.field(
        init=False, repr=False
    )
    NIX_PACKAGES: typing.ClassVar[list[str]] = dataclasses.field(init=False, repr=False)

    HOMEBREW_BIN_PATH = str(binary_path("brew"))

    def _transform_nix_package_into_full_reference(self, package_name: str) -> str:
        # https://status.nixos.org/
        # P -> nixpkgs/nixpkgs-25.05-darwin#P
        # unstable.P -> nixpkgs/nixpkgs-unstable#P
        # nixpkgs/COMMIT_SHA#P -> nixpkgs/COMMIT_SHA#P

        if not isinstance(self.CURRENT_NIX_STABLE_BRANCH, str):
            raise RuntimeError("`CURRENT_NIX_STABLE_BRANCH` constant not provided")

        if package_name.startswith("unstable."):
            return f"nixpkgs/nixpkgs-unstable#{package_name.removeprefix('unstable.')}"

        elif "#" not in package_name:
            return f"nixpkgs/nixpkgs-{self.CURRENT_NIX_STABLE_BRANCH}-darwin#{package_name}"

        return package_name

    def install_homebrew_packages(self, upgrade: bool = False):
        tree_print("Installing Homebrew Casks")

        with tempfile.NamedTemporaryFile(delete=False) as f:
            for cask in sorted(self.COMMON_HOMEBREW_CASKS + self.HOMEBREW_CASKS):
                tree_print(
                    f"{TermincalColors.CYAN}{cask}{TermincalColors.RESET}", indent_level=1
                )
                f.write(f"cask \"{cask}\"\n".encode("utf-8"))

            # TODO: stdout keep being : `brew bundle` complete! 0 Brewfile dependencies now installed.
            # while it should list `12` instead of `0`
            output = run_shell_command(
                [self.HOMEBREW_BIN_PATH, "bundle", "install", "--no-upgrade" if not upgrade else "", f"--file={str(f.name)}"]
            )

            if len(output.stdout.decode("utf-8")) > 0:
                tree_print(
                    f"{TermincalColors.GREEN}{output.stdout.decode("utf-8")}{TermincalColors.RESET}", indent_level=1
                )
            if len(output.stderr.decode("utf-8")) > 0:
                tree_print(
                    f"{TermincalColors.RED}{output.stderr.decode("utf-8")}{TermincalColors.RESET}", indent_level=1
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

    def install_nix_packages(self, upgrade: bool = False):
        tree_print("Installing Nix packages")

        def group_by_channels(packages: list[str]) -> dict[str, list[str]]:
            channels: dict[str, list[str]] = {}
            for p in packages:
                channel = p.split("#")[0].replace("nixpkgs/", "")
                if channel not in channels:
                    channels[channel] = []

                channels[channel].append(p)

            return channels

        # TODO: handle override. For example : (P and unstable.P) or (P and nixpkgs/COMMIT_SHA#P)
        packages_by_channel = group_by_channels(
            sorted(
                [
                    self._transform_nix_package_into_full_reference(p)
                    for p in self.COMMON_NIX_PACKAGES + self.NIX_PACKAGES
                ]
            )
        )

        for channel, packages in packages_by_channel.items():
            tree_print(
                f"From channel {TermincalColors.CYAN}{channel}{TermincalColors.RESET}",
                indent_level=1,
            )
            run_shell_command(["nix", "profile", "install"] + packages)

    def install(self, upgrade: bool = False):
        self.install_homebrew_packages(upgrade)
        self.install_nix_packages(upgrade)
