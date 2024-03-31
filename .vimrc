filetype plugin indent on

syntax enable
syntax on
set t_Co=256
set termguicolors

set shell=/run/current-system/sw/bin/bash
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
set laststatus=2
set showtabline=2
set noshowmode
set foldmethod=manual
set shortmess+=c
set signcolumn=yes
set encoding=UTF-8
set hidden
