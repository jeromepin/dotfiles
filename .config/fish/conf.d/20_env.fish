set -gx TERM screen-256color
set -gx EDITOR "nvim"

set -gx BAT_PAGER "less"
set -gx PAGER "less"
set -gx MANPAGER "sh -c 'col -bx | bat --style=plain --color=always --language=man --pager=less --paging=always'"
set -gx MANROFFOPT "-c"

set -gx FZF_DEFAULT_COMMAND 'fd --follow --exclude .git'
set -gx GOPATH $HOME/go
set -gx RIPGREP_CONFIG_PATH $HOME/.config/.ripgreprc
