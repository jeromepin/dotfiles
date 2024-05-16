-- command! -nargs=* TerragruntShowVariables call s:terragrunt_show_module_variables(<f-args>)
-- command! -nargs=* TerragruntExploreModule call s:terragrunt_explore_module(<f-args>)
-- command! -nargs=* TerragruntListModules lua require("telescope").extensions.file_browser.file_browser({path="~/git/github/lumapps/infra/modules/terragrunt"})
-- " command! -nargs=* BrowseGithub !open "https://github.com/lumapps/"
-- vim.cmd([[command Org vsplit ~/org/lumapps.org]])

vim.cmd([[command Broot FloatermNew --width=0.8 --height=0.8 broot]])

vim.cmd([[
function! MultipleEdit(p_list)
    for p in a:p_list
        for c in glob(p, 0, 1)
        execute 'edit ' . c
        endfor
    endfor
endfunction

command! -bar -bang -nargs=+ -complete=file Edit call MultipleEdit([<f-args>])
]])

vim.cmd([[
    command! TerragruntGrepModule lua require('config.terraform').TerragruntGrepInModule(require("telescope.themes").get_dropdown{})
]])

vim.cmd([[
    command! TerraformOpenDoc lua require('config.terraform').TerraformOpenResourceDocumentation()
]])
