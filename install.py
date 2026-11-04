#!/usr/bin/env python3

from __future__ import annotations

import dataclasses
import pathlib

from jhomemanager import (
    REPO_ROOT,
    DotFilesInstallationStage,
    InstallationStage,
    IPackageList,
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


main(
    stages={
        "home": Home(),
        "packages": Packages(),
        "upgrade-packages": Packages(upgrade=True),
        "system": System(),
    },
    default_stages=["home", "packages", "system"],
)
