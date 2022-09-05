vim.g.ccls_levels = 5
vim.bo.commentstring = '//%s'

require('r.utils.compiler').set_type()
require('r.mappings.clang').clang()
