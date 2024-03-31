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
require 'config.commands'
require 'config.autocommands'
require 'config.mappings'
require 'config.settings'

local ok, _ = pcall(require, 'config.local')
if not ok then
    -- not loaded
end

-- Set barbar's options
vim.g.bufferline = {
    icons = false
}
