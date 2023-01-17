local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

M.TerragruntGrepInModule = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Find Directory",
        finder = finders.new_oneshot_job({ "fd", "--exact-depth=1", "--type=d", "--base-directory=modules/terragrunt",
            "--strip-cwd-prefix" }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                print(vim.inspect(selection[1]))
                if selection ~= nil then
                    require('telescope.builtin').live_grep({
                        cwd = "modules/terragrunt/" .. selection[1]
                    })
                end
            end)
            return true
        end
    }):find()
end

return M
