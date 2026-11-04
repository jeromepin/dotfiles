from __future__ import annotations

import typing

from .nixpackagemanager import NixPackageManager
from .packagemanager import EgetPackageManager, HomebrewPackageManager


class IPackageList:
    CURRENT_NIX_STABLE_BRANCH: typing.ClassVar[str] = ""

    # Shared by every machine
    COMMON_HOMEBREW_PACKAGES: typing.ClassVar[typing.Sequence[str]] = ()
    COMMON_NIX_PACKAGES: typing.ClassVar[typing.Sequence[str]] = ()

    # Machine specific
    HOMEBREW_PACKAGES: typing.ClassVar[typing.Sequence[str]] = ()
    NIX_PACKAGES: typing.ClassVar[typing.Sequence[str]] = ()
    EGET_BINARIES: typing.ClassVar[typing.Sequence[str]] = ()

    def install(self, upgrade: bool = False) -> None:
        HomebrewPackageManager([*self.COMMON_HOMEBREW_PACKAGES, *self.HOMEBREW_PACKAGES]).apply(upgrade)
        NixPackageManager(
            [*self.COMMON_NIX_PACKAGES, *self.NIX_PACKAGES],
            stable_branch=self.CURRENT_NIX_STABLE_BRANCH,
        ).apply(upgrade)
        EgetPackageManager(self.EGET_BINARIES).apply(upgrade)
