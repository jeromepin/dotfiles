if expand('%:t') == "git-rebase-todo"
    nnoremap p 0ciwpick<ESC>0
    nnoremap r 0ciwreword<ESC>0
    nnoremap e 0ciwedit<ESC>0
    nnoremap s 0ciwsquash<ESC>0
    nnoremap f 0ciwfixup<ESC>0
    nnoremap x 0ciwexec<ESC>0
    nnoremap d 0ciwdrop<ESC>0
endif

" When editing a Git commit, automatically go to the end of the line when
" opening vim
augroup git_commit
    autocmd!

    autocmd BufReadPost *
        \  if &filetype == 'gitcommit'
        \|     execute 'normal $'
        \| endif
augroup end

" au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml " foldmethod=indent
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
" autocmd FileType notes setlocal nofoldenable
" au BufRead,BufNewFile *.py set expandtab
" au BufRead,BufNewFile *.c set noexpandtab
" au BufRead,BufNewFile *.h set noexpandtab
" au BufRead,BufNewFile Makefile* set noexpandtab
" autocmd FileType help wincmd L " Open help window in a vertical split

" Move lines up or down. From:
" https://vim.fandom.com/wiki/Moving_lines_up_or_down and
" https://stackoverflow.com/a/24047539/5515387
" Use Alt-Up and Alt-Down to move line (or block of lines) up and down
" Needs to have Alt-Up and Alt-Down remapped to 'Send escape sequence [0;ALTUP'
" and 'Send escape sequence [0;ALTDOWN' in Iterm2 Profiles > Keys
" nnoremap <Esc>[0;ALTUP :m .-2<CR>==
" nnoremap <Esc>[0;ALTDOWN :m .+1<CR>==
" inoremap <Esc>[0;ALTUP <Esc>:m .-2<CR>==gi
" inoremap <Esc>[0;ALTDOWN <Esc>:m .+1<CR>==gi
" vnoremap <Esc>[0;ALTUP :m '<-2<CR>gv=gv
" vnoremap <Esc>[0;ALTDOWN :m '>+1<CR>gv=gv

nnoremap bp :bprev<CR>
nnoremap bn :bnext<CR>
nnoremap bd :bp\|bd #<CR>

" Window keybinding
" @(Use j to move to left window)
nnoremap j <C-W>h
" @(Use k to move to right window)
nnoremap k <C-W>l

" Use Esc to go back to normal mode when using integrated Terminal
" @(Exit from terminal mode)
tnoremap <Esc> <C-\><C-n>

" @(Toggle file nvim-tree explorer)
nnoremap <silent> [ :Telescope file_browser<CR>

" Needs to have Command + / mapped to 'Send text with vim special chars `,cc`'
" in iTerm2 Profiles > Keys
" @(Comment out the line with Command + /)
noremap ,cc :Commentary<cr>
inoremap ,cc <ESC>:Commentary<CR>

" List all files in current directory recursively
" @(List all files in git directory)
nmap ;p :Telescope git_files<CR>

" List files from git-status
" @(Show all files from git's status)
nmap ;s :Telescope git_status<CR>

" Show buffers in a preview window
" @(Show buffers)
nmap ;b :Telescope buffers<CR>

" Show MRU files
" @(Show Most Recently Used files)
nmap ;m :Telescope oldfiles<CR>

" Show, edit and execute recents command along with available commands
" @(Execute and edit command history)
nmap ;c :Telescope commands<CR>

" Lists Available plugin/user commands and run it
" @(Lists Available commands)
nmap <C-p> :Clap commandpalette<CR>

" Use FZF to list files in the whole root directory
" @(List all files in the git directory including the ones excluded from git)
nmap <C-p>a :Telescope find_files<CR>

" Show the terragrunt module variables in a vertical split
" @(Show the terragrunt module variables in a vertical split)
nmap tv :TerragruntShowVariables<CR>

" Explore the terragrunt module in a vertical split using netrw
" @(Explore the terragrunt module in a vertical split using netrw)
nmap tm :TerragruntExploreModule<CR>
