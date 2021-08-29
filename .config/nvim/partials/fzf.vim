"""""""""""""""""""""""""""""""""""""""""""
"       FzfPreview config
"""""""""""""""""""""""""""""""""""""""""""
let g:fzf_preview_command = 'bat --color=always --style=grid {-1}'
let g:fzf_preview_filelist_command = 'rg --files --follow --no-messages -g \!"* *"'
let g:fzf_preview_lines_command = 'bat --color=always --style=grid --theme=ansi-dark --plain'
let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" exa --color=always'
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never .'
let g:fzf_preview_use_dev_icons = 1
