{
  description = "Jerome's Darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
       with pkgs;  [
          bash-completion
          bat
          coreutils
          delta
          difftastic
          fd
          file
          fish
          fzf
          eza
          getopt
          gh
          git
          git-crypt
          gnused
          gnupg
          go
          htop
          jq
          kubectl
          kubectx
          kubelogin
          most
          neovim
          nodejs_21 # for neovim
          nodePackages.neovim # for neovim
          postgresql_16
          python3
          python311Packages.pynvim # for neovim
          ripgrep
          sops
          starship
          tree
          wget
          wireguard-go
          zig
        ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [];
        brews = [];
        casks = [
          "iterm2"
          "orbstack"
          "rectangle"
          "slack"
          "spotify"
          "visual-studio-code"
        ];
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      nixpkgs.config.allowUnfree = true;

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.bash.enable = true;
      programs.bash.enableCompletion = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Use TouchID to sudo
      security.pam.enableSudoTouchIdAuth = true;

      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      users.users.jpin = {
        name = "jpin";
        home = "/Users/jpin";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    darwinConfigurations."218300622L" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = false;
          home-manager.users.jpin = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."218300622L".pkgs;
    # system.defaults.NSGlobalDomain.KeyRepeat = 1;
  };
}
