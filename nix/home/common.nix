{ pkgs, unstable }:

{
  home = {
    packages = with pkgs; [
      bash-completion
      cmake
      file
      getopt
      gnused
      gnupg
      go
      pipx
      python3
      python311Packages.pip
      starship
      tree
      tudu
      unixtools.watch
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
      unstable.ijq
      unstable.jq
      unstable.most
      unstable.neovim
      unstable.nodejs_22 # for neovim
      unstable.nodePackages.neovim # for neovim
      unstable.pdm
      unstable.pre-commit
      unstable.python311Packages.pynvim # for neovim
      unstable.python311Packages.virtualenv # for pdm
      unstable.ripgrep
      unstable.serpl
      unstable.wabt
      unstable.wasmtime
      unstable.wget
      unstable.zola
    ];

    files = {
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
}
