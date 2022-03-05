--------------------------------------------------------------------------
----                              Global config variables               --
--------------------------------------------------------------------------
G = vim.g
Api = vim.api
Var = Api.nvim_set_var
Exec = Api.nvim_command
Op = Api.nvim_get_option
Fn = Api.nvim_call_function
AuCmd = Api.nvim_create_autocmd
AuGroup = Api.nvim_create_augroup

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
require "impatient"
require "plugins"
require "packer_compiled"
require("settings").settings()
require("mappings").general()
require("utils").autocmd()
