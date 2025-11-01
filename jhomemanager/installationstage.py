from abc import ABC
import dataclasses

from .shell import binary_path


@dataclasses.dataclass
class InstallationStage(ABC):
    def __post_init__(self):
        for binary in ["brew", "nix"]:
            binary_path(binary)

    def exec(self) -> None:
        print(f"\n[{self.__class__.__name__.upper()}]")
