--------------------------------------------------------------------------
----                              Global config variables               --
--------------------------------------------------------------------------
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

Colors = {
    bg = "#32302f",
    bg2 = "#008080",
    bg3 = "#d79921",
    white = "#fbf1c7",
    yellow = "#d79921",
    cyan = "#008080",
    grey = "#928374",
    green = "#98971a",
    purple = "#b16286",
    orange = "#d65d0e",
    blue = "#458588",
    red = "#cc241d",
}

-- **************Neovim basics -----------------------------------------
pcall(require, "impatient")
require "plugins"
pcall(require, "packer_compiled")
require("settings").options()
require("settings.treesitter").init()
require("mappings").general()
require("utils").autocmd()
