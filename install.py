#!/usr/bin/env python3

import dataclasses
import pathlib

from jhomemanager import (
    DotFilesInstallationStage,
    InstallationStage,
    IPackageList,
    MacOSUserLaunchAgent,
    TermincalColors,
    build_parser,
    get_machine_name,
    run_shell_command,
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
        "kubectl",
        "git-crypt",
        "gnupg",
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


@dataclasses.dataclass
class Packages(InstallationStage):
    update: bool = dataclasses.field(init=True, default=False)
    upgrade: bool = dataclasses.field(init=True, default=False)

    def exec(self) -> None:
        super().exec()
        {"218300622L": WorkLaptopPackages()}[get_machine_name()].install(
            update=self.update, upgrade=self.upgrade
        )


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
        pam_file = pathlib.Path("/etc/pam.d/sudo_local")
        if pam_file.exists():
            tree_print(
                f"{TermincalColors.GREEN}Already enabled !{TermincalColors.RESET}",
                indent_level=1,
            )
            return

        run_shell_command(["sudo", "cp", pam_file.name, str(pam_file)])

    def exec(self) -> None:
        super().exec()
        MacOSUserLaunchAgent(
            filename="org.nixos.add-to-ssh-agent.plist",
            attributes={
                "KeepAlive": False,
                "Label": "org.nixos.add-to-ssh-agent",
                "ProgramArguments": [
                    "/bin/sh",
                    "-c",
                    "/bin/wait4path /nix/store &amp;&amp; exec ssh-add --apple-use-keychain",
                ],
                "RunAtLoad": True,
            },
        )
        self.sudo_with_touchid()


build_parser(
    {
        "home": Home(),
        "packages": Packages(update=False, upgrade=False),
        "update-packages": Packages(update=True, upgrade=False),
        "upgrade-packages": Packages(update=False, upgrade=True),
        "system": System(),
    }
)
