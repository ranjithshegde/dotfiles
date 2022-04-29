vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

local ok, imp = pcall(require, "impatient")
if ok then
    imp.enable_profile()
end

require "plugins"
pcall(require, "packer_compiled")
require("settings").options()
require("settings.treesitter").init()
require("mappings").init()
require("utils").autocmd()
