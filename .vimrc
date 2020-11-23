"""""""""""""""""""""""""""""""""""""""""""
"           Plug config
"""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/vim-plug-plugins')

" Plug 'airblade/vim-gitgutter' " shows a git diff in the sign column
Plug 'joshdick/onedark.vim' " OneDark color scheme
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
" Plug 'sheerun/vim-polyglot' " Language packs
Plug 'neoclide/coc.nvim'
" Plug 'tpope/vim-eunuch' " Helpers for UNIX filesystem
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' } " Use FZF in a floating-window
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary' " Toogle comments
Plug 'editorconfig/editorconfig-vim'
" Plug 'tpope/vim-fugitive' " Git plugin so awesome, it should be illegal
" Plug 'samoshkin/vim-mergetool'
Plug 'brooth/far.vim' " Far.vim makes it easier to find and replace text through multiple files
Plug 'liuchengxu/vim-clap' " modern generic interactive finder and dispatcher
Plug 'mhinz/vim-startify'
Plug 'nvim-treesitter/nvim-treesitter' " Neovim's syntax parser and highlighter
Plug 'rBrda/myKeymap' " list and search key mappings in a floating window using FZF

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""
"           MyKeymap config
"""""""""""""""""""""""""""""""""""""""""""
let g:myKeymapSettings = {
  \ 'show_details': ['action'],
  \ 'disable_cache': 0,
  \ }


"""""""""""""""""""""""""""""""""""""""""""
"           Far config
"""""""""""""""""""""""""""""""""""""""""""
let g:far#source = 'rg'
" let g:far#source = 'rgnvim'
let g:far#window_width = 150
let g:far#preview_window_height = 25
let g:far#file_mask_favorites = ['%:p', '**/*.py', '**/*.tf', '**/*.tpl']


"""""""""""""""""""""""""""""""""""""""""""
"           Startify config
"""""""""""""""""""""""""""""""""""""""""""
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

let g:startify_bookmarks = [ {'i': '~/git/github/lumapps/infra'},  {'g': '~/git/github/lumapps/github-automation'}, {'a': '~/git/github/lumapps/argocd'}]

"""""""""""""""""""""""""""""""""""""""""""
"       Lightline config
"""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
  \ 'colorscheme': 'powerline',
  \ 'tabline': {
  \   'left': [ ['buffers'] ],
  \   'right': [ ['close'] ]
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers'
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel'
  \ }
\ }

let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#filename_modifier = ':t'

"""""""""""""""""""""""""""""""""""""""""""
"       		COC config
"""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = ['coc-json', 'coc-python', 'coc-yaml', 'coc-sh', 'coc-snippets']
let g:coc_snippet_next = '<tab>'

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""
"       FzfPreview config
"""""""""""""""""""""""""""""""""""""""""""
let g:fzf_preview_command = 'bat --color=always --style=grid {-1}'
let g:fzf_preview_filelist_command = 'rg --files --follow --no-messages -g \!"* *"'
let g:fzf_preview_lines_command = 'bat --color=always --style=grid --theme=ansi-dark --plain'
let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" exa --color=always'
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never .'
let g:fzf_preview_use_dev_icons = 1


"""""""""""""""""""""""""""""""""""""""""""
"               Clap config
"""""""""""""""""""""""""""""""""""""""""""
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


"""""""""""""""""""""""""""""""""""""""""""
"       	Tree-sitter config
"""""""""""""""""""""""""""""""""""""""""""

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python" },
  highlight = {
    enable = true,
    use_languagetree = false, -- Use this to enable language injection (this is very unstable)
  },
  indent = {
    enable = true
  }
}
EOF


"""""""""""""""""""""""""""""""""""""""""""
"       		Vim config
"""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

syntax enable
syntax on
set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
colorscheme onedark

set shell=/usr/local/bin/bash
set number
set mouse=
autocmd BufEnter * set mouse=
set background=dark
set backspace=indent,eol,start
set modeline
set modelines=4


if has('vim')
	fixdel
endif
set virtualedit=onemore
set cursorline
set showmatch
set incsearch
set hlsearch
set ignorecase
set wildmenu
set wildmode=list:longest,full
set nowrap
set autoindent
set lazyredraw smartcase
set tabstop=4 " use 4 spaces to represent tab
set softtabstop=4
set expandtab " enter spaces when tab is pressed
set shiftwidth=4 " number of spaces to use for auto indent
set smarttab
set sts=4
set rtp+=/usr/local/opt/fzf
set laststatus=2
set showtabline=2
set noshowmode
set foldmethod=manual
set updatetime=100  " Delay for vim to write its swap file and display gitgutter infos
set shortmess+=c
set signcolumn=yes
set encoding=UTF-8
set hidden
" Vim will change the current working directory whenever you open a file, switch buffers, delete a buffer or open/close a window.
" It will change to the directory containing the file which was opened or selected.
" set autochdir

set guicursor=n-i-ci-ve:ver100-iCursor-blinkwait150-blinkon150-blinkoff150
:au VimLeave * set guicursor=a:ver100-iCursor-blinkwait150-blinkon150-blinkoff150

let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
let loaded_netrwPlugin = 1

let g:python3_host_prog = '/Users/jeromepin/.asdf/shims/python3'

"""""""""""""""""""""""""""""""""""""""""""
"       Keys mapping & shortcuts
"""""""""""""""""""""""""""""""""""""""""""
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


" When pressing Tab
" If the completion window is visible, complete
" If we want a tab, print a Tab char
" Inspiration : https://www.reddit.com/r/neovim/comments/ev7w8u/possible_to_configure_cocnvim_to_autoaccept_fill/
inoremap <silent><expr> <Tab>
      \ pumvisible() ? coc#_select_confirm() :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use K to show documentation in preview window.
" @(Show function's documentation in a preview window)
nnoremap <silent> k :call <SID>show_documentation()<CR>

" Use Esc to go back to normal mode when using integrated Terminal
" @(Exit from terminal mode)
tnoremap <Esc> <C-\><C-n>

" @(Toggle Coc's explorer)
nnoremap <silent> - :CocCommand explorer<CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif " Close coc-explorer if its the last one open

" Needs to have Command + / mapped to 'Send text with vim special chars `,cc`'
" in iTerm2 Profiles > Keys
" @(Comment out the line with Command + /)
noremap ,cc :Commentary<cr>
inoremap ,cc <ESC>:Commentary<CR>

" List all files in current directory recursively
" @(List all files in git directory)
nmap ;p :FzfPreviewGitFiles<CR>
" List files from git-status
" @(Show all files from git's status)
nmap ;s :FzfPreviewGitStatus<CR>
" Find in current directory
" nmap ;g :FzfPreviewProjectGrep<CR>
" Show buffers in a Clap preview window
" @(Show buffers)
nmap ;b :Clap buffers<CR>
" Show MRU files
" @(Show Most Recently Used files)
nmap ;m :FzfPreviewMruFiles<CR>
" Open the custom command palette
" @(Open my custom CommandPalette)
nmap <C-p> :Clap commandpalette<CR>
" Use FZF to list files in the whole root directory
" @(List all files in the git directory including the ones excluded from git)
nmap <C-p>a :Files <C-R>=substitute(system('git rev-parse --show-toplevel'), '\n', '', 'g')<CR><CR>

