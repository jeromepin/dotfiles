{ pkgs, unstable }:

{
  home = {
    packages = with pkgs; [
      bash-completion
      cmake
      file
      fira-code
      fira-code-nerdfont
      getopt
      gnused
      gnupg
      go
      pipx
      python3
      python311Packages.pip
      socat
      tree
      tudu
      unixtools.watch
      zig_0_12
    ] ++ [
      unstable.ast-grep
      unstable.bat
      unstable.bun
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
      unstable.glow
      unstable.hexyl
      unstable.hyperfine
      unstable.htop
      unstable.ijq
      unstable.jujutsu
      unstable.jq
      unstable.most
      unstable.neovim
      unstable.nix-index
      unstable.nodejs_22 # for neovim
      # unstable.nodePackages.neovim # for neovim
      unstable.pdm
      unstable.python311Packages.pynvim # for neovim
      unstable.ripgrep
      unstable.ruff
      unstable.starship
      unstable.serpl
      unstable.tig
      unstable.tree-sitter
      unstable.uv
      unstable.wget
      unstable.zola
    ];

    files = {
      ".bashrc.d" = {
        source = ../../.bashrc.d;
        recursive = true;
      };
      ".bashrc".source = ../../.bashrc;
      ".config/bat/config".source = ../../.config/bat/config;
      ".config/fish/conf.d/10_aliases.fish".source = ../../.config/fish/conf.d/10_aliases.fish;
      ".config/fish/conf.d/20_env.fish".source = ../../.config/fish/conf.d/20_env.fish;
      ".config/fish/conf.d/30_path.fish".source = ../../.config/fish/conf.d/30_path.fish;
      ".config/fish/conf.d/50_shell.fish".source = ../../.config/fish/conf.d/50_shell.fish;
      ".config/fish/functions/base64.fish".source = ../../.config/fish/functions/base64.fish;
      ".config/fish/functions/misc.fish".source = ../../.config/fish/functions/misc.fish;
      ".config/ghostty/config".source = ../../.config/ghostty/config;
      ".config/gitu".source = ../../.config/gitu;
      ".config/helix/config.toml".source = ../../.config/helix/config.toml;
      ".config/helix/languages.toml".source = ../../.config/helix/languages.toml;
      ".config/nvim" = {
        source = ../../.config/nvim;
        recursive = true;
      };
      ".config/.ripgreprc".source = ../../.config/.ripgreprc;
      ".config/starship.toml".source = ../../.config/starship.toml;
      ".config/wezterm" = {
        source = ../../.config/wezterm;
        recursive = true;
      };
      ".gitconfig".source = ../../.gitconfig;
      ".gitignore".source = ../../global_gitignore;
      ".inputrc".source = ../../.inputrc;
      "bin".source = ../../bin;
    };
  };
}
