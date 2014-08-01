set shell=/bin/bash
set number
set background=dark
syntax on
set nocompatible
filetype off
set backspace=indent,eol,start
:fixdel
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

nmap <C-t> :TagbarToggle<CR>

map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

set t_Co=256
colorscheme molokai
let g:molokai_original = 1

let g:syntastic_c_check_header = 1
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_check_header = 'g++'

set lazyredraw
let g:airline_theme             = 'powerlineish'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'vim-scripts/a.vim'
Plugin 'majutsushi/tagbar'
Plugin 'bling/vim-airline'
Plugin 'jeetsukumaran/vim-buffergator'

call vundle#end()            " required
filetype plugin indent on    " required
