init:
	wget -O "${HOME}/Downloads/DeterminateNix.pkg" https://install.determinate.systems/nix-installer-pkg/stable/Universal
	open "${HOME}/Downloads/DeterminateNix.pkg"
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
	@echo "Open a new shell for the next step"

check:
	nix flake check nix/

install:
	nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake nix/

update:
	cd nix/ && nix flake update --commit-lock-file
	$(MAKE) install

update-unstable:
	cd nix/ && nix flake update nixpkgs-unstable --commit-lock-file
	$(MAKE) install

gc:
	nix-store --gc
	nix-collect-garbage
