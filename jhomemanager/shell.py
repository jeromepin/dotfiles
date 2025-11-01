import os
import pathlib
import shutil
import subprocess

def binary_path(binary: str) -> pathlib.Path:
    possible_path = shutil.which(binary)
    if not possible_path:
        raise RuntimeError(f"{binary} : not found")
    return pathlib.Path(possible_path)

def run_shell_command(
    command: list[str], env: dict[str, str] | None = None, shell: bool = False
) -> subprocess.CompletedProcess:
    new_env = os.environ.copy()
    for k, v in new_env.items():
        new_env[k] = v

    return subprocess.run(command, capture_output=True, shell=shell, env=new_env)


def tree_print(c, indent_level: int = 0, tree_char: str = "└──") -> None:
    print(f"{indent_level * 4 * ' '}{tree_char} {c}")


class TermincalColors:
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    RESET = "\033[0m"
