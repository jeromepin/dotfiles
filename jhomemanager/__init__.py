import os
import pathlib
import typing

from .cli import build_parser
from .dotfiles import DotFilesInstallationStage
from .installationstage import InstallationStage
from .packages import IPackageList
from .shell import TermincalColors, run_shell_command, tree_print
from .systemconfig import MacOSUserLaunchAgent

HOME = pathlib.Path(os.path.expanduser("~"))


def get_machine_name() -> str:
    return typing.cast(
        str,
        run_shell_command(["scutil", "--get", "ComputerName"]).stdout.decode("utf-8"),
    ).strip()
