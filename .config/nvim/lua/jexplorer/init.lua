-- See https://github.com/kyazdani42/nvim-tree.lua/issues/294

local M = {
  path = nil
}

M.show_in_preview_window = function(path)
  vim.api.nvim_command('botright vertical silent! pedit! +setlocal\\ buftype=nofile\\ nobuflisted\\ noswapfile\\ nonumber\\ winwidth=175 ' .. path)
end

M.copy_path_to_clipboard = function()
  M.path = require'nvim-tree.lib'.get_node_at_cursor().absolute_path
  M.show_in_preview_window(M.path)
end

return M

