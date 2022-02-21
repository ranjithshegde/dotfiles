vim.g.ccls_levels = 5
vim.bo.commentstring = "//%s"

require("utils.compiler").set_ctype()
require("mappings").clang()
