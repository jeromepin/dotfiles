from __future__ import annotations

import dataclasses
import json
import typing

from .paths import REPO_ROOT
from .shell import JHomeManagerError, run

PACKAGES_DIR = REPO_ROOT / "packages"
PACKAGES_FILE = PACKAGES_DIR / "packages.toml"

# packages.toml [*.homebrew] key -> Brewfile kind
HOMEBREW_KEYS = {"taps": "tap", "formulae": "brew", "casks": "cask"}


@dataclasses.dataclass(frozen=True)
class HostConfig:
    name: str
    homebrew: list[str]  # Brewfile entries: "brew rtk", "cask zed"...
    eget: list[str]


def get_machine_name() -> str:
    return run(["scutil", "--get", "ComputerName"], mutates=False).stdout.decode("utf-8").strip()


def load_packages_file() -> dict[str, typing.Any]:
    # Parsed by Nix: no TOML parser in Python < 3.11 (/usr/bin/python3 on a fresh Mac),
    # and it's exactly how flake.nix reads it
    expr = f"builtins.fromTOML (builtins.readFile {json.dumps(str(PACKAGES_FILE))})"
    return json.loads(run(["nix", "eval", "--impure", "--json", "--expr", expr], mutates=False).stdout)


def _homebrew_entries(layer_name: str, layer: dict[str, typing.Any]) -> list[str]:
    homebrew = layer.get("homebrew", {})
    unknown = set(homebrew) - set(HOMEBREW_KEYS)
    if unknown:
        raise JHomeManagerError(
            f"packages.toml: unknown key(s) {sorted(unknown)} in [{layer_name}.homebrew], expected {sorted(HOMEBREW_KEYS)}"
        )
    return [f"{HOMEBREW_KEYS[key]} {name}" for key, names in homebrew.items() for name in names]


def host_config(machine_name: str | None = None) -> HostConfig:
    machine_name = machine_name or get_machine_name()
    config = load_packages_file()
    hosts = config.get("hosts", {})
    matches = [name for name, host in hosts.items() if host.get("computer_name") == machine_name]
    if len(matches) != 1:
        raise JHomeManagerError(
            f"packages.toml: {len(matches)} host(s) with computer_name = {machine_name!r} "
            f"(from `scutil --get ComputerName`), expected 1. Hosts: {', '.join(hosts) or 'none'}"
        )

    name = matches[0]
    common, host = config.get("common", {}), hosts[name]
    return HostConfig(
        name=name,
        homebrew=_homebrew_entries("common", common) + _homebrew_entries(f"hosts.{name}", host),
        eget=[*common.get("eget", []), *host.get("eget", [])],
    )
