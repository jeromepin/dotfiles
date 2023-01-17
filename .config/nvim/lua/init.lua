local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

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
