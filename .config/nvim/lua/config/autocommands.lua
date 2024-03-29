-- " When editing a Git commit, automatically go to the end of the line when
-- " opening vim
-- augroup git_commit
--     autocmd!

--     autocmd BufReadPost *
--         \  if &filetype == 'gitcommit'
--         \|     execute 'normal $'
--         \| endif
-- augroup end

vim.cmd([[
    augroup filetype-specific
    
    " Indent with two spaces in terraform files instead of 4
    autocmd FileType hcl,terraform setlocal tabstop=2 softtabstop=2 shiftwidth=2
    
    " disable folding in orgmode
    autocmd FileType org setlocal nofoldenable
    
    autocmd FileType hcl :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")

    augroup END 
]])

vim.cmd([[
    augroup cosmetic

    autocmd VimLeave * set guicursor=a:ver100-iCursor-blinkwait150-blinkon150-blinkoff150

    augroup END 
]])
