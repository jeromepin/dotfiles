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
                -- print(vim.inspect(selection[1]))
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

M.TerraformOpenResourceDocumentation = function(opts)
    -- Open the documentation website at the direct page by looking for pattern
    opts = opts or {}
    local current_line = tostring(vim.api.nvim_get_current_line())

    local terraform_resource_pattern = '(resource) "([_a-z0-9]+)" "([-_a-z]+)"'
    local terraform_kind, object_kind, object_name = string.match(current_line, terraform_resource_pattern)

    if terraform_kind == "resource" then
        terraform_kind = "resources"
    elseif terraform_kind == "data_source" then
        terraform_kind = "data-sources"
    end

    local provider, rest = string.match(object_kind, '([a-z]+)_(.*)')

    local url = "https://registry.terraform.io/providers/hashicorp/" ..
        provider .. "/latest/docs/" .. terraform_kind .. "/" .. rest

    vim.cmd('exec "!open \'' .. url .. '\'"')
end

return M
