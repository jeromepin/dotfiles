-- Toggle comments
-- require("mini.comment").setup({
--     -- Module mappings. Use `''` (empty string) to disable one.
--     mappings = {
--         -- Toggle comment (like `gcip` - comment inner paragraph) for both
--         -- Normal and Visual modes
--         comment = '',
    
--         -- Toggle comment on current line
--         comment_line = ';/',
    
--         -- Define 'comment' textobject (like `dgc` - delete whole comment block)
--         textobject = '',
--     },
-- })

-- Automatically highlighting other uses of the current word under the cursor
require("mini.cursorword").setup({
    -- Delay (in ms) between when cursor moved and when highlighting appeared
    delay = 100,
})

require("mini.pairs").setup({
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = false, terminal = false },
  
    -- Global mappings. Each right hand side should be a pair information, a
    -- table with at least these fields (see more in |MiniPairs.map|):
    -- - <action> - one of 'open', 'close', 'closeopen'.
    -- - <pair> - two character string for pair to be used.
    -- By default pair is not inserted after `\`, quotes are not recognized by
    -- `<CR>`, `'` does not insert pair after a letter.
    -- Only parts of tables can be tweaked (others will use these defaults).
    mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
    
        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
    
        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
})
