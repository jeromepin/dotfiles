let s:commands_mapping = {
    \ "Sort Lines Ascending": {
    \   "command": "sort",
    \   "mode": "vline"
    \ },
    \ "Sort Lines Descending": {
    \   "command": "sort!",
    \   "mode": "vline"
    \ },
    \ "Show User Mappings": {
    \   "command": "MyKeymap",
    \ },
    \ "Search: Replace In Files": {
    \   "command": "Farr",
    \ },
\ }

function! s:available_commands() abort
    return keys(s:commands_mapping)
endfunction

function! s:on_select(selected_command_name) abort
    let l:definition = get(s:commands_mapping, a:selected_command_name)
    let l:command = get(l:definition, "command")
    let l:mode = get(l:definition, "mode", "normal")

    if l:mode ==# "vline"
        let l:command = "'<,'>" . l:command
    endif

    execute l:command
endfunction

" `:Clap commandpalette` to open some dotfiles quickly.
let g:clap_provider_commandpalette = {
\ 'source': function('s:available_commands'),
\ 'sink': function('s:on_select'),
\ }
