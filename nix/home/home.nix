{ config, pkgs, unstable, ... }:

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

    # https://search.nixos.org/packages
    packages = with pkgs; [
      bash-completion
      file
      getopt
      git-crypt
      gnused
      gnupg
      go
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      gcsfuse
      kubectl
      kubelogin
      kubernetes-helm
      neovim
      nodejs_21 # for neovim
      nodePackages.neovim # for neovim
      pipx
      postgresql_16
      python3
      python311Packages.pip
      python311Packages.pynvim # for neovim
      sops
      tree
      tudu
      wireguard-go
      wireguard-tools
      zig
    ] ++ [
      unstable.bat
      unstable.coreutils
      unstable.delta
      unstable.difftastic
      unstable.fd
      unstable.fzf
      unstable.eza
      unstable.gh
      unstable.git
      unstable.git-absorb
      unstable.gitu
      unstable.hexyl
      unstable.hyperfine
      unstable.htop
      unstable.jq
      unstable.kubectx
      unstable.most
      unstable.pdm
      unstable.pre-commit
      unstable.python311Packages.virtualenv # for pdm
      unstable.ripgrep
      unstable.starship
      unstable.wabt
      unstable.wget
      unstable.zola
    ];

    file = {
      ".bashrc".source = ../../.bashrc;
      ".gitconfig".source = ../../.gitconfig;
      ".gitignore".source = ../../global_gitignore;
      ".inputrc".source = ../../.inputrc;
      ".bashrc.d" = {
        source = ../../.bashrc.d;
        recursive = true;
      };
      ".config/nvim" = {
        source = ../../.config/nvim;
        recursive = true;
      };
      ".config/starship.toml".source = ../../.config/starship.toml;
      ".config/gitu".source = ../../.config/gitu;
      "bin".source = ../../bin;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
