from __future__ import annotations

import argparse
import sys
import typing

from .installationstage import InstallationStage
from .shell import JHomeManagerError, TerminalColors, set_dry_run

DESCRIPTION = """\
Configure this Mac from this repository: dotfiles, packages (Homebrew, Nix, eget),
LaunchAgents and macOS settings.

Every command converges: it compares this Mac with the repository and only changes
what differs. Run it with --dry-run first to see what that would be."""

EPILOG = """\
examples:
  ./install.py -n                      show what would change on this Mac
  ./install.py                         apply everything
  ./install.py -n upgrade-packages     show the available upgrades
  ./install.py packages -h             help for one command

first run on a new Mac (the built-in Python is enough):
  ./install.py bootstrap               install Nix and Homebrew
  ./install.py                         in a new shell

files:
  packages/packages.toml   packages for every Mac ([common]) and per Mac ([hosts.<name>],
                           matched by `scutil --get ComputerName`)
  packages/flake.lock      versions of the Nix channels: commit it after upgrade-packages
  install.py               dotfiles to link, LaunchAgents, macOS settings"""


def main(stages: dict[str, InstallationStage], default_stages: typing.Sequence[str]) -> None:
    # Accepted before and after the command: `install.py -n packages` and `install.py packages -n`.
    # SUPPRESS keeps a sub-command from resetting a flag given before it.
    dry_run = argparse.ArgumentParser(add_help=False)
    dry_run.add_argument(
        "-n", "--dry-run",
        action="store_true",
        default=argparse.SUPPRESS,
        help="show what would change, without changing anything",
    )

    parser = argparse.ArgumentParser(
        prog="install.py",
        usage="%(prog)s [-h] [-n] [COMMAND]",
        description=DESCRIPTION,
        epilog=EPILOG,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        parents=[dry_run],
    )
    commands = parser.add_subparsers(dest="command", title="commands", metavar="COMMAND", prog="install.py")
    all_help = f"run {', '.join(default_stages)} (default when no command is given)"
    commands.add_parser("all", parents=[dry_run], help=all_help, description=all_help)
    for name, stage in stages.items():
        commands.add_parser(
            name,
            parents=[dry_run],
            help=stage.help,
            description=stage.description,
            formatter_class=argparse.RawDescriptionHelpFormatter,
        )

    args = parser.parse_args()
    set_dry_run(getattr(args, "dry_run", False))

    command = args.command or "all"
    selected = list(default_stages) if command == "all" else [command]
    try:
        for name in selected:
            stages[name].exec()
    except (JHomeManagerError, OSError, ValueError) as e:
        sys.stdout.flush()  # keep the error after the output when both go to a file
        print(f"\n{TerminalColors.RED}Error: {e}{TerminalColors.RESET}", file=sys.stderr)
        sys.exit(1)
