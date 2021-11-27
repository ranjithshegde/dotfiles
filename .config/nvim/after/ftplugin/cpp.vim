let g:ccls_levels = 5
setlocal commentstring=//%s
lua require('utils.compiler').set_ctype()
lua require("mappings").clang()
