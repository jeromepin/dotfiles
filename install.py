#!/usr/bin/env python3

from __future__ import annotations

import pathlib

from jhomemanager import (
    HOME,
    REPO_ROOT,
    DotFilesInstallationStage,
    InstallationStage,
    MacOSDefault,
    MacOSDefaults,
    BootstrapInstallationStage,
    GarbageCollectionStage,
    MacOSUserLaunchAgent,
    PackagesInstallationStage,
    TerminalColors,
    main,
    run_interactive,
    tree_print,
)


class Home(DotFilesInstallationStage):
    HELP = "link the dotfiles of this repository into ~"
    DESCRIPTION = """\
Link the dotfiles of this repository into ~, as listed in Home.FILES (install.py).
Existing files are moved to <name>.backup-<timestamp>, never deleted."""

    # destination: source
    FILES: dict[str, str | DotFilesInstallationStage.SourceDotfile] = {
        ".bashrc.d": DotFilesInstallationStage.SourceDotfile(
            source=".bashrc.d",
            recursive=True,
        ),
        ".bashrc": ".bashrc",
        ".config/bat/config": ".config/bat/config",
        ".config/fish/conf.d/10_aliases.fish": ".config/fish/conf.d/10_aliases.fish",
        ".config/fish/conf.d/20_env.fish": ".config/fish/conf.d/20_env.fish",
        ".config/fish/conf.d/30_path.fish": ".config/fish/conf.d/30_path.fish",
        ".config/fish/conf.d/50_shell.fish": ".config/fish/conf.d/50_shell.fish",
        ".config/fish/functions/base64.fish": ".config/fish/functions/base64.fish",
        ".config/fish/functions/misc.fish": ".config/fish/functions/misc.fish",
        ".config/ghostty/config": ".config/ghostty/config",
        ".config/gitu": ".config/gitu",
        ".config/helix/config.toml": ".config/helix/config.toml",
        ".config/helix/languages.toml": ".config/helix/languages.toml",
        ".config/nix/nix.conf": ".config/nix/nix.conf",
        ".config/nvim": DotFilesInstallationStage.SourceDotfile(
            source=".config/nvim",
            recursive=True,
        ),
        ".config/television": DotFilesInstallationStage.SourceDotfile(
            source=".config/television",
            recursive=True,
        ),
        ".config/.ripgreprc": ".config/.ripgreprc",
        ".config/starship.toml": ".config/starship.toml",
        ".config/wezterm": DotFilesInstallationStage.SourceDotfile(
            source=".config/wezterm",
            recursive=True,
        ),
        ".gitconfig": ".gitconfig",
        ".gitignore": "global_gitignore",
        ".inputrc": ".inputrc",
        "bin": "bin",
    }


