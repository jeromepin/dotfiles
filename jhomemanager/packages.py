import dataclasses


@dataclasses.dataclass
class IPackage: ...


class NixPackage(IPackage):
    def __init__(self, full_name: str):
        self.org, rest = full_name.split("/")
        self.channel_or_commit, self.name = rest.split("#")
        self.reference = f"{self.org}/{self.channel_or_commit}#{self.name}"

    @staticmethod
    def new_from_str(string: str, current_stable_branch: str) -> "NixPackage":
        # unstable.P -> nixpkgs/nixpkgs-unstable#P
        if string.startswith("unstable."):
            return NixPackage(
                f"nixpkgs/nixpkgs-unstable#{string.removeprefix('unstable.')}"
            )

        # P -> nixpkgs/nixpkgs-25.05-darwin#P
        elif "#" not in string:
            return NixPackage(
                f"nixpkgs/nixpkgs-{current_stable_branch}-darwin#{string}"
            )

        # nixpkgs/COMMIT_SHA#P -> nixpkgs/COMMIT_SHA#P
        return NixPackage(string)

    def __repr__(self) -> str:
        return self.reference

    def __hash__(self) -> int:
        return hash((self.org, self.channel_or_commit, self.name))
