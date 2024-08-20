dotfiles
========

# On a new machine

* Clone this repository
* Run `make init`
* Run `make install`


# Common issues

## Nix : `Error: It seems there is already an App at '/Applications/...'`

```
brew remove --force --cask ...
```