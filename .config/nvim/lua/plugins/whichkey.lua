local wk = require("which-key")

-- nnoremap
wk.register({
    ["<leader>"] = {
        ["<leader>"] = {"<CMD>vsplit ~/org/refile.org<CR>", "Orgmode"},
        c = {
            name = "Orgmode",
            t = {"Cycle TODO Keywords"}
        },
        o = {
            name = "Orgmode",
            a = {"Open Agenda Prompt"},
            c = {"Open Capture Prompt"},
            f = {"<CMD>Telescope live_grep cwd=~/org<CR>", "Search In All Org Files"},
            r = {"Refile To"}
        }
    },

    [";"] = {
        b = {"<CMD>Telescope buffers<CR>", "List Buffers"},
        c = {"<CMD>Telescope commands<CR>", "List Vim Commands"},
        p = {"<CMD>lua command_palette()<CR>", "Command Palette"},

        f = {
            name = "Find files & strings",
            b = {"<CMD>Telescope file_browser<CR>", "Browse Directories"},
            c = {"<CMD>Telescope file_browser cwd=%:p:h<CR>", "Browse Current Directory"},
            d = {"<CMD>Telescope grep_string<CR>", "Find Word Under Cursor In Cwd"},
            f = {"<CMD>Telescope current_buffer_fuzzy_find<CR>", "Search In Current File"},
            g = {"<CMD>Telescope git_files<CR>", "Git Files"},
            i = {"<CMD>Findr<CR>", "Incremental Browser"},
            l = {"<CMD>Telescope live_grep cwd=%:p:h<CR>", "Live Grep in Cwd"},
            m = {"<CMD>Telescope oldfiles<CR>", "Recently Used Files"}
        },

        g = {
            name = "Git",
            l = {"<CMD>Telescope git_commits<CR>", "Log"},
            s = {"<CMD>Telescope git_status<CR>", "Status"}
        },

        t = {
            name = "Terragrunt",
            b = {"<CMD>Telescope file_browser cwd=modules/terragrunt<CR>", "Browse Modules"}
        },

        ["/"] = {"<CMD>CommentToggle<CR>", "Comment"}
    },

    ["b"] = {
        name = "Buffers",
        d = {"<CMD>bp|bd #<CR>", "Close Buffer"},
        p = {"<CMD>bprev<CR>", "Go To Previous Buffer"},
        n = {"<CMD>bnext<CR>", "Go To Next Buffer"}
    },

    ["j"] = {"<C-W>h", "Focus Window On The Left"},
    ["k"] = {"<C-W>l", "Focus Window On The Right"},

    ["l"] = {
        name = "LSP",
        d = {"<CMD>lua require('lspsaga.provider').lsp_finder()<CR>", "Go To Definition"},
        k = {"<CMD>lua require('lspsaga.hover').render_hover_doc()<CR>", "Hover Doc"},
        r = {"<CMD>lua require('lspsaga.provider').lsp_finder()<CR>", "Go To References"},
        t = {"<CMD>Telescope lsp_workspace_symbols symbols='class'<CR>", "List Symbols"}
    },

    ["t"] = {"FloatermToggle<CR>", "Toggle Flotaing Terminal"}

}, {
    mode = "n",
    silent = true,
    noremap = true,
    nowait = false
})

-- nmap
wk.register({
    ["<C-W>"] = {
        ["w"] = {"<CMD>lua require('nvim-window').pick()<CR>", "Pick Window"}
    },

    ["a"] = {
        name = "Move line",
        ["-"] = {"<CMD>m .-2<CR>", "Move Line Up"},
        ["="] = {"<CMD>m .+1<CR>", "Move Line Down"}
    }

}, {
    mode = "n",
    silent = true,
    noremap = false,
    nowait = false
})

-- vnoremap
wk.register({
    [";"] = {
        p = {"<CMD>lua command_palette()<CR>", "Command Palette"},
        ["/"] = {":'<,'>CommentToggle<CR>", "Comment"}
    }
}, {
    mode = "v"
})

wk.setup()
