{
  # Adapter between packages.toml and Nix: it should never need editing.
  # Packages are declared in packages.toml; the only reason to touch this file is adding a channel input.
  description = "jhomemanager: one Nix profile entry per host, built from packages.toml";

  inputs = {
    # Each input is a channel name usable in packages.toml
    stable.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
  };

  outputs =
    inputs@{ self, stable, ... }:
    let
      lib = stable.lib;
      config = builtins.fromTOML (builtins.readFile ./packages.toml);
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      channelNames = builtins.attrNames (removeAttrs inputs [ "self" ]);

      # [{ channel, attr, package }] for one layer (common or a host) of packages.toml
      entriesOf =
        system: layer:
        lib.concatLists (
          lib.mapAttrsToList (
            channel: attrs:
            let
              pkgs =
                inputs.${channel}.legacyPackages.${system}
                  or (throw "packages.toml: unknown channel '${channel}', expected one of: ${toString channelNames}");
            in
            map (attr: {
              inherit channel attr;
              package = lib.attrByPath (lib.splitString "." attr) (throw "packages.toml: '${attr}' not found in channel '${channel}'") pkgs;
            }) attrs
          ) (layer.nix or { })
        );

      hostEntries = system: hostConfig: entriesOf system (config.common or { }) ++ entriesOf system hostConfig;

      manifestOf = entries: map (e: { inherit (e) channel attr; version = e.package.version or null; }) entries;

      envFor =
        system: host: hostConfig:
        let
          entries = hostEntries system hostConfig;
          manifest = builtins.toFile "jhome-manifest.json" (builtins.toJSON (manifestOf entries));
        in
        stable.legacyPackages.${system}.buildEnv {
          name = "jhome-${host}";
          paths = map (e: e.package) entries;
          extraOutputsToInstall = [ "man" ];
          # Read by jhomemanager to show version changes between the installed and the next environment
          postBuild = "cp ${manifest} $out/jhome-manifest.json";
        };
    in
    {
      packages = lib.genAttrs systems (system: lib.mapAttrs (envFor system) (config.hosts or { }));
      manifests = lib.genAttrs systems (
        system: lib.mapAttrs (_: hostConfig: manifestOf (hostEntries system hostConfig)) (config.hosts or { })
      );
    };
}
