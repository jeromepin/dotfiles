require('el').setup({
    generator = function(_window, buffer)
        local segments = {}
        local builtin = require('el.builtin')
        local extensions = require('el.extensions')
        local helper = require("el.helper")
        local sections = require("el.sections")
        local subscribe = require('el.subscribe')

        -- See https://github.com/tjdevries/express_line.nvim/blob/c8bbbb6a9a50b26b8930484cf07a68d8d20c7001/lua/el/sections.lua#L12
        table.insert(segments, sections.left_subsection({
            divider = "",
            items = {
                extensions.mode,
            }
        }))

        table.insert(segments, sections.left_subsection({
            divider = "",
            items = {
                subscribe.buf_autocmd(
                    "el_file_icon",
                    "BufRead",
                    function(_, buffer)
                        return extensions.file_icon(_, buffer)
                    end
                ),
                " ",
                builtin.file,
                string.format(":[%s:%s]", builtin.line, builtin.column),
            }
        }))

        table.insert(segments, sections.split)

        table.insert(segments, sections.left_subsection({
            divider = "",
            items = {
                " ",
                subscribe.buf_autocmd(
                    "el_git_branch",
                    "BufEnter",
                    function(window, buffer)
                        local branch = extensions.git_branch(window, buffer)
                        if branch then
                            return branch
                        end
                    end
                ),
                string.format("%s %%", builtin.percentage_through_file)
            }
        }))

        return segments
    end
})
