local lualine = require('lualine')
local lspconfig = require('lspconfig')

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

ins_left {
    function()
        return '▊'
    end,
    color = { fg = colors.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
    -- mode component
    function()
        return 'N'
    end,
    color = function()
        -- auto change color according to neovims mode
        local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
}

-- filesize component
ins_left {
    'filesize',
    cond = conditions.buffer_not_empty,
}

-- diagnostics
ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
    },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
    function()
        return '%='
    end,
}

-- git branch
ins_left {
    'branch',
    icon = '',
    color = { fg = colors.red, gui = 'bold' },
}

-- git diff
ins_left {
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '柳 ', removed = ' ' },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
}

ins_left {
    function()
        return '%='
    end,
}

-- Find the file's path from the git's root
local function path_from_git_root()
    function string:replace(pattern, replace_string, ...)
        -- Analog of string.gsub() but without magic characters (plain replacement)
        -- From https://stackoverflow.com/questions/45645316/translate-python-to-lua-replace-a-string-character-in-a-list/45648295#45648295
        return (self:gsub(
                pattern:gsub("%p", "%%%0"),
                replace_string:gsub("%%", "%%%%"),
                ...
            ))
    end

    function exists(file)
        local f = io.open(file)
        return f and io.close(f)
    end

    function find_git_root(dir)
        while #dir>0 and not exists(dir .. "/.git") do
            dir=dir:gsub("/+[^/]*$","")
        end
        return #dir>0 and dir
    end

    local full_path_to_file = vim.fn.expand('%:p')
    local git_root_path = find_git_root(full_path_to_file)
    local path, _ = string.replace(full_path_to_file, git_root_path .. "/", "")
    return path
end

-- filename/path
ins_left {
    path_from_git_root,
    path = 1,
    cond = conditions.buffer_not_empty,
    color = { fg = colors.cyan, gui = 'bold' },
}

ins_left {
    function()
        return '%='
    end,
}

-- Lsp server name .
ins_left {
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' LSP:',
    color = { fg = '#ffffff' },
}

-- current line and column
ins_right {
    'location',
    fmt = function(str)
        function split(source, sep)
            local result, i = {}, 1
            while true do
                local a, b = source:find(sep)
                if not a then break end
                local candidat = source:sub(1, a - 1)
                if candidat ~= "" then 
                    result[i] = candidat
                end i=i+1
                source = source:sub(b + 1)
            end
            if source ~= "" then 
                result[i] = source
            end
            return result
        end

        local result = split(str, ":")
        return "Ln " .. result[1] .. ", Col " .. result[2]
    end,
}

-- Percentage of file scrolled
ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

-- File encoding
ins_right {
    'o:encoding', -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = colors.green },
}

-- File format
ins_right {
    'fileformat',
    fmt = string.upper,
    icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
    color = { fg = colors.green },
}

ins_right {
    function()
        return '▊'
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
