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
        -- https://github.com/navarasu/onedark.nvim
        {
           "navarasu/onedark.nvim",
            priority = 1000,
            lazy = false,
            config = function()
                vim.cmd('colorscheme onedark')
            end
        },

        -- adds indentation guides to all lines
        {
            'lukas-reineke/indent-blankline.nvim',
            version = '3.5.*',
            main = "ibl",
            config = function()
                require("ibl").setup {}
            end,
        },

        -- Tabline
        -- https://github.com/akinsho/bufferline.nvim
        {
            'akinsho/bufferline.nvim',
            version = '4.*',
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
        -- https://github.com/echasnovski/mini.nvim
        {
            'echasnovski/mini.nvim',
            version = '0.3.*',
            config = function()
                require('plugins.mini')
            end,
        },

        -- displays a popup with possible keybindings of the command you started typing
        -- https://github.com/folke/which-key.nvim
        {
            'folke/which-key.nvim',
            version = '3.3.*',
            event = "VeryLazy",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
                "echasnovski/mini.icons",
            },
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
        },

        -- displays available actions like 'Go to Definition' and 'Go to Reference(s)' when available
        -- https://github.com/roobert/action-hints.nvim
        {
            "roobert/action-hints.nvim",
            config = function()
                require("action-hints").setup({
                    template = {
                        definition = { text = " ⊛", color = "#add8e6" },
                        references = { text = " ↱%s", color = "#ff6666" },
                    },
                    use_virtual_text = true,
                })
            end,
        },

        -- apply window-local or global highlights on mode changes or on window entering/leaving.
        -- https://github.com/rasulomaroff/reactive.nvim
        {
            'rasulomaroff/reactive.nvim',
            event = "InsertEnter",
            config = function()
                require('reactive').setup {
                    builtin = {
                      cursorline = true,
                      cursor = true,
                      modemsg = true
                    }
                }
            end,
        },

        -- A pretty diagnostics, references, telescope results, quickfix and location list
        -- https://github.com/folke/trouble.nvim
        {
            'folke/trouble.nvim',
            event = "VeryLazy",
            version = '3.4.*',
            opts = {},
            cmd = "Trouble",
            keys = {},
            dependencies = { "nvim-tree/nvim-web-devicons" },
        }
    },

    -- Lanugages
    {
        -- Neovim's syntax parser and highlighter
        -- https://github.com/nvim-treesitter/nvim-treesitter
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
        -- https://github.com/junegunn/vim-easy-align
        {
            'junegunn/vim-easy-align',
            version = '2.10.*',
            event = "InsertEnter",
        },

        -- Auto close pairs
        -- https://github.com/cohama/lexima.vim
        {
            'cohama/lexima.vim',
            version = '2.*',
            event = {'InsertEnter','CmdlineEnter'},
            -- config = function()
            --     require('pairs'):setup()
            -- end,
        },

        -- basic vim/terraform integration
        -- https://github.com/hashivim/vim-terraform
        {
            'hashivim/vim-terraform',
            dependencies = { 'godlygeek/tabular' },
            config = function()
                -- https://github.com/hashivim/vim-terraform/blob/master/doc/terraform.txt
                vim.g.terraform_align = 1
                vim.g.terraform_fmt_on_save = 1
            end,
        },

        {
            "OXY2DEV/markview.nvim",
            lazy = false,
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                "nvim-tree/nvim-web-devicons"
            }
        }
    },

    -- Git
    {
        -- Super fast git decorations
        {
            'lewis6991/gitsigns.nvim',
            version = '0.8.*',
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                require('gitsigns').setup()
            end,
            event = "BufRead",
        },

        -- Single tabpage interface for easily cycling through diffs
        -- https://github.com/sindrets/diffview.nvim
        {
            'sindrets/diffview.nvim',
            config = function()
                vim.opt.fillchars:append { diff = "╱" }
            end
        },

        -- Magit for NeoVim
        -- https://github.com/NeogitOrg/neogit
        {
            'NeogitOrg/neogit',
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim",
                "sindrets/diffview.nvim", -- Diff integration
            },
            config = function()
                require('plugins.git')
            end,
        }
    },

    -- Telescope & File exploration/browser
    {
        -- highly extendable fuzzy finder over lists
        -- https://github.com/nvim-telescope/telescope.nvim
        {
            'nvim-telescope/telescope.nvim',
            version = '0.1.*',
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
    },

    -- Search and replace
    {
        {
            'MagicDuck/grug-far.nvim',
            commit = 'da8b0d56d4d74982bd852b2baffec222b08adc75',
            config = function()
                require('grug-far').setup({});
              end
        },
    },

    -- Completion & LSP
    {
        -- A completion plugin for neovim coded in Lua.
        -- https://github.com/hrsh7th/nvim-cmp
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'neovim/nvim-lspconfig',
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'lukas-reineke/cmp-rg',
            },
            config = function()
                require('plugins.completion')
            end,
        },

        -- A collection of common configurations for Neovim's built-in language server client.
        -- https://github.com/neovim/nvim-lspconfig
        {
            'neovim/nvim-lspconfig',
            version = '0.1.*',
            dependencies = {
                -- A tree like view for symbols in Neovim using LSP.
                'simrat39/symbols-outline.nvim'
            },
            config = function()
                require('plugins.lsp')
            end,
        },

        -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
        -- https://github.com/williamboman/mason.nvim
        {
            'williamboman/mason.nvim',
            version = '1.10.*',
            config = function()
                require("mason").setup()
            end,
        },

        -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
        -- https://github.com/williamboman/mason-lspconfig.nvim
        {
            'williamboman/mason-lspconfig.nvim',
            version = '1.*',
            dependencies = {
                'neovim/nvim-lspconfig',
                'williamboman/mason.nvim',
            },
            config = function()
                require("mason-lspconfig").setup {
                    ensure_installed = {
                        "ruff",
                        "zls",
                    },
                }
            end
        }
    },

    -- File Manager for Neovim
    {
        -- Neovim file explorer: edit your filesystem like a buffer
        -- https://github.com/stevearc/oil.nvim
        {
            'stevearc/oil.nvim',
            version = '2.*',
            config = function() require('oil').setup() end,
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
    },

})
