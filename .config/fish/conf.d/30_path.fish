# Paths are prepended to $PATH, therefore deeper in this file means higher "priority"

# Nix
fish_add_path --move $HOME/.nix-profile/bin
fish_add_path --move /etc/profiles/per-user/$USER/bin
fish_add_path --move /run/current-system/sw/bin
fish_add_path --move /nix/var/nix/profiles/default/bin

# Homebrew
fish_add_path --move /opt/homebrew/bin

# Cargo-installed binaries
fish_add_path --move $HOME/.cargo/bin

# OrbStack's binaries (docker)
fish_add_path --move $HOME/.orbstack/bin/docker

# Eget binaries
fish_add_path --move $HOME/eget-bin

# Personal scripts
fish_add_path --move $HOME/bin