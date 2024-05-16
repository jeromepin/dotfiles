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
    
    " Use '#' to comment in HCL files
    autocmd FileType hcl,terraform :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")

    " Format Terraform files on save
    " autocmd BufWritePost *.hcl,*.tf TerraformFmt <bar> redraw
    
    " Disable folding in orgmode
    autocmd FileType org setlocal nofoldenable
    
    " Disable autowrap for gitcommit
    autocmd FileType gitcommit setlocal textwidth=0

    augroup END 
]])

vim.cmd([[
    augroup cosmetic

    autocmd VimLeave * set guicursor=a:ver100-iCursor-blinkwait150-blinkon150-blinkoff150

    augroup END 
]])

-- Hybrid (relative + absolute) numbering is always on by settings 
vim.cmd([[
    augroup numbertoggle

    " When focusing a buffer, enable the relative line numbering
    " This command is important to reset to default when we focus a buffer again after the other command has been executed (otherwise nornu stays)
    autocmd BufEnter,FocusGained,WinEnter * if &nu && mode() != "i" | set rnu   | endif

    " When losing focus over a buffer, disable the relative line numbering to only have absolute numbers
    autocmd BufLeave,FocusLost,WinLeave   * if &nu                  | set nornu | endif
    
    augroup END 
]])
