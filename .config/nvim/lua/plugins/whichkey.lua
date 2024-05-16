local wk = require("which-key")

-- nnoremap
wk.register({
    -- Leader is <space>
    ["<leader>"] = {
        ["/"] = { "<CMD>CommentToggle<CR>", "Comment" },

        b = { "<CMD>Telescope buffers<CR>", "List Buffers" },
        c = { "<CMD>Telescope commands<CR>", "List Vim Commands" },

        g = {
            name = "Git",
            a = { "<CMD>Gitsigns stage_hunk<CR>", "Stage current hunk" },
            b = { "<CMD>Gitsigns blame_line<CR>", "Current line blame" },
            d = { "<CMD>Gitsigns preview_hunk_inline<CR>", "Current line diff" },
            h = { "<CMD>DiffviewFileHistory %<CR>", "Current file history" },
            l = { "<CMD>Telescope git_commits<CR>", "Log" },
            s = { "<CMD>Neogit<CR>", "Status (using Magit)" }
        },

        s = { "<CMD>Telescope projections<CR>", "Switch projects" },

        t = {
            name = "Terraform",
            b = { "<CMD>Telescope file_browser cwd=modules/terragrunt<CR>", "Browse Modules" },
            l = { "<CMD>TerragruntGrepModule<CR>", "Live Grep" },
            d = { "<CMD>TerraformOpenDoc<CR>", "Open Terraform Documentation" },
        }
    },
    ["\\"] = {
        ["\\"] = { "<CMD>vsplit ~/org/refile.org<CR>", "Orgmode" },
        c = {
            name = "Orgmode",
            t = { "Cycle TODO Keywords" }
        },
        o = {
            name = "Orgmode",
            a = { "Open Agenda Prompt" },
            c = { "Open Capture Prompt" },
            f = { "<CMD>Telescope live_grep cwd=~/org<CR>", "Search In All Org Files" },
            r = { "Refile To" }
        }
    },
    ["<C-p>"] = { "<CMD>lua require('jcommandpalette').command_palette()<CR>", "Command Palette" },
    ["="] = {
        name = "Filesystem operations",
        ["="] = { "<CMD>Oil<CR>", "Oil" },
        b = { "<CMD>lua require('telescope').extensions.file_browser.file_browser({cwd=vim.api.nvim_eval(\"finddir('.git/..', expand('%:p:h').';')\")})<CR>", "Browse Project" },
        c = { "<CMD>Telescope file_browser cwd=%:p:h<CR>", "Browse Current Directory" },
        d = { "<CMD>Telescope grep_string<CR>", "Find Word Under Cursor In Current File" },
        f = { "<CMD>Telescope current_buffer_fuzzy_find<CR>", "Search In Current File" },
        g = { "<CMD>Telescope git_files<CR>", "Git Files" },
        i = { "<CMD>Findr<CR>", "Incremental Browser" },
        l = { "<CMD>Telescope live_grep cwd=%:p:h<CR>", "Grep In Current Directory" },
        m = { "<CMD>Telescope oldfiles<CR>", "Recently Used Files" },
        s = { "<CMD>Telescope git_status<CR>", "Git Status" },
    },
    ["b"] = {
        name = "Buffers",
        d = { "<CMD>Sayonara<CR>", "Close Buffer" },
        p = { "<CMD>bprev<CR>", "Go To Previous Buffer" },
        n = { "<CMD>bnext<CR>", "Go To Next Buffer" }
    },
    ["j"] = { "<C-W>h", "Focus Window On The Left" },
    ["k"] = { "<C-W>l", "Focus Window On The Right" },
    ["l"] = {
        name = "LSP",
        d = { "<CMD>lua require('lspsaga.provider').lsp_finder()<CR>", "Go To Definition" },
        k = { "<CMD>lua require('lspsaga.hover').render_hover_doc()<CR>", "Hover Doc" },
        r = { "<CMD>lua require('lspsaga.provider').lsp_finder()<CR>", "Go To References" },
        t = { "<CMD>Telescope lsp_workspace_symbols symbols='class'<CR>", "List Symbols" }
    },
}, {
    mode = "n",
    silent = true,
    noremap = true,
    nowait = false
})

-- nmap
wk.register({
    ["<C-W>"] = {
        ["w"] = { "<CMD>lua require('nvim-window').pick()<CR>", "Pick Window" }
    },
    ["a"] = {
        name = "Move line",
        ["-"] = { "<CMD>m .-2<CR>", "Move Line Up" },
        ["="] = { "<CMD>m .+1<CR>", "Move Line Down" }
    }
}, {
    mode = "n",
    silent = true,
    noremap = false,
    nowait = false
})

-- vnoremap
wk.register({
    ["<leader>"] = {
        ["/"] = { "<CMD>'<,'>CommentToggle<CR>", "Comment" }
    },
    ["<C-p>"] = { "<CMD>lua require('jcommandpalette').command_palette()<CR>", "Command Palette" }
}, {
    mode = "v"
})

wk.setup()
