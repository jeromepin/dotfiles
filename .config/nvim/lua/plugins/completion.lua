local cmp = require('cmp')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    -- snippet = {
    --     expand = function(args)
    --         vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    --         -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    --         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    --     end
    -- },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        -- Mapping should be :
        --   - complete with tab the selected item or the first item
        --   - same for CR
        --   - close the popup and move left (or right) with left (and right) arrows
        --   - insert space with space

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({
                        behavior = cmp.SelectBehavior.Select
                    })
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, {"i", "s"}),

        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({
                        behavior = cmp.SelectBehavior.Select
                    })
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, {"i", "s"}),

        ["<Left>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
            end
            fallback()
        end, {"i", "s"}),

        ["<Right>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
            end
            fallback()
        end, {"i", "s"}),
    }),
    sources = cmp.config.sources({{
        name = 'nvim_lsp'
    }}, {{
        name = 'buffer'
    }}, {{
        name = 'orgmode'
    }})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({{
        name = 'cmp_git'
    }}, {{
        name = 'buffer'
    }})
})

cmp.setup.filetype('org', {
    enabled = false
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{
        name = 'buffer'
    }}
})
