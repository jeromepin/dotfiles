#!/usr/bin/env python3

import argparse
import collections
import os
import pathlib
import sys
from typing import Dict

DOTFILES_SOURCE_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__)))
HOME = pathlib.Path(os.path.expanduser("~"))


def _install_from_archive(
    archive_url: str, archive_format: str, binary_name: str = None
) -> None:
    archive_name = archive_url.split("/")[-1]
    download_path = f"{HOME}/Downloads/{archive_name}"
    installation_path = f"{HOME}/bin/{binary_name}"

    os.unlink(installation_path)
    _run_shell_command(f"wget --no-check-certificate -O {download_path} {archive_url}")

    if archive_format == "gz":
        _run_shell_command(f"gunzip --to-stdout {download_path} >> {installation_path}")
    elif archive_format == "zip":
        _run_shell_command(f"tar -xvf {download_path}")
        _run_shell_command(f"mv {binary_name} {installation_path}")

    _run_shell_command(f"chmod u+x {installation_path}")
    os.unlink(download_path)


def _run_shell_command(command: str):
    print(f"Running command : {command}")
    return os.system(command)


def _link(file: pathlib.Path, destination: pathlib.Path):
    if os.path.isfile(file) and os.path.isdir(destination):
        destination = destination / file

    print(f"Symlinking {DOTFILES_SOURCE_DIRECTORY / file} to {destination}")

    try:
        os.unlink(destination)
    except FileNotFoundError:
        pass

    os.symlink(DOTFILES_SOURCE_DIRECTORY / file, destination)


def _link_directory_content(directory: pathlib.Path):
    (HOME / directory).mkdir(parents=True, exist_ok=True)

    for f in os.listdir(directory):
        _link(directory / f, HOME / directory / f)


def prerequisites():
    ports = [
        "base64",
        "bash-completion",
        "broot",
        "file",
        "git",
        "gnupg2",
        "jq",
        "kube-ps1",
        "kubectx",
        "most",
        "neovim",
        "wget",
    ]
    _run_shell_command(f"sudo port install {' '.join(ports)}")


def bashrc():
    _link(pathlib.Path(".bashrc"), HOME)
    _link(pathlib.Path(".inputrc"), HOME)

    _link_directory_content(pathlib.Path(".bashrc.d"))

    print("Creating un-git-ed ~/.bashrc_local...")
    with open(HOME / ".bashrc_local", "w"):
        pass


def binaries():
    _link_directory_content(pathlib.Path("bin"))


def asdf():
    FZF_VERSION = "0.24.3"

    plugins = collections.OrderedDict(
        {
            "fd": {"versions": ["8.1.1"]},
            "fzf": {"versions": [FZF_VERSION]},
            "kubectl": {"versions": ["1.17.17"]},
            "python": {"versions": ["3.7.9"]},
            "ripgrep": {"versions": ["12.1.1"]},
            "rust": {"versions": ["1.50.0"]},
        }
    )

    if not os.path.isdir(HOME / ".asdf"):
        _run_shell_command(
            "git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0"
        )
        _run_shell_command('echo ". $HOME/.asdf/asdf.sh" > ~/.bash_profile')

    for plugin_name, plugin_def in plugins.items():
        _run_shell_command(f"asdf plugin add {plugin_name}")

        for version in plugin_def.get("versions"):
            _run_shell_command(f"asdf install {plugin_name} {version}")
            _run_shell_command(f"asdf global {plugin_name} {version}")

    _run_shell_command(f"~/.asdf/installs/fzf/{FZF_VERSION}/install")
    _run_shell_command(
        "NODEJS_CHECK_SIGNATURES=no asdf_install_enable_version nodejs 15.11.0"
    )


def vim():
    _link(pathlib.Path(".vimrc"), HOME)
    _link_directory_content(pathlib.Path(".config/nvim"))
    _run_shell_command("pip3 install pynvim")
    _run_shell_command("npm install -g neovim")
    _install_from_archive(
        "https://github.com/tree-sitter/tree-sitter/releases/download/v0.18.3/tree-sitter-macos-x64.gz",
        archive_format="gz",
        binary_name="tree-sitter",
    )
    _run_shell_command("vim +LspInstall python")
    # _run_shell_command("vim +LspInstall terraform")
    _run_shell_command("vim +TSInstall bash comment hcl json python yaml")


def misc():
    _link(pathlib.Path(".sshrc"), HOME)
    _link(pathlib.Path(".config/starship.toml"), HOME)


def git():
    _link(pathlib.Path(".gitconfig"), HOME)

    if not os.path.isdir(HOME / "bin/git-fuzzy-dir"):
        _run_shell_command(
            "git clone https://github.com/bigH/git-fuzzy.git ~/bin/git-fuzzy-dir"
        )

    git_fuzzy_bin_path = HOME / "bin/git-fuzzy"

    try:
        os.unlink(git_fuzzy_bin_path)
    except FileNotFoundError:
        pass

    os.symlink(HOME / "bin/git-fuzzy-dir/bin/git-fuzzy", git_fuzzy_bin_path)


# TODO: port to Python
#
# function copy_vscode_settings {
# 	if [ -d ${HOME}/Library/Application\ Support/Code ]
# 	then
# 		copy vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
# 		copy vscode/keybindings.json ${HOME}/Library/Application\ Support/Code/User/keybindings.json
# 		copy vscode/snippets ${HOME}/Library/Application\ Support/Code/User/snippets
# 	fi
# 	if [ -d ${HOME}/Library/Application\ Support/Code\ \~\ Insiders ]
# 	then
# 		copy vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
# 		copy vscode/keybindings.json ${HOME}/Library/Application\ Support/Code/User/keybindings.json
# 		copy vscode/snippets ${HOME}/Library/Application\ Support/Code/User/snippets
# 	fi

# 	for EXTENSION in "ms-python.python" "zhuangtongfa.material-theme" "editorconfig.editorconfig" "ms-python.vscode-pylance" "hashicorp.terraform" "wwm.better-align" "wayou.vscode-todo-highlight"
# 	do
# 		/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension "${EXTENSION}"
# 	done
# }


STAGES: Dict[str, str] = collections.OrderedDict(
    {
        "prerequisites": "prerequisites",
        "bash": "bashrc",
        "misc": "misc",
        "bin": "binaries",
        "git": "git",
        "ctags": "ctags",
        "asdf": "asdf",
        "vim": "vim",
    }
)

parser = argparse.ArgumentParser(description="Install my dotfiles using symlinks")
parser.add_argument(
    "--stage",
    default="all",
    help=f"Comma-separated list of stages among : {', '.join(STAGES)}.",
)

args = parser.parse_args()

if args.stage == "all":
    stages = STAGES.keys()
else:
    stages = args.stage.split(",")

for stage in stages:
    try:
        func_name: str = STAGES.get(stage)
        locals()[func_name]()
    except KeyError:
        print(f"ERROR: stage {stage} not found")
        sys.exit(1)
