init:
	wget -O "${HOME}/Downloads/DeterminateNix.pkg" https://install.determinate.systems/nix-installer-pkg/stable/Universal
	open "${HOME}/Downloads/DeterminateNix.pkg"

check:
	nix flake check nix/

install:
	nix run nix-darwin -- switch --flake nix/

update:
	cd nix/ && nix flake update --commit-lock-file
	$(MAKE) install

gc:
	nix-store --gc
	nix-collect-garbage
