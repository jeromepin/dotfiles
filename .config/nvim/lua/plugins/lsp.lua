local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require('lspconfig')
local lspsaga = require('lspsaga')

vim.g.coq_settings = {
  auto_start = true,

  -- See mappings.lua for custom keybindings
  keymap = {
    -- Disable default keymap
    recommended     = false,

    -- Always select first result
    pre_select      = true

  },
}

local coq_capabilities = require("coq").lsp_ensure_capabilities({})["capabilities"]

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = coq_capabilities,
  }

  if server.name == "terraformls" then
    opts.init_options = {
      ignoreDirectoryNames = { ".terragrunt-cache", "haussmann", "internal", "monolith" },
    }
  end

  server:setup(opts)
end)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
})

lspsaga.setup({
  finder_action_keys = {
    open = "<CR>",
    quit = "<Esc>",
  },
  code_action_keys = {
    quit = "<Esc>",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<Esc>",
    exec = "<CR>",
  }
})

vim.g.symbols_outline = {
  auto_preview = false,
  show_symbol_details = false,
  auto_close = false,
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = {"<Esc>", "q"},
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    toggle_preview = "lk",
    rename_symbol = "r",
    code_actions = "a",
  },
}
