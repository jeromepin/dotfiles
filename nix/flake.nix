{
  description = "Jerome's Darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # This should point to the channel (or commit) right before the one used by `nixpkgs.url` above
    # as a way to keep some packages working until they work in the new channel.
    nixpkgs-oldstable.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-oldstable,
    home-manager,
    ...
  }@inputs :
  let 
    system = "aarch64-darwin";
    # pkgs = import nixpkgs {inherit system;}
    unstable = import nixpkgs-unstable {inherit system;};
  in {
    darwinConfigurations = {
      "218300622L" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          # From https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages and https://nixos-and-flakes.thiscute.world/nixpkgs/overlays
          nixpkgs-oldstable = import nixpkgs-oldstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./darwin/darwin.nix
          (import ./overlays)
          home-manager.darwinModules.home-manager {
            home-manager = {
              extraSpecialArgs = { inherit unstable; };
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = false;
              users.jpin = import ./home/218300622L.nix;
            };
            users.users.jpin = {
              name = "jpin";
              home = "/Users/jpin";
            };
          }
        ];
      };
      "Jeromes-MacBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/darwin.nix
          home-manager.darwinModules.home-manager {
            home-manager = {
              extraSpecialArgs = { inherit unstable; };
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = false;
              users.jerome = import ./home/Jeromes-MacBook-Air.nix;
            };
            users.users.jerome = {
              name = "jerome";
              home = "/Users/jerome";
            };
          }
        ];
      };
    };
  };
}
