from __future__ import annotations

from .config import PACKAGES_DIR, host_config
from .installationstage import InstallationStage
from .nixpackagemanager import NixProfileManager
from .packagemanager import EgetPackageManager, HomebrewPackageManager


class PackagesInstallationStage(InstallationStage):
    """Installs what packages/packages.toml declares for this machine."""

    REQUIRED_BINARIES = ("brew", "nix")
    TITLE = "packages"

    def __init__(self, upgrade: bool = False):
        self.upgrade = upgrade

    @property
    def help(self) -> str:
        if self.upgrade:
            return "move Nix channels to their latest version and upgrade Homebrew packages"
        return "install and remove packages to match packages/packages.toml"

    @property
    def description(self) -> str:
        if self.upgrade:
            return """\
Upgrade the packages of this Mac:
  - Nix: move every channel of packages/flake.nix to its latest commit, which rewrites
    packages/flake.lock (commit it so other Macs get the same versions), then apply.
  - Homebrew: upgrade the declared packages that are outdated.
  - eget: download releases newer than the installed binaries.
The plan lists each version change (--dry-run works on a copy of flake.lock)."""
        return """\
Install and remove packages to match packages/packages.toml for this Mac
(the [hosts.<name>] whose computer_name is `scutil --get ComputerName`, plus [common]):
  - Homebrew: installs what's missing, lists what was installed by hand but isn't declared
    (never removed automatically).
  - Nix: keeps one profile entry for this Mac, built by packages/flake.nix with the versions
    pinned in packages/flake.lock. Undo with `nix profile rollback`.
  - eget: downloads release binaries from GitHub."""

    def exec(self) -> None:
        super().exec()
        host = host_config()
        HomebrewPackageManager(host.homebrew).apply(self.upgrade)
        NixProfileManager(PACKAGES_DIR, host.name).apply(self.upgrade)
        EgetPackageManager(host.eget).apply(self.upgrade)
