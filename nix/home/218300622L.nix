{ config, pkgs, unstable, ... }:

let
  common = import ./common.nix {pkgs = pkgs; unstable = unstable;};
in
{
  home = {
    username = "jpin";
    homeDirectory = "/Users/jpin";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";

    packages = with pkgs; common.home.packages ++ [
      git-crypt
      gnused
      gnupg
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      gcsfuse
      ipcalc
      kubectl
      kubectx
      kubelogin
      kubernetes-helm
      postgresql_16
      sops
      wireguard-go
      wireguard-tools
    ] ++ [
      unstable.basedpyright # Python LSP
      unstable.delve
      unstable.dogdns
      unstable.eget
      unstable.helix
      unstable.nmap
      unstable.pgcli
      unstable.rdap
      unstable.sttr
      unstable.terraform-ls # Terraform LSP
      unstable.tealdeer
    ];

    file = common.home.files;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
