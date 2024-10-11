vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded'
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded'
})

--------------------------------------------------------
--                Symbols Outline
--------------------------------------------------------
vim.g.symbols_outline = {
    auto_preview = false,
    show_symbol_details = false,
    auto_close = false,
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "lk",
        rename_symbol = "r",
        code_actions = "a"
    }
}

require('lspconfig').ruff.setup({})