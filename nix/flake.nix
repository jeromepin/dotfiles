{
  description = "Jerome's Darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
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
        modules = [
          ./darwin/darwin.nix
          home-manager.darwinModules.home-manager {
            home-manager = {
              extraSpecialArgs = { inherit unstable; };
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = false;
              users.jpin = import ./home/home.nix;
            };
            users.users.jpin = {
              name = "jpin";
              home = "/Users/jpin";
            };
          }
        ];
      };
    };
  };
}
