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


@dataclasses.dataclass(frozen=True)
class MacOSDefault:
    """One `defaults write` value."""

    domain: str
    key: str
    value: bool | int | float | str
    current_host: bool = False  # `defaults -currentHost`
    restart: str | None = None  # process to restart for the change to apply; default depends on the domain


class MacOSDefaults:
    RESTART_BY_DOMAIN = {
        "com.apple.dock": "Dock",
        "com.apple.finder": "Finder",
        "com.apple.desktopservices": "Finder",
    }
    # Applies most settings of the current user without a logout
    ACTIVATE_SETTINGS = pathlib.Path(
        "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings"
    )

    def __init__(self, settings: typing.Iterable[MacOSDefault]):
        self.settings = list(settings)
        self._domains: dict[tuple[str, bool], dict[str, typing.Any]] = {}

    @staticmethod
    def _host_args(setting: MacOSDefault) -> list[str]:
        return ["-currentHost"] if setting.current_host else []

    def _current(self, setting: MacOSDefault) -> typing.Any:
        cache_key = (setting.domain, setting.current_host)
        if cache_key not in self._domains:
            result = run(
                ["defaults", *self._host_args(setting), "export", setting.domain, "-"],
                mutates=False,
                check=False,  # the domain doesn't exist until something is written to it
            )
            self._domains[cache_key] = plistlib.loads(result.stdout) if result.returncode == 0 and result.stdout else {}
        return self._domains[cache_key].get(setting.key)

    @staticmethod
    def _is_set(current: typing.Any, wanted: bool | int | float | str) -> bool:
        # Booleans are often stored as integers: 1 == True, 0.0 == 0
        return current is not None and current == wanted

    @staticmethod
    def _write_args(value: bool | int | float | str) -> list[str]:
        if isinstance(value, bool):
            return ["-bool", "true" if value else "false"]
        if isinstance(value, int):
            return ["-int", str(value)]
        if isinstance(value, float):
            return ["-float", repr(value)]
        return ["-string", value]

    def apply(self) -> None:
        tree_print(f"macOS settings [{len(self.settings)}]")
        restarts: set[str] = set()
        needs_activation = False
        for setting in self.settings:
            current = self._current(setting)
            if self._is_set(current, setting.value):
                continue

            old = "unset" if current is None else repr(current)
            host = " (current host)" if setting.current_host else ""
            tree_print(
                f"{TerminalColors.CYAN}{setting.domain} {setting.key}{host}: {old} -> {setting.value!r}{TerminalColors.RESET}",
                indent_level=1,
            )
            run(["defaults", *self._host_args(setting), "write", setting.domain, setting.key, *self._write_args(setting.value)])

            restart = setting.restart or self.RESTART_BY_DOMAIN.get(setting.domain)
            if restart:
                restarts.add(restart)
            else:
                needs_activation = True

        if not restarts and not needs_activation:
            tree_print(f"{TerminalColors.GREEN}Already up to date{TerminalColors.RESET}", indent_level=1)
            return

        if needs_activation:
            if self.ACTIVATE_SETTINGS.exists():
                run([str(self.ACTIVATE_SETTINGS), "-u"], check=False)
            tree_print(f"{TerminalColors.YELLOW}Some changes may only apply after logging out{TerminalColors.RESET}", indent_level=1)
        for process in sorted(restarts):
            run(["killall", process], check=False)
