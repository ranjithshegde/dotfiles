vim.g.ccls_levels = 5
vim.bo.commentstring = '//%s'

require('r.extensions.cpp').set_type()
require('r.mappings.clang').clang()
