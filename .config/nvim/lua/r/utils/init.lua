local utils = {}

------------------------------------------------------------------------
--                              Vim options                           --
------------------------------------------------------------------------

---Restart Vim without having to close and run again
function utils.restart()
    require('plenary.reload').reload_module 'r'
    vim.cmd.source '$MYVIMRC'
    vim.api.nvim_exec_autocmds('VimEnter', {})
end

function utils.register_au_id(id)
    if type(id) ~= 'table' then
        vim.notify(
            string.format('autocmd id %s not supplied as list, regitartion failed', vim.inspect(id)),
            vim.log.levels.WARN,
            { title = 'autocmd creation' }
        )
        return
    end
    if not vim.g.au_id then
        vim.g.au_id = id
    else
        local temp = vim.g.au_id
        vim.g.au_id = vim.tbl_extend('keep', temp, id)
    end
end

------------------------------------------------------------------------
--                          Plugin functions                          --
------------------------------------------------------------------------

---Programatically build a shell command to execute
---@param args table table of shell command and args, separated by word
function utils.silent_shell(args)
    vim.api.nvim_cmd({ cmd = '!', args = args, mods = { silent = true } }, {})
end

function utils.open_in_browser(url)
    local handle
    local args = type(url) == 'table' and url or { url }
    handle = vim.loop.spawn('xdg-open', { args = args }, function()
        handle:close()
    end)
end

---Concat all lines from a file into a table
---@param file string filepath
---@return table
function utils.concat_fileLines(file)
    local dictionary = {}
    for line in io.lines(file) do
        table.insert(dictionary, line)
    end
    return dictionary
end

---Get keys with replaced termcodes
---@param key string key sequence
---@param mode string vim-mode for the keymap
function utils.feedkey(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

---Open thesaurus for the word online
---@param cmd string Word to search
function utils.thesaurus(cmd)
    local url = 'https://www.thesaurus.com/browse/' .. cmd
    utils.open_in_browser(url)
end

---Open wiktionary for the word online
---@param cmd string Word to search
function utils.dictionary(cmd)
    local url = 'https://en.wiktionary.org/wiki/' .. cmd
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

---Get a table for filename, icon and hl_group
---@param n number window ID
---@param tab boolean True for tabline, false for winbar
---@return table {file_tail, file_icon, icon_highlight}
function utils.get_file_label(n, tab)
    local current_win = tab and vim.api.nvim_tabpage_get_win(n) or n
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local file_name = vim.api.nvim_buf_get_name(current_buf)

    local tail = vim.fn.fnamemodify(file_name, ':p:t')

    if tail == '' then
        if vim.fn.getwininfo(current_win)[1].quickfix == 1 then
            tail = vim.fn.getqflist({ title = true }).title
            vim.notify(tail)
        else
            tail = 'Empty Buffer'
        end
    end

    local result = {
        tail = tail,
        icon = nil,
        color = nil,
    }

    local ext = nil
    if string.find(file_name, 'term://') ~= nil then
        ext = 'terminal'
    else
        ext = vim.fn.fnamemodify(tail, ':e')
    end

    local icon, color = require('nvim-web-devicons').get_icon_color(tail, ext)

    if icon ~= nil then
        local table = vim.api.nvim_get_hl_by_name('TablineSel', true)
        if tab then
            vim.api.nvim_set_hl(0, 'IconColor', { bg = table['background'], fg = color, cterm = { bold = true } })
        end
        result.icon = icon
        result.color = color
    end
    return result
end

---Get a table with names of currnetly active language server names
---@return table Active clients
function utils.get_client_names()
    local buf_clients = vim.lsp.get_active_clients()

    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
    end
    return buf_client_names
end

local vi = false
function utils.toggle_vi()
    if vi then
        vim.o.number = true
        vim.o.relativenumber = true
        vim.o.signcolumn = 'auto'
        vim.o.foldcolumn = 'auto:1'
        vim.o.laststatus = 3
        if vim.b.hasLsp then
            vim.cmd.DefaultDiagnostics()
        end
        vim.cmd.IndentBlanklineToggle()

        vi = false
    else
        vim.o.number = false
        vim.o.relativenumber = false
        vim.o.signcolumn = 'no'
        vim.o.foldcolumn = '0'
        vim.o.laststatus = 0
        if vim.b.hasLsp then
            vim.cmd.DisableDiagnostics()
        end
        vim.cmd.IndentBlanklineToggle()
        vi = true
    end
end

---Load a plugin on key press or key sequence
---@param mode table|string The mapping modes
---@param key string The key sequence to map
---@param desc string The desription for the keymapping
---@param callback function The function to be evaluated on keypress
---@param args any Arguements to the callback if any
function utils.lazy_on_key(mode, key, desc, callback, args)
    vim.keymap.set(mode, key, function()
        vim.keymap.del(mode, key)
        if args and type(args) == 'table' then
            callback(unpack(args))
        else
            callback(args)
        end
        utils.feedkey(key, 'm')
    end, { desc = desc })
end

function utils.plugin_setup(module, key, config)
    return function()
        if key then
            if config then
                require(module)[key](config)
            else
                require(module)[key]()
            end
        else
            require(module)()
        end
    end
end

---Write current file and source it within current nvim instance
---@param buf number Bufner to attach mapping to
function utils.write_and_source(buf)
    vim.keymap.set('n', '<F6>', function()
        vim.cmd.write()
        vim.cmd.source '%'
    end, { buffer = buf, desc = 'Evaluate current file' })
end

---Set css and html as alternate files to each other
function utils.switch_alternate()
    local open_cmd = vim.loop.fs_stat(vim.fn.glob 'css/*.css') and vim.fn.glob 'css/*.css' or vim.fn.glob '*.css'
    vim.keymap.set('n', '<leader>s', function()
        if vim.fn.expand '%:e' == 'html' then
            vim.cmd.edit(open_cmd)
        else
            vim.cmd.edit 'index.html'
        end
    end, { buffer = 0, silent = true, desc = 'Open alternate shader file' })
end

---Switch bg and fg for statusline separator component
---@param hl1 string
---@param hl2 string
function utils.switch_highlight(hl1, hl2)
    local hl = vim.api.nvim_get_hl_by_name(hl1, true)
    vim.api.nvim_set_hl(0, hl2, { fg = hl.background })
end

return utils
