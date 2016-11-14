set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin declaration
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tomasr/molokai'

call vundle#end()            " required
filetype plugin indent on    " required

" Define colors
syntax enable
syntax on
set t_Co=256
colorscheme molokai
let g:molokai_original = 1

set shell=/bin/bash
set number
set mouse=
autocmd BufEnter * set mouse=
set background=dark
set backspace=indent,eol,start

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
set lazyredraw
set tabstop=4
set sts=4
set rtp+=$HOME/.vim/bundle/powerline/powerline/bindings/vim/
set laststatus=2
set showtabline=2
set noshowmode

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'

" Syntastic
let g:syntastic_c_check_header 		= 1
let g:syntastic_c_compiler 		= 'gcc'
let g:syntastic_cpp_check_header 	= 1
let g:syntastic_cpp_check_header 	= 'g++'
let g:syntastic_check_on_open 		= 1
let g:syntastic_enable_signs 		= 1
let g:syntastic_error_symbol 		= '✗'
let g:syntastic_warning_symbol 		= '!'
let g:syntastic_python_python_exec 	= '/usr/bin/python3'

" Buffer keybinding
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>
