require'nvim-treesitter.configs'.setup {
    ensure_installed = { "bash", "go", "json", "python", "yaml" },
    highlight = {
      enable = true,
      use_languagetree = false, -- Use this to enable language injection (this is very unstable)
    },
    indent = {
      enable = true
    }
  }
  