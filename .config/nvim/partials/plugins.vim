if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/vim-plug-plugins')

Plug 'joshdick/onedark.vim' " OneDark color scheme
" Plug 'neoclide/coc.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary' " Toogle comments
" Plug 'liuchengxu/vim-clap' " modern generic interactive finder and dispatcher
Plug 'mhinz/vim-startify'
Plug 'nvim-treesitter/nvim-treesitter' " Neovim's syntax parser and highlighter
Plug 'rBrda/myKeymap' " list and search key mappings in a floating window using FZF
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'  " A File Explorer For Neovim Written In Lua
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " Semshi provides semantic highlighting for Python in Neovim
Plug 'neovim/nvim-lspconfig' " Collection of common configurations for Neovim's built-in language server client.
Plug 'jiangmiao/auto-pairs'
Plug 'haya14busa/is.vim' " is.vim improves search feature
Plug 'dyng/ctrlsf.vim' " An ack/ag/pt/rg powered code search and view tool
Plug 'romgrk/barbar.nvim' " tabline plugin
Plug 'onsails/lspkind-nvim' " Adds vscode-like pictograms to neovim built-in lsp
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim' " Super fast git decorations
Plug 'nvim-lua/popup.nvim'  " Required by Telescope
Plug 'nvim-lua/plenary.nvim' " Required by Telescope
Plug 'nvim-telescope/telescope.nvim'  " highly extendable fuzzy finder over lists
Plug 'hashivim/vim-terraform'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""
"           MyKeymap config
"""""""""""""""""""""""""""""""""""""""""""
let g:myKeymapSettings = {
  \ 'show_details': ['action'],
  \ 'disable_cache': 0,
  \ }
