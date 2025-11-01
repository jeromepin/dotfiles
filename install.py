#!/usr/bin/env python3

import dataclasses
import pathlib

from jhomemanager import IPackageList, get_machine_name, InstallationStage, DotFilesInstallationStage, MacOSUserLaunchAgent, tree_print, run_shell_command, build_parser, TermincalColors

CURRENT_NIX_STABLE_BRANCH = "25.05"


class CommonPackageList(IPackageList):
    COMMON_HOMEBREW_CASKS = [
        "brave-browser",
        "firefox",
        "ghostty",
        "google-chrome",
        "lunar",
        "orbstack",
        "rectangle",
        "spotify",
        "visual-studio-code",
        "vlc",
    ]

    COMMON_NIX_PACKAGES = [
        "bash-completion",
        "cmake",
        "file",
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
        "kubectl",
        "git-crypt",
        "gnupg",
        # "(google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])",
        "gcsfuse",
        "ipcalc",
        "kubectl",
        "kubectx",
        "kubelogin",
        "kubernetes-helm",
        "postgresql_16",
        "sops",
        "wireguard-go",
        "wireguard-tools",
        "unstable.basedpyright",
        "unstable.delve",
        "unstable.dogdns",
        "unstable.eget",
        "unstable.git-revise",
        "unstable.k9s",
        "unstable.nmap",
        "unstable.pgcli",
        "unstable.rdap",
        "unstable.terraform-ls",
    ]

@dataclasses.dataclass
class Packages(InstallationStage):
    upgrade: bool = dataclasses.field(init=True, default=False)

    def exec(self) -> None:
        super().exec()
        {
            "218300622L": WorkLaptopPackages()
        }[get_machine_name()].install(upgrade=self.upgrade)

class Home(DotFilesInstallationStage):
    # destination: source
    FILES : dict[str, str | DotFilesInstallationStage.SourceDotfile] = {
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
            tree_print(f"{TermincalColors.GREEN}Already enabled !{TermincalColors.RESET}", indent_level=1)
            return

        run_shell_command(["sudo", "cp", pam_file.name, str(pam_file)])

    def exec(self) -> None:
        super().exec()
        MacOSUserLaunchAgent(filename="org.nixos.add-to-ssh-agent.plist", attributes={
            "KeepAlive": False,
            "Label": "org.nixos.add-to-ssh-agent",
            "ProgramArguments": [
                "/bin/sh",
                "-c",
                "/bin/wait4path /nix/store &amp;&amp; exec ssh-add --apple-use-keychain",
            ],
            "RunAtLoad": True
        })
        self.sudo_with_touchid()

build_parser({
    "home": Home(),
    "packages": Packages(upgrade=False),
    "upgrade-packages": Packages(upgrade=True),
    "system": System(),
})