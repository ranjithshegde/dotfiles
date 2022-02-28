-- ------------------------------------------------------------------------
-- --                              Global config variables               --
-- ------------------------------------------------------------------------
Api = vim.api
G = vim.g
Var = Api.nvim_set_var
Exec = Api.nvim_command
Op = Api.nvim_get_option
Fn = Api.nvim_call_function
G.netrw_browsex_viewer = "xdg-open"
AuGroup = vim.api.nvim_create_augroup
AuCmd = vim.api.nvim_create_autocmd

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

-- **************Neovim basics -------------------------------------------------------------
require "impatient"
require "plugins"
require "packer_compiled"
require("settings").settings()
require("mappings").general()

------------------------------------------------------------------------
--                              AutoCommands                          --
------------------------------------------------------------------------

-- ************** FileTypes  -----------------------------------------------

AuGroup { name = "FormatOptions" }
AuCmd {
    group = "FormatOptions",
    event = "FileType",
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
}
AuGroup { name = "CommonFtRules" }
AuCmd {
    group = "CommonFtRules",
    event = "FileType",
    pattern = "org",
    callback = function()
        vim.opt_local.iskeyword:append ":,#,+"
    end,
}
AuCmd {
    group = "CommonFtRules",
    event = "FileType",
    pattern = "vim",
    command = "nn <silent><buffer>,K <cmd>exe 'h '.expand('<cword>')<CR>",
}

AuGroup { name = "MakeDispatch" }
AuCmd {
    group = "MakeDispatch",
    event = "FileType",
    pattern = "java,lua,python,javascript",
    callback = function()
        vim.keymap.set("n", "<F5>", function()
            vim.cmd "w | redraw"
            vim.cmd "Dispatch"
        end, { buffer = true, desc = "Call native compile Dispatch command" })
        vim.keymap.set("n", "<F10>", function()
            require("utils").toggleTerm(vim.g.repl, "repl", 0)
        end, { buffer = true, desc = "Toggle REPL" })
        vim.keymap.set(
            "t",
            "<F10>",
            "<esc><cmd>lua require('utils').toggleTerm(vim.g.repl, 'repl', 0)<CR>",
            { desc = "Toggle REPL" }
        )
    end,
}

AuGroup { name = "PluginLoad" }
AuCmd { group = "PluginLoad", event = "BufWritePost", pattern = "plugins.lua", command = "PackerCompile" }

-- ************************ Terminal management -------------------------------------------------

AuGroup { name = "TermInsertModes" }
AuCmd { group = "TermInsertModes", event = "BufWinEnter, WinEnter", pattern = "term://*", command = "startinsert" }
AuCmd { group = "TermInsertModes", event = "TermEnter", pattern = "*", command = "startinsert" }
AuCmd { group = "TermInsertModes", event = "TermClose", pattern = "*", command = "call nvim_input('<CR>')" }
