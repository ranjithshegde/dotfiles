vim.g.ccls_levels = 5
vim.bo.commentstring = '//%s'

if vim.bo.filetype == 'cpp' then
    require('r.extensions.cpp').set_cpptype()
end
require('r.mappings.clang').clang()
