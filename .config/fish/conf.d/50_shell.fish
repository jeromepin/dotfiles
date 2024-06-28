fzf --fish | source

# Use kubectl's completion on `k`
complete k -n __kubectl_clear_perform_completion_once_result

starship init fish | source

source ~/.config.fish.local