require('nvim-treesitter.configs').setup {
  ensure_installed = { "bash", "hcl", "go", "json", "python", "yaml", "org" },
  highlight = {
    enable = true,
    use_languagetree = false, -- Use this to enable language injection (this is very unstable)
    -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  indent = {
    enable = true
  }
}
