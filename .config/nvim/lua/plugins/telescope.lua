-- See https://github.com/nvim-telescope/telescope.nvim#telescope-defaults

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
    defaults = {
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
            i = {
                -- ["<esc>"] = actions.close,
            },
        },
    },
})

-- require('telescope').load_extension('fzf')
