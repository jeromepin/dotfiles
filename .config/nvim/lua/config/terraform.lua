-- function! s:get_current_file_path() abort
--     return expand('%:p')
-- endfunction

-- function! s:find_module_source() abort
--     " Loop over every line in the current file and try to find one matching `source = "${local.git_root}/...`
--     for line in readfile(s:get_current_file_path())
--         let l:matches = filter(matchlist(line, ' \+source \+= \+\"\${local.git_root}\/\(.\+\)\"'), 'v:val !=# ""')
--         if len(l:matches) == 2
--             return l:matches[1]
--         endif
--     endfor
-- endfunction

-- function! s:terragrunt_show_module_variables() abort
--     let l:source_module_absolute_path = system("git rev-parse --show-toplevel | tr -d '\\n'") . '/' . s:find_module_source()
--     execute 'vsplit ' l:source_module_absolute_path . '/variables.tf'
-- endfunction

-- function! s:terragrunt_explore_module() abort
--     let l:source_module_absolute_path = system("git rev-parse --show-toplevel | tr -d '\\n'") . '/' . s:find_module_source()
--     execute 'Telescope file_browser cwd=' . l:source_module_absolute_path
-- endfunction
