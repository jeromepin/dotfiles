-- See https://github.com/nvim-telescope/telescope.nvim#telescope-defaults

local telescope = require('telescope')
local actions = require('telescope.actions')
local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup({
    defaults = {
        initial_mode = "insert",
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
        },
        find_command = {
            "git",
            "ls-files",
        },
        -- path_display = { "smart" },
        mappings = {
            -- ["i"] = {
            --     ["<esc>"] = actions.close,
            -- },
            -- ["n"] = {},
        },
    },
    pickers = {
        file_browser = {
            theme = "ivy",
        },
        find_files = {
            theme = "ivy",
        },
        grep_string = {
            theme = "ivy",
        },
        current_buffer_fuzzy_find = {
            theme = "ivy",
        },
        live_grep = {
            theme = "ivy",
        },
        oldfiles = {
            theme = "ivy",
        },
    },
})

telescope.load_extension('file_browser')
-- require('telescope').load_extension('fzf')
