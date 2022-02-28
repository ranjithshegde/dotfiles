local utils = {}

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
--                              Terminal                              --
------------------------------------------------------------------------

-- set silent exec option
function utils.silent_shell(cmd)
    Exec("silent exe '!" .. cmd .. " &'")
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

-- Use ranger as file picker
utils.ranger = function(path, edit_cmd)
    local cpath = "/tmp/chosenfile"
    local currentPath = vim.fn.expand(path)
    local rc = {}
    rc.name = "ranger"
    rc.edit_cmd = edit_cmd
    function rc.on_exit(_, code, _)
        if not code then
            vim.cmd "silent! Bclose!"
        end
        if io.open(cpath, "r") then
            for f in io.lines(cpath) do
                vim.fn.execute(edit_cmd .. f)
            end
            cpath = nil
        end
    end
    vim.cmd "enew"
    if vim.fn.isdirectory(currentPath) then
        vim.fn.termopen("ranger --choosefiles=" .. cpath .. ' "' .. currentPath .. '"', rc)
    else
        vim.fn.termopen("ranger --choosefiles=" .. cpath .. ' --selectfile="' .. currentPath .. '"', rc)
    end
    vim.cmd "startinsert"
end

------------------------------------------------------------------------
--                          Plugin functions                          --
------------------------------------------------------------------------

-- set browser
local browser = "qutebrowser"
function utils.open_in_browser(url)
    utils.silent_shell(browser .. " " .. url)
end

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

    cmd("ToggleVirtual", function(opts)
        require("utils.diagnostics").toggle_virtual_text(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })

    cmd("ToggleSigns", function(opts)
        require("utils.diagnostics").toggle_signs(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })

    cmd("ToggleUnderline", function(opts)
        require("utils.diagnostics").toggle_underline(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })

    cmd("ToggleAllDiagnostics", function(opts)
        require("utils.diagnostics").toggle_all_diagnostics(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })

    cmd("DisableDiagnostics", function(opts)
        require("utils.diagnostics").turn_off_diagnostics(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })

    cmd("EnableDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })

    cmd("DefaultDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics_default(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return require("utils.langServers").getClientNames()
        end,
    })
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
