filetype plugin indent on

syntax enable
syntax on
set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
colorscheme onedark

set shell=/opt/local/bin/bash
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
set rtp+=/Users/jeromepin/.asdf/shims/fzf
set laststatus=2
set showtabline=2
set noshowmode
set foldmethod=manual
set updatetime=100  " Delay for vim to write its swap file and display gitgutter infos
set shortmess+=c
set signcolumn=yes
set encoding=UTF-8
set splitbelow
set splitright
set hidden
" Vim will change the current working directory whenever you open a file, switch buffers, delete a buffer or open/close a window.
" It will change to the directory containing the file which was opened or selected.
" set autochdir

set guicursor=n-i-ci-ve:ver100-iCursor-blinkwait150-blinkon150-blinkoff150
:au VimLeave * set guicursor=a:ver100-iCursor-blinkwait150-blinkon150-blinkoff150

au FileType gitcommit setlocal tw=180

let g:python3_host_prog = '/Users/jeromepin/.asdf/shims/python3'
