-- command! -nargs=* TerragruntShowVariables call s:terragrunt_show_module_variables(<f-args>)
-- command! -nargs=* TerragruntExploreModule call s:terragrunt_explore_module(<f-args>)
-- command! -nargs=* TerragruntListModules lua require("telescope").extensions.file_browser.file_browser({path="~/git/github/lumapps/infra/modules/terragrunt"})
-- " command! -nargs=* BrowseGithub !open "https://github.com/lumapps/"
-- vim.cmd([[command Org vsplit ~/org/lumapps.org]])
vim.cmd([[
    command! -nargs=* TerraformFmt execute 'silent !cat % | ~/.asdf/installs/terraform/1.0.1/bin/terraform fmt - | tee % >> /dev/null'
]])

vim.cmd([[command Broot FloatermNew --width=0.8 --height=0.8 broot]])
