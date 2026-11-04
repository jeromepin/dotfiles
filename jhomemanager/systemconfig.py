from __future__ import annotations

import dataclasses
import os
import pathlib
import plistlib
import typing

from .paths import HOME
from .shell import TerminalColors, is_dry_run, run, tree_print


@dataclasses.dataclass
class MacOSUserLaunchAgent:
    label: str
    attributes: dict[str, typing.Any]

    LAUNCH_AGENTS_DIR = HOME / "Library/LaunchAgents"

    @property
    def path(self) -> pathlib.Path:
        return self.LAUNCH_AGENTS_DIR / f"{self.label}.plist"

    def to_plist(self) -> bytes:
        return plistlib.dumps({"Label": self.label, **self.attributes})

    def install(self) -> None:
        tree_print(f"LaunchAgent {TerminalColors.CYAN}{self.label}{TerminalColors.RESET}")
        content = self.to_plist()
        if self.path.exists() and self.path.read_bytes() == content:
            tree_print(f"{TerminalColors.GREEN}Already up to date{TerminalColors.RESET}", indent_level=1)
            return

        domain = f"gui/{os.getuid()}"
        # bootout fails when the agent isn't loaded yet, which is fine
        run(["launchctl", "bootout", f"{domain}/{self.label}"], check=False)
        tree_print(f"Writing {self.path}", indent_level=1)
        if not is_dry_run():
            self.LAUNCH_AGENTS_DIR.mkdir(parents=True, exist_ok=True)
            self.path.write_bytes(content)
        run(["launchctl", "bootstrap", domain, str(self.path)])
