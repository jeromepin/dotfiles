require 'jtreesitter'
require 'jtelescope'

require'lspconfig'.pyright.setup{}

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

vim.g.nvim_tree_bindings = {
    -- ["<Tab>"]          = tree_cb("preview"),
    ["<Tab>"]          = ":lua require'jexplorer'.copy_path_to_clipboard()<cr>",
    ["<CR>"]           = tree_cb("edit"),
    ["o"]              = tree_cb("edit"),
    -- ["<2-LeftMouse>"]  = tree_cb("edit"),
    -- ["<2-RightMouse>"] = tree_cb("cd"),
    ["<C-]>"]          = tree_cb("cd"),
    ["<C-v>"]          = tree_cb("vsplit"),
    ["<C-x>"]          = tree_cb("split"),
    ["<C-t>"]          = tree_cb("tabnew"),
    ["<BS>"]           = tree_cb("close_node"),
    ["<S-CR>"]         = tree_cb("close_node"),
    ["I"]              = tree_cb("toggle_ignored"),
    ["H"]              = tree_cb("toggle_dotfiles"),
    ["R"]              = tree_cb("refresh"),
    ["a"]              = tree_cb("create"),
    ["d"]              = tree_cb("remove"),
    ["r"]              = tree_cb("rename"),
    ["<C-r>"]          = tree_cb("full_rename"),
    ["x"]              = tree_cb("cut"),
    ["c"]              = tree_cb("copy"),
    ["p"]              = tree_cb("paste"),
    ["[c"]             = tree_cb("prev_git_item"),
    ["]c"]             = tree_cb("next_git_item"),
    ["-"]              = tree_cb("dir_up"),
    ["q"]              = tree_cb("close"),
}