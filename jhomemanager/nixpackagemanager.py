import dataclasses
import json
import typing

from .packagemanager import IPackageManager
from .packages import NixPackage
from .shell import (
    TermincalColors,
    run_shell_command,
    run_shell_command_with_pty,
    tree_print,
)


@dataclasses.dataclass
class NixPackageManager(IPackageManager):
    packages: list[str]
    current_stable_branch: str
    installed_packages: list[NixPackage] = dataclasses.field(
        init=False, repr=False, default_factory=lambda: []
    )
    wanted_packages_by_channel: dict[str, list[NixPackage]] = dataclasses.field(
        init=False, repr=False, default_factory=lambda: {}
    )
    installed_packages_by_channel: dict[str, list[NixPackage]] = dataclasses.field(
        init=False, repr=False, default_factory=lambda: {}
    )

    def __post_init__(self):
        if not isinstance(self.current_stable_branch, str):
            raise RuntimeError("`CURRENT_NIX_STABLE_BRANCH` constant not provided")

        self.installed_packages = self.list_installed_packages()
        self.packages.sort()

        # TODO: handle override. For example : (P and unstable.P) or (P and nixpkgs/COMMIT_SHA#P)
        self.wanted_packages_by_channel = self.group_by_channels(
            [
                NixPackage.new_from_str(p, self.current_stable_branch)
                for p in self.packages
            ]
        )
        self.installed_packages_by_channel = self.group_by_channels(
            self.installed_packages
        )

    def group_by_channels(
        self, packages: list[NixPackage]
    ) -> dict[str, list[NixPackage]]:
        channels = {}
        for p in packages:
            if p.channel_or_commit not in channels:
                channels[p.channel_or_commit] = []

            channels[p.channel_or_commit].append(p)

        return channels

    def list_installed_packages(self) -> list[NixPackage]:
        installed_packages = []
        for _, package_attr in (
            typing.cast(
                dict[str, dict[str, typing.Any]],
                json.loads(
                    run_shell_command(
                        ["nix", "profile", "list", "--json"]
                    ).stdout.decode("utf-8")
                ),
            )
            .get("elements", {})
            .items()
        ):
            channel = package_attr["originalUrl"]
            name = package_attr["attrPath"].removeprefix(
                "legacyPackages.aarch64-darwin."
            )
            installed_packages.append(
                NixPackage(f"{channel}#{name}".removeprefix("flake:"))
            )

        return installed_packages

    def _run(self, command: list[str]):
        run_shell_command_with_pty(["nix", "profile"] + command)

    def _update(self, package: NixPackage):
        tree_print(
            f"Updating {TermincalColors.GREEN}{package.name}{TermincalColors.RESET} within the same channel",
            indent_level=2,
        )
        self._run(["upgrade", package.name])

    def _install(self, package: NixPackage):
        tree_print(
            f"Installing {TermincalColors.GREEN}{package.name}{TermincalColors.RESET}",
            indent_level=2,
        )
        self._run(["install", package.reference])

    def install(self, update: bool = False):
        tree_print("Installing Nix packages (https://status.nixos.org/)")

        for channel, wanted_packages in self.wanted_packages_by_channel.items():
            tree_print(
                f"From channel {TermincalColors.CYAN}{channel}{TermincalColors.RESET}",
                indent_level=1,
            )

            missing_packages = set(wanted_packages) - set(
                self.installed_packages_by_channel.get(channel, [])
            )

            for package in missing_packages:
                if update:
                    self._update(package)
                else:
                    self._install(package)

    def _remove(self, package: NixPackage):
        tree_print(
            f"Removing {TermincalColors.GREEN}{package.name}{TermincalColors.RESET}",
            indent_level=2,
        )
        self._run(["remove", package.name])

    def remove(self):
        tree_print("Removing Nix packages (https://status.nixos.org/)")

        for channel, wanted_packages in self.wanted_packages_by_channel.items():
            tree_print(
                f"From channel {TermincalColors.CYAN}{channel}{TermincalColors.RESET}",
                indent_level=1,
            )

            leftover_packages = set(
                self.installed_packages_by_channel.get(channel, [])
            ) - set(wanted_packages)

            for package in leftover_packages:
                self._remove(package)

    def upgrade(self):
        packages = {
            c: p
            for c, p in self.group_by_channels(self.list_installed_packages()).items()
            if c.startswith("nixpkgs-") and c.endswith("-darwin")
        }
        main_channel = sorted(packages, key=lambda k: len(packages[k]), reverse=True)[0]
        installed_packages_from_main_channel = self.group_by_channels(
            self.list_installed_packages()
        )[main_channel]

        if f"nixpkgs-{self.current_stable_branch}-darwin" == main_channel:
            raise Exception(
                f"CURRENT_NIX_STABLE_BRANCH is the same as the one from which packages are installed : {self.current_stable_branch}"
            )

        tree_print(
            f"From channel {TermincalColors.CYAN}{main_channel}{TermincalColors.RESET}",
            indent_level=1,
        )
        for package in installed_packages_from_main_channel:
            self._remove(package)

        tree_print(
            f"From channel {TermincalColors.CYAN}nixpkgs-{self.current_stable_branch}-darwin{TermincalColors.RESET}",
            indent_level=1,
        )
        for package in installed_packages_from_main_channel:
            self._install(
                NixPackage(
                    package.reference.replace(
                        main_channel, f"nixpkgs-{self.current_stable_branch}-darwin"
                    )
                )
            )
