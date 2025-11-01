import dataclasses
import os
import pathlib

from .shell import TermincalColors, tree_print, run_shell_command

HOME = pathlib.Path(os.path.expanduser("~"))


@dataclasses.dataclass
class MacOSUserLaunchAgent:
    filename: str
    attributes: dict[str, bool | str | list[str]]

    LAUNCH_AGENT_LIBRARY_PATH = HOME / pathlib.Path("Library/LaunchAgents")

    def __post_init__(self):
        tree_print(
            f"Installing LaunchAgent {TermincalColors.CYAN}{self.filename}{TermincalColors.RESET}"
        )
        self.write()
        run_shell_command(["launchctl", "load", self.filename])

    def to_plist(self) -> str:
        dict_section: list[str] = []
        for key, value in self.attributes.items():
            dict_section.append(f"\t<key>{key}</key>")
            if isinstance(value, bool):
                dict_section.append(f"\t<{str(value).lower()}/>")
            elif isinstance(value, str):
                dict_section.append(f"\t<string>{value}</string>")
            elif isinstance(value, list):
                dict_section.append("\t<array>")
                for element in value:
                    dict_section.append(f"\t\t<string>{element}</string>")
                dict_section.append("\t</array>")

        return "\n".join(
            [
                '<?xml version="1.0" encoding="UTF-8"?>',
                '<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
                '<plist version="1.0">',
                "<dict>",
            ]
            + dict_section
            + [
                "</dict>",
                "</plist>",
            ]
        )

    def write(self):
        filename = self.filename
        if not self.filename.endswith(".plist"):
            filename = f"{self.filename}.plist"

        with open(self.LAUNCH_AGENT_LIBRARY_PATH / filename, "w") as f:
            f.write(self.to_plist())
