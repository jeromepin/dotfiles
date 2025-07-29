set -gx NIX_PATH "nixpkgs=flake:nixpkgs"
set -gx TERM xterm
set -gx EDITOR hx

set -gx BAT_PAGER "most"
set -gx PAGER "less -eiRMX"
set -gx MANPAGER "most"
set -gx MANROFFOPT "-c"

set -gx FZF_DEFAULT_COMMAND 'fd --follow --exclude .git'
set -gx GOPATH $HOME/go
set -gx RIPGREP_CONFIG_PATH $HOME/.config/.ripgreprc
set -gx EGET_BIN $HOME/eget-bin
