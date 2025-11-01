init:
	wget -O "${HOME}/Downloads/DeterminateNix.pkg" https://install.determinate.systems/nix-installer-pkg/stable/Universal
	open "${HOME}/Downloads/DeterminateNix.pkg"
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo "Open a new shell for the next step"

# check:
# 	nix flake check nix/

install:
	./install.py all

update:
	./install upgrade-packages

# update-unstable:
# 	cd nix/ && nix flake update nixpkgs-unstable --commit-lock-file --show-trace
# 	$(MAKE) install

gc:
	nix-store --gc
	nix-collect-garbage
