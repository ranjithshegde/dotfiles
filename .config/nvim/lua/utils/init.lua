local utils = {}

------------------------------------------------------------------------
--                              Global config variables               --
------------------------------------------------------------------------
Api = vim.api
G = vim.g
Var = Api.nvim_set_var
Exec = Api.nvim_command
Op = Api.nvim_get_option
Fn = Api.nvim_call_function
local browser = "qutebrowser"
G.netrw_browsex_viewer = "xdg-open"

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

------------------------------------------------------------------------
--                              Vim options                           --
------------------------------------------------------------------------

function utils.UnloadAllModules()
    -- Lua patterns for the modules to unload
    local unload_modules = {
        "^mappings$",
        "^compiler$",
        "^plugins$",
        "^settings$",
        "^statusline$",
        "^utils$",
        "^debugger$",
    }
    for k, _ in pairs(package.loaded) do
        for _, v in ipairs(unload_modules) do
            if k:match(v) then
                package.loaded[k] = nil
                break
            end
        end
    end
end

-- Reload Vim configuration
function utils.Reload()
    Exec "LspStop"
    utils.UnloadAllModules()
    Exec "source $MYVIMRC"
end

-- Restart Vim without having to close and run again
function utils.Restart()
    utils.Reload()
    Exec "doautocmd VimEnter"
end

------------------------------------------------------------------------
--                              AutoCommands                          --
------------------------------------------------------------------------

function utils.create_augroup(autocmds, name)
    Exec("augroup " .. name)
    Exec "autocmd!"
    for _, autocmd in ipairs(autocmds) do
        Exec("autocmd " .. table.concat(autocmd, " "))
    end
    Exec "augroup END"
end

function utils.create_cmdGroup(autocmds, command, name)
    Exec("augroup " .. name)
    Exec("autocmd! " .. command)
    for _, autocmd in ipairs(autocmds) do
        Exec("autocmd " .. table.concat(autocmd, " "))
    end
    Exec "augroup END"
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

-- set silent exec option
function utils.silent_shell(cmd)
    Exec("silent exe '!" .. cmd .. " &'")
end

-- set browser
function utils.open_in_browser(url)
    utils.silent_shell(browser .. " " .. url)
end

-- Toggleable terminal
function utils.toggleTerm(cmd, name, spl)
    local win = vim.fn.bufwinnr(name)
    local buf = vim.fn.bufexists(name)
    if win > 0 then
        Exec(win .. " wincmd c")
    elseif buf > 0 then
        if spl > 0 then
            Exec "belowright vnew"
        else
            Exec "belowright new"
        end
        Exec("buffer " .. name)
        Exec "startinsert"
    else
        if spl > 0 then
            Exec "belowright vnew"
        else
            Exec "belowright new"
        end
        vim.fn.termopen(cmd)
        Exec "startinsert"
        Exec("f " .. name)
    end
end

------------------------------------------------------------------------
--                          Plugin functions                          --
------------------------------------------------------------------------

function utils.fs()
    if vim.loop.fs_stat(vim.fn.expand "<cfile>") then
        vim.cmd "e <cfile>"
        vim.cmd "lcd %:h:t"
    else
        print "Not a file"
    end
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

------------------------------------------------------------------------
--                          User commands                             --
------------------------------------------------------------------------

function utils.commands()
    require("mappings").diagnostic()
    local cmd = vim.api.nvim_add_user_command
    cmd("ToggleVirtual", function()
        require("utils.diagnostics").toggle_virtual_text(vim.fn.input "Input server: ")
    end, {})
    cmd("ToggleSigns", function()
        require("utils.diagnostics").toggle_signs(vim.fn.input "Input server: ")
    end, {})
    cmd("ToggleUnderline", function()
        require("utils.diagnostics").toggle_underline(vim.fn.input "Input server: ")
    end, {})
    cmd("ToggleAllDiagnostics", function()
        require("utils.diagnostics").toggle_all_diagnostics(vim.fn.input "Input server: ")
    end, {})
    cmd("DisableDiagnostics", function()
        require("utils.diagnostics").turn_off_diagnostics(vim.fn.input "Input server: ")
    end, {})
    cmd("EnableDiagnostics", function()
        require("utils.diagnostics").turn_on_diagnostics(vim.fn.input "Input server: ")
    end, {})
    cmd("DefaultDiagnostics", function()
        require("utils.diagnostics").turn_on_diagnostics_default(vim.fn.input "Input server: ")
    end, {})
end

------------------------------------------------------------------------
--                              Co-authoring                          --
------------------------------------------------------------------------

-- Access agenda from outside orgfile
function utils.agenda()
    Exec "PackerLoad orgmode"
    require("orgmode").action "agenda.prompt"
end

function utils.thesaurus(cmd)
    local url = "https://www.thesaurus.com/browse/" .. cmd
    Exec('!qutebrowser "' .. url .. '"')
end

function utils.dictionary(cmd)
    local url = "https://en.wiktionary.org/wiki/" .. cmd
    Exec('!qutebrowser "' .. url .. '"')
end

-- Start Instant server
function utils.Start()
    local id = vim.fn.input "Enter extension: "
    Exec "PackerLoad instant.nvim"
    Exec("InstantStartServer 192.168.178." .. id .. " 8080")
end

-- Start Single session
function utils.Session()
    local id = vim.fn.input "Enter extension: "
    Exec("InstantStartSession 192.168.178." .. id .. " 8080")
end

-- Start Single buffer
function utils.Single()
    local id = vim.fn.input "Enter extension: "
    Exec("InstantStartSingle 192.168.178." .. id .. " 8080")
end

-- Follow a user
function utils.Follow()
    local name = vim.fn.input "User to follow: "
    Exec("InstantFollow " .. name)
end

-- Join Single session
function utils.JoinSession()
    Exec "PackerLoad instant.nvim"
    local id = vim.fn.input "Enter extension: "
    Exec("InstantJoinSession 192.168.178." .. id .. " 8080")
    utils.Follow()
end

-- Join Single buffer
function utils.JoinSingle()
    Exec "PackerLoad instant.nvim"
    local id = vim.fn.input "Enter extension: "
    Exec("InstantJoinSingle 192.168.178." .. id .. " 8080")
    utils.Follow()
end

return utils
