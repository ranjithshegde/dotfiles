vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

pcall(require, "impatient")
require "plugins"
pcall(require, "packer_compiled")
require("settings").options()
require("settings.treesitter").init()
require("mappings").init()
require("utils").autocmd()
