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
Plugin 'mrk21/yaml-vim'

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
set lazyredraw
set tabstop=4 " use 4 spaces to represent tab
set softtabstop=4
set expandtab " enter spaces when tab is pressed
set shiftwidth=4 " number of spaces to use for auto indent
set smarttab
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

if expand('%:t') == "git-rebase-todo"
    nnoremap p 0ciwpick<ESC>0
    nnoremap r 0ciwreword<ESC>0
    nnoremap e 0ciwedit<ESC>0
    nnoremap s 0ciwsquash<ESC>0
    nnoremap f 0ciwfixup<ESC>0
    nnoremap x 0ciwexec<ESC>0
    nnoremap d 0ciwdrop<ESC>0
endif

au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml " foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
au BufRead,BufNewFile *.py set expandtab
au BufRead,BufNewFile *.c set noexpandtab
au BufRead,BufNewFile *.h set noexpandtab
au BufRead,BufNewFile Makefile* set noexpandtab

" Move lines up or down. From:
" https://vim.fandom.com/wiki/Moving_lines_up_or_down and
" https://stackoverflow.com/a/24047539/5515387
" Use Alt-Up and Alt-Down to move line (or block of lines) up and down
" Needs to have Alt-Up and Alt-Down remapped to 'Send escape sequence [0;ALTUP'
" and 'Send escape sequence [0;ALTDOWN' in Iterm2 Profiles > Keys
nnoremap <Esc>[0;ALTUP :m .-2<CR>==
nnoremap <Esc>[0;ALTDOWN :m .+1<CR>==
inoremap <Esc>[0;ALTUP <Esc>:m .-2<CR>==gi
inoremap <Esc>[0;ALTDOWN <Esc>:m .+1<CR>==gi
vnoremap <Esc>[0;ALTUP :m '<-2<CR>gv=gv
vnoremap <Esc>[0;ALTDOWN :m '>+1<CR>gv=gv

" Buffer keybinding
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>
