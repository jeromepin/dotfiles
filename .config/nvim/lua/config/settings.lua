-- vim.api.nvim_set_option('smarttab', false)
-- print(vim.api.nvim_get_option('smarttab')) -- false
-- vim.o                                                   *vim.o*
--         Get or set editor options, like |:set|. Invalid key is an error.
--         Example:
--             vim.o.cmdheight = 4
--             print(vim.o.columns)

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Disable mouse
vim.o.mouse = ''

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 100
vim.wo.signcolumn = 'yes'

-- Time in milliseconds to wait for a mapped sequence to complete.
-- Defaults to 1000. Decreased to 500 to make which-key more comfortable to use
vim.o.timeoutlen = 500

vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noinsert'

-- Enable auto completion menu after pressing TAB.
vim.o.wildmenu = true

vim.o.wildmode = 'list:longest,full'

vim.o.laststatus = 2

vim.o.showtabline = 2

-- vim.o.t_Co = "256"
-- vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
-- vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum"

vim.o.shell = "/run/current-system/sw/bin/bash"

vim.o.cursorline = true
vim.o.showmatch = true
vim.o.incsearch = true

-- Live substitution when doing :%s/...
-- From https://www.reddit.com/r/neovim/comments/r77piz/live_substitution_by_default_on_neovim_06_thanks/
vim.o.inccommand = "nosplit"

-- Dont' wrap lines
vim.o.wrap = false

vim.o.autoindent = true

vim.o.lazyredraw = true

--  use 4 spaces to represent tab
vim.o.tabstop = 4

vim.o.softtabstop = 4

-- enter spaces when tab is pressed
vim.o.expandtab = true

-- number of spaces to use for auto indent
vim.o.shiftwidth = 4

vim.o.smarttab = true

vim.o.sts = 4

vim.o.rtp = "~/.asdf/shims/fzf," .. vim.o.rtp

-- set noshowmode
vim.o.encoding = "UTF-8"

-- Horizontal split is created below
vim.o.splitbelow = true

-- Vertical split is created right
vim.o.splitright = true

vim.o.guicursor = "n-i-ci-ve:ver100-iCursor-blinkwait150-blinkon150-blinkoff150"

vim.g.python3_host_prog = "~/neovim-venv/bin/python3"

-- Enable single global statusline for the current windows
vim.o.laststatus = 3

-- Automatically set the global current directory to match the location of the current file
vim.o.autochdir = true

vim.o.clipboard = "unnamed"

vim.g.mapleader = " "