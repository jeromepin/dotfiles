local wk = require("which-key")

wk.add({
    mode =  {"n"},
    { "<C-p>", "<CMD>lua require('jcommandpalette').command_palette()<CR>", desc = "Command Palette", nowait = false, remap = false },
    { "<leader>/", "<CMD>normal gcc<CR>", desc = "Comment Current Line", nowait = false, remap = false },
    { "<leader>b", "<CMD>Telescope buffers<CR>", desc = "List Buffers", nowait = false, remap = false },
    { "<leader>c", "<CMD>Telescope commands<CR>", desc = "List Vim Commands", nowait = false, remap = false },
    { "<leader>g", group = "Git", nowait = false, remap = false },
    { "<leader>ga", "<CMD>Gitsigns stage_hunk<CR>", desc = "Stage current hunk", nowait = false, remap = false },
    { "<leader>gb", "<CMD>Gitsigns blame_line<CR>", desc = "Current line blame", nowait = false, remap = false },
    { "<leader>gd", "<CMD>Gitsigns preview_hunk_inline<CR>", desc = "Current line diff", nowait = false, remap = false },
    { "<leader>gh", "<CMD>DiffviewFileHistory %<CR>", desc = "Current file history", nowait = false, remap = false },
    { "<leader>gl", "<CMD>Telescope git_commits<CR>", desc = "Log", nowait = false, remap = false },
    { "<leader>gs", "<CMD>Neogit<CR>", desc = "Status (using Magit)", nowait = false, remap = false },
    { "<leader>t", group = "Terraform", nowait = false, remap = false },
    { "<leader>tb", "<CMD>Telescope file_browser cwd=modules/terragrunt<CR>", desc = "Browse Modules", nowait = false, remap = false },
    { "<leader>td", "<CMD>TerraformOpenDoc<CR>", desc = "Open Terraform Documentation", nowait = false, remap = false },
    { "<leader>tl", "<CMD>TerragruntGrepModule<CR>", desc = "Live Grep", nowait = false, remap = false },
    { "<leader>z", "za", desc = "Toggle fold under cursor", nowait = false, remap = false },
    { "=", group = "Filesystem operations", nowait = false, remap = false },
    { "==", "<CMD>Oil<CR>", desc = "Oil", nowait = false, remap = false },
    { "=b", "<CMD>lua require('telescope').extensions.file_browser.file_browser({cwd=vim.api.nvim_eval(\"finddir('.git/..', expand('%:p:h').';')\")})<CR>", desc = "Browse Project", nowait = false, remap = false },
    { "=c", "<CMD>Telescope file_browser cwd=%:p:h<CR>", desc = "Browse Current Directory", nowait = false, remap = false },
    { "=d", "<CMD>Telescope grep_string<CR>", desc = "Find Word Under Cursor In Current File", nowait = false, remap = false },
    { "=f", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Search In Current File", nowait = false, remap = false },
    { "=g", "<CMD>Telescope git_files<CR>", desc = "Git Files", nowait = false, remap = false },
    { "=l", "<CMD>Telescope live_grep cwd=%:p:h<CR>", desc = "Grep In Current Directory", nowait = false, remap = false },
    { "=m", "<CMD>Telescope oldfiles<CR>", desc = "Recently Used Files", nowait = false, remap = false },
    { "=s", "<CMD>Telescope git_status<CR>", desc = "Git Status", nowait = false, remap = false },
    { "b", group = "Buffers", nowait = false, remap = false },
    { "bd", "<CMD>Sayonara<CR>", desc = "Close Buffer", nowait = false, remap = false },
    { "bn", "<CMD>bnext<CR>", desc = "Go To Next Buffer", nowait = false, remap = false },
    { "bp", "<CMD>bprev<CR>", desc = "Go To Previous Buffer", nowait = false, remap = false },
    { "j", "<C-W>h", desc = "Focus Window On The Left", nowait = false, remap = false },
    { "k", "<C-W>l", desc = "Focus Window On The Right", nowait = false, remap = false },
    { "l", group = "LSP", nowait = false, remap = false },
    { "ld", "<CMD>lua require('lspsaga.provider').lsp_finder()<CR>", desc = "Go To Definition", nowait = false, remap = false },
    { "lk", "<CMD>lua require('lspsaga.hover').render_hover_doc()<CR>", desc = "Hover Doc", nowait = false, remap = false },
    { "lr", "<CMD>lua require('lspsaga.provider').lsp_finder()<CR>", desc = "Go To References", nowait = false, remap = false },
    { "lt", "<CMD>Telescope lsp_workspace_symbols symbols='class'<CR>", desc = "List Symbols", nowait = false, remap = false },
})

wk.add({
    mode = {"n"},
    { "<C-W>w", "<CMD>lua require('nvim-window').pick()<CR>", desc = "Pick Window", nowait = false, remap = true },
    { "a", group = "Move line", nowait = false, remap = true },
    { "a-", "<CMD>m .-2<CR>", desc = "Move Line Up", nowait = false, remap = true },
    { "a=", "<CMD>m .+1<CR>", desc = "Move Line Down", nowait = false, remap = true },
})

wk.add({
    mode = {"v"},
    { "<C-p>", "<CMD>lua require('jcommandpalette').command_palette()<CR>", desc = "Command Palette", mode = "v" },
    { "<leader>/", "<CMD>normal gcc<CR>", desc = "Comment Selection", mode = "v" },
})

wk.setup()
