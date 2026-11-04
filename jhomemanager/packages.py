from __future__ import annotations

import dataclasses


@dataclasses.dataclass(frozen=True, order=True)
class NixPackage:
    flake: str  # e.g. nixpkgs/nixpkgs-unstable, github:NixOS/nixpkgs/<sha>
    attr: str  # e.g. ripgrep, nerd-fonts.fira-code

    @property
    def reference(self) -> str:
        return f"{self.flake}#{self.attr}"

    def __str__(self) -> str:
        return self.reference

    @classmethod
    def from_spec(cls, spec: str, stable_branch: str) -> NixPackage:
        # FLAKE#P -> as is (e.g. nixpkgs/nixpkgs-24.05-darwin#P, github:NixOS/nixpkgs/<sha>#P)
        if "#" in spec:
            flake, attr = spec.split("#", 1)
            return cls(flake, attr)

        # unstable.P -> nixpkgs/nixpkgs-unstable#P
        if spec.startswith("unstable."):
            return cls("nixpkgs/nixpkgs-unstable", spec.removeprefix("unstable."))

        # P -> nixpkgs/nixpkgs-<stable>-darwin#P
        return cls(f"nixpkgs/nixpkgs-{stable_branch}-darwin", spec)
