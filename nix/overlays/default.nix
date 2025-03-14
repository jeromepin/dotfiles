# This file is my first attempt at overlays (and understanding them).
# See https://nixos.wiki/wiki/Overlays

# It is used to declare packages that should be in different versions
# either because the new one provided in a channel is broken
# or because I want the latest one

# because they are marked as broken in the current channel

{ config, pkgs, lib, nixpkgs-oldstable, ... }:
{
  nixpkgs.overlays = [
    # Overlay: Use `self` and `super` to express
    # the inheritance relationship
    (self: super: {
      gcsfuse = nixpkgs-oldstable.gcsfuse;
    })
  ];
}