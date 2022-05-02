local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

-- Disable built-in unused plugins
for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 0
end

vim.cmd [[packadd packer.nvim]]

require('packer').startup({
    function(use)
        -- https://github.com/wbthomason/packer.nvim
        use 'wbthomason/packer.nvim'

        -- Vim & UI
        use {
            -- OneDark colorscheme
            { 
                'navarasu/onedark.nvim',
                config = [[require('onedark').load()]],
                -- after = "packer.nvim",
            },
            
            -- Speed up loading Lua modules in Neovim to improve startup time
            {
                'lewis6991/impatient.nvim',
                tag = 'v0.1',
            },

            -- adds indentation guides to all lines
            {
                'lukas-reineke/indent-blankline.nvim',
                config = [[require("indent_blankline").setup{show_current_context = true, show_current_context_start = true,}]],
                tag = 'v2.12.1',
            },

            -- A minimal, stylish and customizable statusline for Neovim written in Lua
            {
                'feline-nvim/feline.nvim',
                config = [[require('feline').setup()]],
                tag = 'v1.0.0',
            },

            -- Fix CursorHold Performance
            {
                'antoinemadec/FixCursorHold.nvim',
            },

            -- Foldtext customization and folded region preview in Neovim
            -- {
            --     'anuvyklack/pretty-fold.nvim',
            --     config = function()
            --         require('pretty-fold').setup{}
            --         require('pretty-fold.preview').setup()
            --     end,
            -- },

            -- Orgmode clone written in Lua
            {
                'nvim-orgmode/orgmode',
                tag = '0.2.1',
                config = [[require('plugins.orgmode')]],
                after = 'nvim-treesitter',
                requires = {
                    { 'akinsho/org-bullets.nvim' },
                    { 'nvim-treesitter/nvim-treesitter' },
                }
            },

            -- Tabline
            {
                'romgrk/barbar.nvim',
                commit = 'be65945626fb6bf6058cae61d5176d156f923c11',
                requires = {'kyazdani42/nvim-web-devicons'},
            },

            -- Neovim plugin with collection of minimal, independent, and fast Lua modules
            {
                'echasnovski/mini.nvim',
                tag = 'v0.3.0',
                config = [[require('plugins.mini')]],
            },

            -- displays a popup with possible keybindings of the command you started typing
            {
                'folke/which-key.nvim',
                config = [[require('plugins.whichkey')]],
            },

            -- Easily jump between NeoVim windows
            {
                'https://gitlab.com/yorickpeterse/nvim-window.git',
            },

            {
                'glepnir/dashboard-nvim',
                config = [[require('plugins.dashboard')]],
            },
        }

        -- Lanugages
        use {
            -- Neovim's syntax parser and highlighter
            {
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate',
                config = [[require('plugins.treesitter')]],
            },

            -- Render markdown on the CLI
            {
                'ellisonleao/glow.nvim',
                event = "BufRead",
            },

            -- A simple, easy-to-use Vim alignment plugin
            {
                'junegunn/vim-easy-align',
                tag = '2.10.0',
                event = "InsertEnter",
            },

            {
                'terrortylor/nvim-comment',
                config = [[require('plugins.comment')]],
            },
        }

        -- Git
        use {
            -- Super fast git decorations
            {
                'lewis6991/gitsigns.nvim',
                tag = 'v0.4',
                requires = { 'nvim-lua/plenary.nvim' },
                config = [[require('gitsigns').setup()]],
                event = "BufRead",
            },

            -- A Git wrapper so awesome, it should be illegal
            {
                'tpope/vim-fugitive',
                tag = 'v3.6',
                requires = { 'tpope/vim-rhubarb' }
            },
        }

        -- Telescope & File exploration/browser
        use {
            -- highly extendable fuzzy finder over lists
            {
                'nvim-telescope/telescope.nvim',
                tag = 'nvim-0.5.1',
                requires = {
                    { 'nvim-lua/popup.nvim' },
                    { 'nvim-lua/plenary.nvim' },
                    { 'nvim-treesitter/nvim-treesitter' },
                    -- file browser extension for telescope.nvim
                    { 'nvim-telescope/telescope-file-browser.nvim' },
                    -- FZF sorter for telescope written in c
                    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
                },
                config = [[require('plugins.telescope')]],
            },

            -- Terminal manager for (neo)vim
            {
                'voldikss/vim-floaterm',
                config = [[vim.g.floaterm_opener = 'edit']],
            },

            -- An incremental narrowing engine for (neo)vim inspired by emacs helm/ivy/ido
            {
                'conweller/findr.vim',
            },
        }

        -- Search and replace
        use {
            'brooth/far.vim',
            commit = '611d9c221c370a64f582c3dc4c38f9ea7b29f441',
        }

        -- Completion & LSP
        use {
            -- seamlessly manage LSP servers with :LspInstall
            {
                'williamboman/nvim-lsp-installer',
                commit = 'e79f0a516e2e2a33a4493df4b9eac47013f37b69',
            },

            {
                'ms-jpq/coq_nvim',
                branch = 'coq',
                run = ":COQdeps",
                -- event = "InsertEnter",
                requires = {
                    { 'onsails/lspkind-nvim' },
                    { 'ms-jpq/coq.artifacts' },
                    { 'ms-jpq/coq.thirdparty' },
                },
                -- config = [[require('plugins.coq')]],
                -- after = 'nvim-lsp-installer'

            },
            
            -- A collection of common configurations for Neovim's built-in language server client.
            {
                'neovim/nvim-lspconfig',
                tag = 'v0.1.2',
                requires = {
                    -- A tree like view for symbols in Neovim using LSP.
                    'simrat39/symbols-outline.nvim'
                },
                config = [[require('plugins.lsp')]],
                -- After COQ because plugins.lsp requires coq
                after = 'nvim-lsp-installer',
            },

            -- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI
            {
                'tami5/lspsaga.nvim',
                requires = { 'neovim/nvim-lspconfig' },
                config = [[require('lspsaga').init_lsp_saga()]],
                -- branch = 'nvim6.0' or 'nvim51'
            },
        }

        -- Snippets
        use {
            'dcampos/nvim-snippy',
            config = [[require('plugins.snippets')]],
            requires = { 'honza/vim-snippets' },
        }

        -- -- File Manager for Neovim
        -- -- Open: Enter
        -- -- Collapse/Expand: Tab
        -- -- Filter in directory: f
        -- -- Change focus to folder at cursor: c
        -- -- Change focus to parent dir: C
        -- use {
        --     'ms-jpq/chadtree',
        --     branch = 'chad',
        --     run = 'python3 -m chadtree deps',
        --     config = [[require('plugins.tree')]],
        -- }
    end,

    config = {
        display = {
            open_fn = require('packer.util').float,
        },
    },
})
