local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

M.command_palette = function(opts)
    pickers.new(opts, {
        prompt_title = "Command Palette",
        finder = finders.new_table {
            results = {
                { "Explore Current Working Directory", "lua require('telescope').extensions.file_browser.file_browser({cwd=vim.api.nvim_eval(\"expand('%:p:h')\")})" },
                { "Explore Git Root",                  "lua require('telescope').extensions.file_browser.file_browser({cwd=vim.api.nvim_eval(\"finddir('.git/..', expand('%:p:h').';')\")})" },
                -- { "Explore Terragrunt Module",         "TerragruntExploreModule" },
                { "Find files",                        "Telescope find_files" },
                -- { "Find in Terraform Module",          "TerragruntGrepModule" },
                { "Format current buffer",             "lua vim.lsp.buf.format()" },
                { "Open Terraform Documentation",      "TerraformOpenDoc" },
                { "Preview Markdown",                  "Glow" },
                { "Reload vim configuration",          "so $MYVIMRC" },
                { "Search and Replace",                "GrugFar" },
                -- { "Show Terragrunt Variables",         "TerragruntShowVariables" },
                { "Sort Lines Ascending",              "'<,'>sort" },
                { "Sort Lines Descending",             "'<,'>sort!" },
                { "Toggle Comment",                    "CommentToggle" },
                { "Transform to Lowercase",            "'<,'>u" },
                { "Transform to Uppercase",            "'<,'>U" },
            },
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry[1],
                    ordinal = entry[1],
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(
                function()
                    local selection = action_state.get_selected_entry()
                    if selection ~= nil then
                        actions.close(prompt_bufnr)
                        -- print(vim.inspect(selection.value[2]))
                        vim.cmd(selection.value[2])
                    end
                end
            )

            return true
        end
    }):find()
end

return M
