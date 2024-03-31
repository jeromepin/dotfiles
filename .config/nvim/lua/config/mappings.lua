-- https://github.com/nanotee/nvim-lua-guide#defining-mappings

vim.api.nvim_command([[
if expand('%:t') == "git-rebase-todo"
    nnoremap p 0ciwpick<ESC>0
    nnoremap r 0ciwreword<ESC>0
    nnoremap e 0ciwedit<ESC>0
    nnoremap s 0ciwsquash<ESC>0
    nnoremap f 0ciwfixup<ESC>0
    nnoremap x 0ciwexec<ESC>0
    nnoremap d 0ciwdrop<ESC>0
endif
]])

vim.api.nvim_command([[
if expand('%:t') == "COMMIT_EDITMSG"
    nnoremap c 0ciwchore<ESC>0
    nnoremap f 0ciwfeat<ESC>0
    nnoremap x 0ciwfix<ESC>0
endif
]])

-- Use Esc to go back to normal mode when using integrated Terminal
-- tnoremap <Esc> <C-\><C-n>

-- nnoremap gi :Telescope lsp_implementations<CR>
-- nnoremap <C-k> :lua require('lspsaga.signaturehelp').signature_help()<CR>
-- nnoremap <space>D :Telescope lsp_type_definitions<CR>
-- nnoremap <space>rn :lua vim.lsp.buf.rename()<CR>
-- nnoremap <space>ca :Telescope lsp_code_actions<CR>
-- nnoremap <space>f :lua vim.lsp.buf.formatting()<CR>
-- nnoremap <space>rf :lua vim.lsp.buf.range_formatting()<CR>


------------------------------------------------------
--                 COQ Completion
------------------------------------------------------
-- Complete with Tab, S-Tab and CR
-- from https://github.com/ms-jpq/coq_nvim/blob/coq/docs/KEYBIND.md#custom-keybindings
vim.cmd([[
    ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
    ino <silent><expr> <Tab>   pumvisible() ? "<C-n><C-y>" : "<Tab>"
    ino <silent><expr> <S-Tab> pumvisible() ? "<C-n><C-y>" : "<S-Tab>"
    ino <silent><expr> <CR>    pumvisible() ? "<C-n><C-y>" : "<CR>"
]])

-- Ensure d and D copy to the blackhole register (i.e don't copy) to prevent altering the current buffer content
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'D', '"_D')