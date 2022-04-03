local utils = {}
local exec = vim.api.nvim_command
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

------------------------------------------------------------------------
--                              Vim options                           --
------------------------------------------------------------------------

function utils.UnloadAllModules()
    -- Lua patterns for the modules to unload
    local unload_modules = {
        "mappings",
        "compiler",
        "plugins",
        "settings",
        "statusline",
        "utils",
        "lsp",
        "debugger",
        "org",
    }
    local ok, _ = pcall(require, "impatient")
    if ok then
        vim.cmd "LuaCacheClear"
    end
    RELOAD(unload_modules)
end

-- Restart Vim without having to close and run again
function utils.Restart()
    -- vim.cmd "LspStop"
    utils.UnloadAllModules()
    vim.cmd "source $MYVIMRC"
    vim.api.nvim_exec_autocmds("VimEnter", {})
end

------------------------------------------------------------------------
--                              AutoCommands                          --
------------------------------------------------------------------------

utils.autocmd = function()
    -- ************** FileTypes  ---------------------------------------

    augroup("FormatOptions", {})
    aucmd("FileType", {
        group = "FormatOptions",
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

    augroup("LspSettings", {})
    aucmd("FileType", {
        group = "LspSettings",
        pattern = "vim",
        command = "nn <silent><buffer>,K <cmd>exe 'h '.expand('<cword>')<CR>",
    })
    aucmd("FileType", {
        group = "LspSettings",
        callback = function()
            require("lsp").settings()
            require("lsp").servers()
            require("lsp").lintFormat()
        end,
        once = true,
    })
    aucmd("FileType", {
        group = "LspSettings",
        pattern = "opencl",
        callback = require("mappings").clang,
    })

    -- ************** Compilers and REPL  ------------------------------
    augroup("MakeDispatch", {})
    aucmd("FileType", {
        group = "MakeDispatch",
        pattern = "java,lua,python,javascript",
        callback = function()
            vim.keymap.set("n", "<F5>", function()
                vim.cmd "w | redraw"
                vim.cmd "Dispatch"
            end, { buffer = true, desc = "Call native compile Dispatch command" })

            vim.keymap.set({ "n", "t" }, "<F10>", function()
                vim.cmd "stopinsert"
                require("utils").toggleTerm(vim.g.repl, "repl", 0)
            end, { desc = "Toggle REPL" })
        end,
    })
    aucmd("BufWritePost", {
        group = "MakeDispatch",
        pattern = "*.glsl,*.vert,*.frag,*.geom,*.vs,*.fs,*.gs",
        command = "Dispatch glslangValidator %",
    })

    -- Compile packer after writing plugins.lua
    augroup("PluginLoad", {})
    aucmd("BufWritePost", { group = "PluginLoad", pattern = "plugins.lua", command = "source <afile> | PackerCompile" })

    -- ************************ Terminal management --------------------

    augroup("TermInsertModes", {})
    aucmd("BufWinEnter, WinEnter", { group = "TermInsertModes", pattern = "term://*", command = "startinsert" })
    aucmd("TermEnter", { group = "TermInsertModes", command = "startinsert" })
    aucmd("TermClose", { group = "TermInsertModes", command = "call nvim_input('<CR>')" })
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

-- set silent exec option
function utils.silent_shell(cmd)
    exec("silent exe '!" .. cmd .. " &'")
end

-- Toggleable terminal
function utils.toggleTerm(cmd, name, spl)
    local win = vim.fn.bufwinnr(name)
    local buf = vim.fn.bufexists(name)
    if win > 0 then
        exec(win .. " wincmd c")
    elseif buf > 0 then
        if spl > 0 then
            exec "belowright vnew"
        else
            exec "belowright new"
        end
        exec("buffer " .. name)
        exec "startinsert"
    else
        if spl > 0 then
            exec "belowright vnew"
        else
            exec "belowright new"
        end
        vim.fn.termopen(cmd)
        exec "startinsert"
        exec("f " .. name)
    end
end

------------------------------------------------------------------------
--                          Plugin functions                          --
------------------------------------------------------------------------

-- set browser
local browser = "qutebrowser"
function utils.open_in_browser(url)
    utils.silent_shell(browser .. " " .. url)
end

function utils.back()
    vim.cmd "bprevious"
    vim.cmd "lcd %:p:h"
end

utils.concat_fileLines = function(file)
    local dictionary = {}
    for line in io.lines(file) do
        table.insert(dictionary, line)
    end
    return dictionary
end

utils.feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Access agenda from outside orgfile
function utils.agenda()
    exec "PackerLoad orgmode"
    require("orgmode").action "agenda.prompt"
end

function utils.thesaurus(cmd)
    local url = "https://www.thesaurus.com/browse/" .. cmd
    exec('!qutebrowser "' .. url .. '"')
end

function utils.dictionary(cmd)
    local url = "https://en.wiktionary.org/wiki/" .. cmd
    exec('!qutebrowser "' .. url .. '"')
end

local transparent = false
function utils.trans()
    local colo = vim.api.nvim_exec("colo", true)
    if colo == "dayfox" or colo == "dawnfox" then
        print "Error: Transparent background does not work with a light colorscheme!"
        return
    end
    transparent = not transparent
    require("nightfox").setup {
        options = {
            transparent = transparent,
        },
    }
    vim.cmd("colo " .. colo)
end

------------------------------------------------------------------------
--                          User commands                             --
------------------------------------------------------------------------

function utils.commands()
    require("mappings").diagnostic()
    local cmd = vim.api.nvim_add_user_command
    local complete = function()
        return require("utils.langServers").getClientNames()
    end

    cmd("ToggleVirtual", function(opts)
        require("utils.diagnostics").toggle_virtual_text(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("ToggleSigns", function(opts)
        require("utils.diagnostics").toggle_signs(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("ToggleUnderline", function(opts)
        require("utils.diagnostics").toggle_underline(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("ToggleAllDiagnostics", function(opts)
        require("utils.diagnostics").toggle_all_diagnostics(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("DisableDiagnostics", function(opts)
        require("utils.diagnostics").turn_off_diagnostics(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("EnableDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("DefaultDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics_default(opts.args)
    end, { nargs = 1, complete = complete })
end

return utils
