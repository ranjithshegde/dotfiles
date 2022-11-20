vim.g.ccls_levels = 5
vim.bo.commentstring = '//%s'

if vim.bo.filetype == 'c' then
    require('r.extensions.cpp').set_type()
end
require('r.mappings.clang').clang()
