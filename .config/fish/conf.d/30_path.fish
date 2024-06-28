# Nix
fish_add_path $HOME/.nix-profile/bin
fish_add_path /etc/profiles/per-user/jpin/bin
fish_add_path /run/current-system/sw/bin
fish_add_path /nix/var/nix/profiles/default/bin

# Homebrew
fish_add_path /opt/homebrew/bin

# Cargo-installed binaries
fish_add_path $HOME/.cargo/bin

# Personal scripts
fish_add_path $HOME/bin
