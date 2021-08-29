" Mostly from https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/

let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git']
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" a: Access (or export) of class members
" i: Inheritance information
" l: Language of input file containing tag
" m: Implementation information
" n: Line number of tag definition
" S: Signature of routine (e.g. prototype or parameter list)
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

let g:tagbar_ctags_bin = '/opt/local/bin/uctags'
let g:gutentags_ctags_executable = '/opt/local/bin/uctags'
