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

## Useful links

- https://nixos-and-flakes.thiscute.world/preface