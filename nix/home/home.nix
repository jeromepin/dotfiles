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
      pipx
      postgresql_16
      python3
      python311Packages.pip
      sops
      starship
      tree
      tudu
      unixtools.watch
      wireguard-go
      wireguard-tools
      zig_0_11
    ] ++ [
      unstable.bat
      unstable.cargo
      unstable.coreutils
      unstable.delta
      unstable.difftastic
      unstable.fd
      unstable.fish
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
      unstable.neovim
      unstable.nodejs_22 # for neovim
      unstable.nodePackages.neovim # for neovim
      unstable.pdm
      unstable.pre-commit
      unstable.python311Packages.pynvim # for neovim
      unstable.python311Packages.virtualenv # for pdm
      unstable.ripgrep
      unstable.wabt
      unstable.wasmtime
      unstable.wget
      unstable.zola
    ];

    file = {
      ".bashrc.d" = {
        source = ../../.bashrc.d;
        recursive = true;
      };
      ".bashrc".source = ../../.bashrc;
      # ".config/fish/completions/fzf.fish".source = ../../.config/fish/completions/fzf.fish;
      ".config/fish/conf.d/10_aliases.fish".source = ../../.config/fish/conf.d/10_aliases.fish;
      ".config/fish/conf.d/20_env.fish".source = ../../.config/fish/conf.d/20_env.fish;
      ".config/fish/conf.d/30_path.fish".source = ../../.config/fish/conf.d/30_path.fish;
      ".config/fish/conf.d/50_shell.fish".source = ../../.config/fish/conf.d/50_shell.fish;
      ".config/fish/functions/base64.fish".source = ../../.config/fish/functions/base64.fish;
      ".config/fish/functions/misc.fish".source = ../../.config/fish/functions/misc.fish;
      ".config/gitu".source = ../../.config/gitu;
      ".config/nvim" = {
        source = ../../.config/nvim;
        recursive = true;
      };
      ".config/starship.toml".source = ../../.config/starship.toml;
      ".gitconfig".source = ../../.gitconfig;
      ".gitignore".source = ../../global_gitignore;
      ".inputrc".source = ../../.inputrc;
      "bin".source = ../../bin;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
