require 'plugins'

-- https://github.com/nanotee/nvim-lua-guide#setting-up-linterslanguage-servers
require 'config.abbreviations'
require 'config.autocommands'
require 'config.commands'
require 'config.mappings'
require 'config.settings'
-- require 'config.terraform'

require 'jcommandpalette'

-- Set barbar's options
vim.g.bufferline = {
    icons = false,
}
