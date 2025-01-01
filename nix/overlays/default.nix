# This file is my first attempt at overlays (and understanding them).

# It is used to declare packages that should come from the previous channel
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