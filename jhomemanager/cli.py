from __future__ import annotations

import argparse
import sys
import typing

from .installationstage import InstallationStage
from .shell import JHomeManagerError, TerminalColors, set_dry_run


def main(stages: dict[str, InstallationStage], default_stages: typing.Sequence[str]) -> None:
    parser = argparse.ArgumentParser(description="Configure my system (apps, packages, dotfiles, etc...)")
    parser.add_argument(
        "stage",
        nargs="?",
        default="all",
        choices=["all", *stages],
        help=f"'all' runs: {', '.join(default_stages)}.",
    )
    parser.add_argument(
        "-n", "--dry-run",
        action="store_true",
        help="Print what would change without changing anything.",
    )
    args = parser.parse_args()
    set_dry_run(args.dry_run)

    selected = list(default_stages) if args.stage == "all" else [args.stage]
    try:
        for name in selected:
            stages[name].exec()
    except (JHomeManagerError, OSError, ValueError) as e:
        print(f"\n{TerminalColors.RED}Error: {e}{TerminalColors.RESET}", file=sys.stderr)
        sys.exit(1)
