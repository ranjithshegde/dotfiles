vim.g.ccls_levels = 5
vim.bo.commentstring = "//%s"

require("utils.compiler").set_type()
require("mappings.clang").clang()
