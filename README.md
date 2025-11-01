## On a new machine

* Clone this repository
* Run `make init`
* Run `make install`

## Upgrading packages

If wanted, change the version in `nix/flake.nix` first

```
make update # or update-unstable
```

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
