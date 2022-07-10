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
    utils.UnloadAllModules()
    vim.cmd "source $MYVIMRC"
    auexec("VimEnter", {})
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

-- set silent exec option
function utils.silent_shell(args)
    vim.api.nvim_cmd({ cmd = "!", args = args, mods = { silent = true } }, {})
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
function utils.ranger(path, edit_cmd)
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
    if type(url) == "table" then
        vim.loop.spawn(browser, { args = url })
    else
        vim.loop.spawn(browser, { args = { url } })
    end
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

---Execute ex-command through nvim_cmd
---@param cmd string command to execute
---@param args table a list of arguments (each is as a string)
---@param mods table list of modifiers like silent, split, position etc..
---@param magic table whether the command contains magic expansion chars (%) or seperators (|)
function utils.ex_cmd(cmd, args, mods, magic)
    vim.api.nvim_cmd({ cmd = cmd, args = args and args, mods = mods and mods, magic = magic and magic }, {})
end

function utils.get_visual_selection(bufnr)
    vim.api.nvim_input "<Esc>"
    vim.api.nvim_input "gv"
    local first = vim.api.nvim_buf_get_mark(bufnr, "<")
    local last = vim.api.nvim_buf_get_mark(bufnr, ">")
    local lines = vim.api.nvim_buf_get_lines(bufnr, first[1], last[1], true)

    return {
        lines = lines,
        line_start = first[1],
        line_end = last[1],
        col_start = first[2],
        col_end = last[2],
    }
end

---Get a table for filename, icon and hl_group
---@param n number window ID
---@param tab boolean True for tabline, false for winbar
---@return table {file_tail, file_icon, icon_highlight}
function utils.get_file_label(n, tab)
    local current_win = tab and vim.api.nvim_tabpage_get_win(n) or n
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local file_name = vim.api.nvim_buf_get_name(current_buf)

    local tail = vim.fn.fnamemodify(file_name, ":p:t")

    local result = {
        tail = tail,
        icon = nil,
        color = nil,
    }
    if tail == "" then
        if vim.fn.getwininfo(current_win)[1].quickfix == 1 then
            tail = vim.fn.getqflist({ title = true }).title
        end
        if tail == "" then
            result.tail = "Empty Buffer"
            return result
        else
            result.tail = tail
        end
    end

    local ext = nil
    if string.find(file_name, "term://") ~= nil then
        ext = "terminal"
    else
        ext = vim.fn.fnamemodify(tail, ":e")
    end

    local icon, color = require("nvim-web-devicons").get_icon_color(tail, ext)

    if icon ~= nil then
        local table = vim.api.nvim_get_hl_by_name("TablineSel", true)
        if tab then
            vim.api.nvim_set_hl(0, "IconColor", { bg = table["background"], fg = color, cterm = { bold = true } })
        end
        result.icon = icon
        result.color = color
    end
    return result
end

return utils
