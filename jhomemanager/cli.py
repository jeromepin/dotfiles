import argparse

from .installationstage import InstallationStage

def build_parser(stages: dict[str, InstallationStage]) -> None:
    parser = argparse.ArgumentParser(description="Configure my system (apps, packages, dotfiles, etc...)")
    parser.add_argument(
        dest="stage",
        default="all",
        help=f"One of : {', '.join(stages)}.",
        choices=["all"] + list(stages),
    )

    args = parser.parse_args()

    if args.stage == "all":
        del stages["upgrade-packages"]
        selected_stages = list(stages)
    else:
        selected_stages = [args.stage]

    for stage in selected_stages:
        stages[stage].exec()