MACOS_SETTINGS = [
    # Dock: hide automatically, show instantly, small icons, no magnification, no recent apps,
    # minimize windows into their app icon
    MacOSDefault("com.apple.dock", "autohide", True),
    MacOSDefault("com.apple.dock", "autohide-delay", 0.0),
    MacOSDefault("com.apple.dock", "tilesize", 31.0),
    MacOSDefault("com.apple.dock", "magnification", False),
    MacOSDefault("com.apple.dock", "show-recents", False),
    MacOSDefault("com.apple.dock", "minimize-to-application", True),
    # Hot corners: top-left locks the screen (13), bottom-right does nothing (1)
    MacOSDefault("com.apple.dock", "wvous-tl-corner", 13),
    MacOSDefault("com.apple.dock", "wvous-tl-modifier", 0),
    MacOSDefault("com.apple.dock", "wvous-br-corner", 1),
    MacOSDefault("com.apple.dock", "wvous-br-modifier", 0),
    # Windows: double-clicking a title bar minimizes, no gaps between tiled windows,
    # hide Desktop items in Stage Manager
    MacOSDefault("NSGlobalDomain", "AppleActionOnDoubleClick", "Minimize"),
    MacOSDefault("com.apple.WindowManager", "EnableTiledWindowMargins", False),
    MacOSDefault("com.apple.WindowManager", "HideDesktop", True),
    # Finder: file extensions, path bar, column view by default, new windows open $HOME,
    # folders open in windows (not tabs), no recent tags in the sidebar,
    # Trash emptied after 30 days, internal disks and servers on the Desktop
    MacOSDefault("NSGlobalDomain", "AppleShowAllExtensions", True, restart="Finder"),
    MacOSDefault("com.apple.finder", "ShowPathbar", True),
    MacOSDefault("com.apple.finder", "FXPreferredViewStyle", "clmv"),
    MacOSDefault("com.apple.finder", "NewWindowTarget", "PfHm"),
    MacOSDefault("com.apple.finder", "NewWindowTargetPath", f"file://{HOME}/"),
    MacOSDefault("com.apple.finder", "FinderSpawnTab", False),
    MacOSDefault("com.apple.finder", "ShowRecentTags", False),
    MacOSDefault("com.apple.finder", "FXRemoveOldTrashItems", True),
    MacOSDefault("com.apple.finder", "ShowHardDrivesOnDesktop", True),
    MacOSDefault("com.apple.finder", "ShowMountedServersOnDesktop", True),
    # No .DS_Store on network shares and USB drives
    MacOSDefault("com.apple.desktopservices", "DSDontWriteNetworkStores", True),
    MacOSDefault("com.apple.desktopservices", "DSDontWriteUSBStores", True),
    # Keyboard: fast key repeat
    MacOSDefault("NSGlobalDomain", "KeyRepeat", 2),
    MacOSDefault("NSGlobalDomain", "InitialKeyRepeat", 15),
    # Trackpad: tap to click (built-in and Bluetooth trackpads, login screen),
    # no natural scrolling, fast pointer
    MacOSDefault("com.apple.AppleMultitouchTrackpad", "Clicking", True),
    MacOSDefault("com.apple.driver.AppleBluetoothMultitouch.trackpad", "Clicking", True),
    MacOSDefault("NSGlobalDomain", "com.apple.mouse.tapBehavior", 1, current_host=True),
    MacOSDefault("NSGlobalDomain", "com.apple.swipescrolldirection", False),
    MacOSDefault("NSGlobalDomain", "com.apple.trackpad.scaling", 2.0),
    # No interface sound effects
    MacOSDefault("NSGlobalDomain", "com.apple.sound.uiaudio.enabled", 0),
    # Safari: Develop menu (needs Full Disk Access for the terminal; applies at next Safari launch)
    MacOSDefault("com.apple.Safari", "IncludeDevelopMenu", True),
    MacOSDefault("com.apple.Safari", "WebKitDeveloperExtrasEnabledPreferenceKey", True),
    MacOSDefault("com.apple.Safari", "WebKitPreferences.developerExtrasEnabled", True),
]


class System(InstallationStage):
    HELP = "LaunchAgents, sudo with TouchID and macOS settings"
    DESCRIPTION = """\
Configure macOS for the current user, as declared in install.py:
  - LaunchAgents (loaded with launchctl, reloaded only when changed),
  - sudo with TouchID (/etc/pam.d/sudo_local, asks for your password once),
  - macOS settings (MACOS_SETTINGS, written with `defaults` only when different;
    Dock and Finder are restarted, some settings need a logout)."""

    def sudo_with_touchid(self) -> None:
        tree_print("Enabling sudo using TouchID")
        source = REPO_ROOT / "sudo_local"
        pam_file = pathlib.Path("/etc/pam.d/sudo_local")
        if pam_file.exists() and pam_file.read_bytes() == source.read_bytes():
            tree_print(
                f"{TerminalColors.GREEN}Already enabled !{TerminalColors.RESET}",
                indent_level=1,
            )
            return

        run_interactive(
            ["sudo", "install", "-m", "0444", "-o", "root", "-g", "wheel", str(source), str(pam_file)]
        )

    def exec(self) -> None:
        super().exec()
        MacOSUserLaunchAgent(
            label="org.nixos.add-to-ssh-agent",
            attributes={
                "KeepAlive": False,
                "ProgramArguments": ["/usr/bin/ssh-add", "--apple-load-keychain"],
                "RunAtLoad": True,
            },
        ).install()
        self.sudo_with_touchid()
        MacOSDefaults(MACOS_SETTINGS).apply()


main(
    stages={
        "home": Home(),
        "packages": PackagesInstallationStage(),
        "upgrade-packages": PackagesInstallationStage(upgrade=True),
        "system": System(),
        "bootstrap": BootstrapInstallationStage(),
        "gc": GarbageCollectionStage(),
    },
    default_stages=["home", "packages", "system"],
)
