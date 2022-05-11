local exec = vim.api.nvim_command
local auexec = vim.api.nvim_exec_autocmds
local utils = {}

------------------------------------------------------------------------
--                              Vim options                           --
------------------------------------------------------------------------

function utils.UnloadAllModules()
    -- Lua patterns for the modules to unload
    local unload_modules = {
        "mappings",
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

---Restart Vim without having to close and run again
function utils.Restart()
    -- vim.cmd "LspStop"
    utils.UnloadAllModules()
    vim.cmd "source $MYVIMRC"
    auexec("VimEnter", {})
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

-- set silent exec option
function utils.silent_shell(cmd)
    exec("silent exe '!" .. cmd .. " &'")
end

-- Toggleable terminal
---@param cmd string launch the shell with
---@param name string name/ID for the terminal window
---@param spl number 0 = horizontal split, 1 = vertical split
function utils.toggleTerm(cmd, name, spl)
    local win = vim.fn.bufwinnr(name)
    local buf = vim.fn.bufexists(name)
    local split = spl and "belowright vnew" or "belowright new"
    if win > 0 then
        exec(win .. " wincmd c")
    elseif buf > 0 then
        exec(split)
        exec("buffer " .. name)
        exec "startinsert"
    else
        exec(split)
        vim.fn.termopen(cmd)
        exec "startinsert"
        exec("f " .. name)
    end
end

---Use ranger as file picker
---@param path string Patht open ranger from
---@param edit_cmd string Ranger window position - e: open over current buffer - vs: Vertical split - tab drop: in new or existing tab window
utils.ranger = function(path, edit_cmd)
    local cpath = "/tmp/chosenfile"
    local currentPath = vim.fn.expand(path)
    local rc = { name = "ranger", edit_cmd = edit_cmd }
    function rc.on_exit(_, code, _)
        if not code then
            vim.api.nvim_buf_delete(0, { force = true })
        end
        if io.open(cpath, "r") then
            for f in io.lines(cpath) do
                vim.fn.execute(edit_cmd .. f)
            end
            os.remove(cpath)
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
    os.execute(browser .. " " .. url)
end

---Concat all lines from a file into a table
---@param file string filepath
---@return table
utils.concat_fileLines = function(file)
    local dictionary = {}
    for line in io.lines(file) do
        table.insert(dictionary, line)
    end
    return dictionary
end

---Get keys with replaced termcodes
---@param key string key sequence
---@param mode string vim-mode for the keymap
utils.feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---Open thesaurus for the word online
---@param cmd string Word to search
function utils.thesaurus(cmd)
    local url = "https://www.thesaurus.com/browse/" .. cmd
    utils.open_in_browser(url)
end

---Open wiktionary for the word online
---@param cmd string Word to search
function utils.dictionary(cmd)
    local url = "https://en.wiktionary.org/wiki/" .. cmd
    utils.open_in_browser(url)
end

local transparent = false
---Toggle background transparency for dark colorschemes
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

return utils
