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

require("lazy").setup({

    -- Vim & UI
    {
        -- colorscheme
        {
            'tomasr/molokai',
            priority = 1000,
            lazy = false,
            -- config = function()
            --     vim.cmd('colorscheme molokai')
            -- end
        },

        {
           "navarasu/onedark.nvim",
            priority = 1000,
            lazy = false,
            config = function()
                vim.cmd('colorscheme onedark')
            end
        },

        -- Speed up loading Lua modules in Neovim to improve startup time
        {
            'lewis6991/impatient.nvim',
            tag = 'v0.1',
        },

        -- adds indentation guides to all lines
        {
            'lukas-reineke/indent-blankline.nvim',
            config = function()
                require("indent_blankline").setup { show_current_context = true, show_current_context_start = true, }
            end,
            tag = 'v2.12.1',
        },


        -- Fix CursorHold Performance
        {
            'antoinemadec/FixCursorHold.nvim',
        },

        -- Orgmode clone written in Lua
        {
            'nvim-orgmode/orgmode',
            -- tag = '0.2.1',
            config = function()
                require('plugins.orgmode')
            end,
            after = 'nvim-treesitter',
            dependencies = {
                'akinsho/org-bullets.nvim',
                'nvim-treesitter/nvim-treesitter',
            }
        },

        -- Tabline
        -- https://github.com/akinsho/bufferline.nvim
        {
            'akinsho/bufferline.nvim',
            tag = 'v3.1.0',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require("bufferline").setup {
                    options = {
                        -- close_command = "bdelete! %d",
                        close_command = "Sayonara %d",
                        show_close_icon = false,
                        indicator = {
                            -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
                            style = 'underline', -- 'icon',
                        },
                        always_show_bufferline = true,
                    }
                }
            end,
        },

        -- Neovim plugin with collection of minimal, independent, and fast Lua modules
        {
            'echasnovski/mini.nvim',
            tag = 'v0.3.0',
            config = function()
                require('plugins.mini')
            end,
        },

        -- displays a popup with possible keybindings of the command you started typing
        {
            'folke/which-key.nvim',
            config = function()
                require('plugins.whichkey')
            end,
        },

        -- Easily jump between NeoVim windows
        {
            url = 'https://gitlab.com/yorickpeterse/nvim-window.git',
        },

        -- Sane buffer/window deletion
        -- https://github.com/mhinz/vim-sayonara
        {
            'mhinz/vim-sayonara',
        },

        -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
        -- https://github.com/nvim-lualine/lualine.nvim
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require('plugins.statusline')
            end,
        }
    },

    -- Lanugages
    {
        -- Neovim's syntax parser and highlighter
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            config = function()
                require('plugins.treesitter')
            end,
        },

        {
            'nvim-treesitter/playground',
            dependencies = { 'nvim-treesitter/nvim-treesitter' }
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

        -- A comment toggler for Neovim, written in Lua
        {
            'terrortylor/nvim-comment',
            config = function()
                require('plugins.comment')
            end,
        },

        -- Auto close pairs
        {
            'cohama/lexima.vim',
            commit = 'b1e1b1bde07c1efc97288c98c5912eaa644ee6e1',
            event = {'InsertEnter','CmdlineEnter'},
            -- config = function()
            --     require('pairs'):setup()
            -- end,
        }

    },

    -- Git
    {
        -- Super fast git decorations
        {
            'lewis6991/gitsigns.nvim',
            tag = 'v0.6',
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                require('gitsigns').setup()
            end,
            event = "BufRead",
        },

        -- A Git wrapper so awesome, it should be illegal
        {
            'tpope/vim-fugitive',
            tag = 'v3.6',
            dependencies = { 'tpope/vim-rhubarb' }
        },

        -- Magit for NeoVim
        {
            'TimUntersberger/neogit',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'sindrets/diffview.nvim',
            },
            config = function()
                require('plugins.git')
            end,
        }
    },

    -- Telescope & File exploration/browser
    {
        -- highly extendable fuzzy finder over lists
        {
            'nvim-telescope/telescope.nvim',
            tag = 'nvim-0.5.1',
            dependencies = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'nvim-treesitter/nvim-treesitter',
                -- file browser extension for telescope.nvim
                'nvim-telescope/telescope-file-browser.nvim',
                -- FZF sorter for telescope written in c
                'nvim-telescope/telescope-fzf-native.nvim',
            },
            config = function()
                require('plugins.telescope')
            end,
        },

        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },

        -- Terminal manager for (neo)vim
        {
            'voldikss/vim-floaterm',
            config = function()
                vim.g.floaterm_opener = 'edit'
            end,
        },

        -- An incremental narrowing engine for (neo)vim inspired by emacs helm/ivy/ido
        {
            'conweller/findr.vim',
        },

        -- A tiny project + sessions manager
        -- https://github.com/GnikDroy/projections.nvim
        {
            'gnikdroy/projections.nvim',
            dependencies = { 'nvim-telescope/telescope.nvim' },
            branch = 'pre_release',
            config = function()
                require("projections").setup({
                    workspaces = {
                        { "~/git/github/lumapps",   { ".git" } },
                        { "~/git/github/jeromepin", { ".git" } },
                    },
                })

                require('telescope').load_extension('projections')
            end
        },
    },

    -- Search and replace
    {
        {
            'brooth/far.vim',
            commit = '611d9c221c370a64f582c3dc4c38f9ea7b29f441',
        },

        {
            'windwp/nvim-spectre',
            config = function()
                require('spectre').setup()
            end,
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
        }
    },

    -- Completion & LSP
    {
        -- seamlessly manage LSP servers with :LspInstall
        {
            'williamboman/nvim-lsp-installer',
            commit = 'e79f0a516e2e2a33a4493df4b9eac47013f37b69',
        },

        -- -- nvim-cmp & plugins
        -- {
        --     'hrsh7th/nvim-cmp',
        --     config = function()
        --         require('plugins.completion')
        --     end,
        --     dependencies = {
        --         'onsails/lspkind-nvim',
        --         'neovim/nvim-lspconfig',
        --         'hrsh7th/cmp-cmdline',
        --         'hrsh7th/cmp-buffer',
        --         'hrsh7th/cmp-nvim-lsp',
        --         'hrsh7th/cmp-path',
        --     },
        -- },

        -- A collection of common configurations for Neovim's built-in language server client.
        {
            'neovim/nvim-lspconfig',
            tag = 'v0.1.2',
            dependencies = {
                -- A tree like view for symbols in Neovim using LSP.
                'simrat39/symbols-outline.nvim'
            },
            config = function()
                require('plugins.lsp')
            end,
            -- After COQ because plugins.lsp requires coq
            after = 'nvim-lsp-installer',
        },

        -- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI
        {
            'tami5/lspsaga.nvim',
            dependencies = { 'neovim/nvim-lspconfig' },
            config = function()
                require('lspsaga').init_lsp_saga()
            end,
            -- branch = 'nvim6.0' or 'nvim51'
        },

        -- A pretty diagnostics, references, telescope results, quickfix and location list
        -- https://github.com/folke/trouble.nvim
        {
            "folke/trouble.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },

        -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
        -- https://github.com/williamboman/mason.nvim
        {
            'williamboman/mason.nvim',
            config = function()
                require("mason").setup()
            end,
        },

        -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
        -- https://github.com/williamboman/mason-lspconfig.nvim
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = { 'neovim/nvim-lspconfig' },
            config = function()
                require("mason-lspconfig").setup {
                    ensure_installed = {
                        "pyright",
                        -- "terraform-ls"
                    },
                }
            end
        },
    },

    -- Snippets
    {
        'L3MON4D3/LuaSnip',
        config = function()
            require('plugins.snippets')
        end,
        dependencies = {
            'honza/vim-snippets',
            -- { 'rafamadriz/friendly-snippets' },
        }
    },

    -- File Manager for Neovim
    {
        -- Neovim file explorer: edit your filesystem like a buffer
        -- https://github.com/stevearc/oil.nvim
        {
            'stevearc/oil.nvim',
            config = function() require('oil').setup() end
        },
    },

})
