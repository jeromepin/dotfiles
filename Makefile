.PHONY: init plan install update gc

init:
	curl -fsSL -o "$(HOME)/Downloads/DeterminateNix.pkg" https://install.determinate.systems/nix-installer-pkg/stable/Universal
	sudo installer -pkg "$(HOME)/Downloads/DeterminateNix.pkg" -target /
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo "Open a new shell for the next step"

plan:
	./install.py --dry-run all

install:
	./install.py all

update:
	./install.py upgrade-packages

gc:
	nix profile wipe-history --older-than 30d
	nix-collect-garbage
