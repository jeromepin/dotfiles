{ config, pkgs, ... }:

{
  # The path of the darwin configuration.nix used to configure the system.
  # This updates the default darwin-config entry in NIX_PATH.
  # Since this changes an environment variable it will only apply to new shells.
  # Changing this requires running `darwin-rebuild switch --flake nix/ -I darwin-config=$HOME/git/github/jeromepin/dotfiles/nix/darwin/darwin.nix` the first time to make darwin-rebuild aware of the custom location.
  # environment.darwinConfig = "$HOME/git/github/jeromepin/dotfiles/nix/darwin/darwin.nix";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.home-manager
  ];

  fonts.packages = [
    pkgs.fira-code
    pkgs.fira-code-nerdfont
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [];
    brews = [];
    casks = [
      "brave-browser"
      "firefox"
      "ghostty"
      "google-chrome"
      "lunar"
      "obsidian"
      "orbstack"
      "rectangle"
      "slack"
      "spotify"
      "visual-studio-code"
      "vlc"
    ];
  };

  # From https://www.danielcorin.com/til/nix-darwin/launch-agents/
  launchd = {
    user = {
      agents = {
        # Ensure the private key is loaded into the keychain on session login
        add-to-ssh-agent = {
          command = "ssh-add --apple-use-keychain";
          serviceConfig = {
            KeepAlive = false;
            RunAtLoad = true;
          };
        };
      };
    };
  };

  nix = {
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    package = pkgs.nix;
    # Necessary for using flakes on this system.
    settings.experimental-features = "nix-command flakes";
  };


  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    # The platform the configuration will be used on.
    hostPlatform = "aarch64-darwin";
  };
  
  programs = {
    zsh.enable = true;  # default shell on catalina
    bash.enable = true;
    bash.completion.enable = true;
  };

  # Use TouchID to sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Inspiration from https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
  system = {
    # This should avoid a logout/login cycle to take into account system.* changes
    activationScripts.postUserActivation.text = ''
      #! /run/current-system/sw/bin/bash
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      killall Finder
      killall Dock
    '';

    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
    #     show-process-indicators = false;
    #     show-recents = false;
    #     static-only = true;
      };
    #   finder = {
    #     AppleShowAllExtensions = true;
    #     ShowPathbar = true;
    #     FXEnableExtensionChangeWarning = false;
    #   };
    #   NSGlobalDomain = {
    #     AppleKeyboardUIMode = 3;
    #     "com.apple.keyboard.fnState" = true;
    #     NSAutomaticWindowAnimationsEnabled = false;
    #   };
    };
    
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
