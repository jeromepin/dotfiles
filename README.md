## On a new machine

1. Clone this repository.
2. Add the machine to `packages/packages.toml`: a `[hosts.<name>]` section with its `computer_name` (`scutil --get ComputerName`).
3. Install Nix and Homebrew (the Mac's built-in Python is enough):
   ```
   ./install.py bootstrap
   ```
4. In a new shell, check the plan, then apply it:
   ```
   ./install.py -n
   ./install.py
   ```

## Usage

`./install.py --help` lists the commands, `./install.py <command> --help` details one.
Every command only changes what differs from this repository, and accepts `-n`/`--dry-run` to show what that would be.

```
./install.py -n                 # show what would change
./install.py                    # apply everything: home, packages, system
./install.py packages           # one part only: home, packages or system
./install.py upgrade-packages   # upgrade packages, then commit packages/flake.lock
./install.py gc                 # free disk space used by Nix
```

| What | Where |
|---|---|
| Packages (Homebrew, Nix, eget), for every machine and per machine | `packages/packages.toml` |
| Versions of the Nix channels | `packages/flake.lock` |
| Dotfiles to link, LaunchAgents, macOS settings | `install.py` |

`packages/flake.nix` turns `packages.toml` into a single Nix profile entry per machine.
It doesn't need editing, except to add a channel (an `input`).
Since `packages/flake.lock` pins the versions, every machine gets the same ones: commit it after `upgrade-packages`.

- Undo the last Nix change: `nix profile rollback`
- Move to a new NixOS stable release: change the `stable` input URL in `packages/flake.nix`, then `./install.py upgrade-packages`

## Common issues

### Nix : `Error: It seems there is already an App at '/Applications/...'`

```
brew remove --force --cask ...
```

### Temporary use a package from another channel

```
nix run nixpkgs/nixpkgs-unstable#<PACKAGE>
```

## Useful links

- https://nixos-and-flakes.thiscute.world/preface

## History:
#### v0 : Bash script
As usual, it went bad quickly. Nothing should ever be written using shell scripts. Shell scripting shouldn't even exist.

#### v1 : Python rewrite
Rewritten in Python. Life was nice, but a little bit hacky and manual

#### v2 : Nix
Moving to Nix, nix-darwin & home-manager.
This works well but is too complicated. I really don't want to understand/learn a new language only to manag packages, files and settings on my laptops.

#### v3 : Nix package management without Nix lang ?

Nix (the language) is painful and unncessary for me, while the package management and config management is very useful. I want a way to get rid of the language.

Required features :
* [x] Package management and override (i.e I want to install a specific version of a given package for whatever reason)
* [x] Homebrew + Cask management
* [x] Dotfiles management (mostly symlinks)
* [x] [optional] MacOS' Launchd control (cf. https://www.danielcorin.com/til/nix-darwin/launch-agents/)
* [ ] [optional] MacOS' customisation
* [x] Default + overridable configuration : some packages must be available for all machines, but some only at work/home
* [ ] Different username in work/home setup
* [ ] [optional] Likely different dotfiles for work/home setup
* [ ] [optional] Before/After hooks for any given stage
* [ ] Use `logging` to display debug messages intead of `print`
