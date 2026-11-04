#!/usr/bin/env python3

from __future__ import annotations

import dataclasses
import pathlib

from jhomemanager import (
    HOME,
    REPO_ROOT,
    DotFilesInstallationStage,
    InstallationStage,
    IPackageList,
    MacOSDefault,
    MacOSDefaults,
    MacOSUserLaunchAgent,
    TerminalColors,
    for_this_machine,
    main,
    run_interactive,
    tree_print,
)

CURRENT_NIX_STABLE_BRANCH = "25.11"


class CommonPackageList(IPackageList):
    COMMON_HOMEBREW_PACKAGES = [
        "cask brave-browser",
        "cask firefox",
        "cask ghostty",
        "cask google-chrome",
        "cask lunar",
        "cask orbstack",
        "cask rectangle",
        "cask spotify",
        "cask vlc",
        "cask zed",
    ]

    COMMON_NIX_PACKAGES = [
        "bash",
        "bash-completion",
        "cmake",
        "file",
        "findutils",
        "fira-code",
        "fira-code-nerdfont",
        "getopt",
        "gnused",
        "gnupg",
        "go",
        "pipx",
        "python3",
        "socat",
        "tree",
        "unixtools.watch",
        "zig_0_12",
        "unstable.ast-grep",
        "unstable.bat",
        "unstable.bun",
        "unstable.cargo",
        "unstable.coreutils",
        "unstable.delta",
        "unstable.difftastic",
        "unstable.fd",
        "unstable.fish",
        "unstable.fzf",
        "unstable.eza",
        "unstable.gh",
        "unstable.git",
        "unstable.git-absorb",
        "unstable.gitu",
        "unstable.glow",
        "unstable.helix",
        "unstable.hexyl",
        "unstable.hyperfine",
        "unstable.htop",
        "unstable.httpie",
        "unstable.ijq",
        "unstable.jujutsu",
        "unstable.jq",
        "unstable.most",
        "unstable.neovim",
        "unstable.ripgrep",
        "unstable.ruff",
        "unstable.sd",
        "unstable.serpl",
        "unstable.starship",
        "unstable.sttr",
        "unstable.tealdeer",
        "unstable.television",
        "unstable.tig",
        "unstable.tree-sitter",
        "unstable.uv",
        "unstable.wget",
        "unstable.zola",
    ]


class WorkLaptopPackages(CommonPackageList):
    CURRENT_NIX_STABLE_BRANCH = CURRENT_NIX_STABLE_BRANCH
    HOMEBREW_CASKS = [
        "obsidian",
        "slack",
    ]
    NIX_PACKAGES = [
        "argocd",
        "git-crypt",
        # "(google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])",
        "nixpkgs/nixpkgs-24.05-darwin#gcsfuse",
        "ipcalc",
        "kubectl",
        "kubectx",
        "kubelogin",
        "kubernetes-helm",
        "kustomize",
        "pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin",
        "postgresql_16",
        "sops",
        "wireguard-go",
        "wireguard-tools",
        "unstable.basedpyright",
        "unstable.container",
        "unstable.crane",
        "unstable.cri-tools",
        "unstable.delve",
        "unstable.docker-credential-gcr",
        "unstable.dogdns",
        "unstable.eget",
        "unstable.graphviz",
        "unstable.git-revise",
        "unstable.k9s",
        "unstable.nmap",
        "unstable.pgcli",
        "unstable.rdap",
        "unstable.terraform-ls",
    ]


# Key: `scutil --get ComputerName`
MACHINES: dict[str, type[IPackageList]] = {
    "218300622L": WorkLaptopPackages,
}


@dataclasses.dataclass
class Packages(InstallationStage):
    upgrade: bool = False

    REQUIRED_BINARIES = ("brew", "nix")

    def exec(self) -> None:
        super().exec()
        for_this_machine(MACHINES)().install(upgrade=self.upgrade)


class Home(DotFilesInstallationStage):
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
        "packages": Packages(),
        "upgrade-packages": Packages(upgrade=True),
        "system": System(),
    },
    default_stages=["home", "packages", "system"],
)
