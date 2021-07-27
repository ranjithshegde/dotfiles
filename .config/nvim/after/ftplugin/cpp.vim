let g:ccls_levels = 5
setlocal commentstring=//%s
lua require('compiler').set_ctype()
lua require("mappings").clang()

" augroup FormatOptions
    " autocmd!
    " au FileType * set formatoptions+=2jnqc |
                " \ set formatoptions-=rato
                " \ setlocal formatoptions-=ator |
                " \ setlocal formatoptions+=2jnqc
" augroup END
