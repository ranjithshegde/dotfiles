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

------------------------------------------------------------------------
--                              AutoCommands                          --
------------------------------------------------------------------------

-- ************** FileTypes  -------------------------------------------

AuGroup("FormatOptions", {})
AuCmd("FileType", {
    group = "FormatOptions",
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            - "a" -- Dont format pasted code
            - "t" -- Delegate to linter prgs/LSP
            - "o" -- O and o don't continue comments
            - "r" -- Return does not continue comments
            + "c" -- comments respect textwidth
            + "q" -- Allow formatting comments w/ gq
            + "n" -- Recognize numbered lists
            + "j" -- Auto-remove comments if possible.
            + "2" -- Indent according to 2nd line
    end,
})

AuGroup("CommonFtRules", {})
AuCmd("FileType", {
    group = "CommonFtRules",
    pattern = "org",
    callback = function()
        vim.opt_local.iskeyword:append ":,#,+"
    end,
})
AuCmd("FileType", {
    group = "CommonFtRules",
    pattern = "vim",
    command = "nn <silent><buffer>,K <cmd>exe 'h '.expand('<cword>')<CR>",
})

AuGroup("MakeDispatch", {})
AuCmd("FileType", {
    group = "MakeDispatch",
    pattern = "java,lua,python,javascript",
    callback = function()
        vim.keymap.set("n", "<F5>", function()
            vim.cmd "w | redraw"
            vim.cmd "Dispatch"
        end, { buffer = true, desc = "Call native compile Dispatch command" })

        vim.keymap.set("n", "<F10>", function()
            require("utils").toggleTerm(vim.g.repl, "repl", 0)
        end, { buffer = true, desc = "Toggle REPL" })

        vim.keymap.set("t", "<F10>", function()
            vim.cmd "stopinsert"
            require("utils").toggleTerm(vim.g.repl, "repl", 0)
        end, { desc = "Toggle REPL" })
    end,
})

-- Compile packer after writing plugins.lua
AuGroup("PluginLoad", {})
AuCmd("BufWritePost", { group = "PluginLoad", pattern = "plugins.lua", command = "source <afile> | PackerCompile" })

-- ************************ Terminal management -------------------------

AuGroup("TermInsertModes", {})
AuCmd("BufWinEnter, WinEnter", { group = "TermInsertModes", pattern = "term://*", command = "startinsert" })
AuCmd("TermEnter", { group = "TermInsertModes", pattern = "*", command = "startinsert" })
AuCmd("TermClose", { group = "TermInsertModes", pattern = "*", command = "call nvim_input('<CR>')" })
