local utils = {}

------------------------------------------------------------------------
--                              Vim options                           --
------------------------------------------------------------------------

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
    vim.system { 'xdg-open', url }
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

---Execute ex-command through nvim_cmd
---@param cmd string command to execute
---@param args table a list of arguments (each is as a string)
---@param mods table list of modifiers like silent, split, position etc..
---@param magic table whether the command contains magic expansion chars (%) or seperators (|)
function utils.ex_cmd(cmd, args, mods, magic)
    vim.api.nvim_cmd({ cmd = cmd, args = args and args, mods = mods and mods, magic = magic and magic }, {})
end

---Get a table with names of currnetly active language server names
---@return table Active clients
function utils.get_client_names()
    local buf_clients = vim.lsp.get_clients()

    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
    end
    return buf_client_names
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
        vim.schedule(function()
            utils.feedkey(key, 'm')
        end)
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

local lazy_plugins = {}
local original_require = _G.require

local loading = {}

_G.require = function(modname)
    local spec = lazy_plugins[modname]
    if spec and not package.loaded[modname] and not loading[modname] then
        loading[modname] = true
        local pack_dir = spec.pack
        local ok, err = pcall(vim.cmd.packadd, pack_dir)
        loading[modname] = nil
        if not ok then
            error(string.format('packadd failed for %s (%s): %s', modname, pack_dir, err))
        end
        local mod = original_require(modname)
        if spec.setup then
            spec.setup()
        end
        return mod
    end
    return original_require(modname)
end

---@param modname string The name used in `require(modname)`
---@param pack string The directory name inside `pack/plugins/opt/`
---@param setup function|boolean Called after the module is loaded.
---        If a function, it is called directly.
---        If `true`, calls `require(modname).setup()` with no arguments.
function utils.lazy_plugin(modname, pack, setup)
    local wrapped_setup = nil
    if type(setup) == 'function' then
        wrapped_setup = setup
    elseif setup == true then
        wrapped_setup = function()
            require(modname).setup()
        end
    end
    lazy_plugins[modname] = { pack = pack, setup = wrapped_setup }
end

-- Helper: create a lazy-loaded command
-- @param cmd_name string - the command name (e.g., 'FzfLua')
-- @param modname string - the module to require (e.g., 'fzf-lua')
function utils.lazy_command(cmds, modname)
    if type(cmds) == 'string' then
        cmds = { cmds }
    end

    for _, cmd in ipairs(cmds) do
        vim.api.nvim_create_user_command(cmd, function(args)
            require(modname)
            vim.cmd(cmd .. ' ' .. args.args)
        end, { nargs = '*' })
    end
end

--- Create an autocmd that loads the plugin on a given event
---@param events string|table Event(s) (e.g., 'BufReadPost')
---@param modname string Module to require
---@param pattern string|nil File pattern (e.g., '*.md')
function utils.lazy_event(events, modname, pattern)
    local id = { LazyPlugin = vim.api.nvim_create_augroup(modname .. '_lazy_event', { clear = true }) }

    vim.api.nvim_create_autocmd(events, {
        group = id.LazyPlugin,
        pattern = pattern,
        callback = function()
            require(modname)
        end,
        once = true,
    })
    utils.register_au_id(id)
end

--- List all lazy‑loaded modules that have been loaded
function utils.loaded_plugins(print)
    local loaded = {}
    for modname, _ in pairs(lazy_plugins) do
        if package.loaded[modname] then
            table.insert(loaded, modname)
        end
    end
    if print then
        vim.notify('Loaded plugins:\n' .. table.concat(loaded, '\n'), vim.log.levels.INFO, { title = 'Lazy Plugins' })
    end
    return loaded
end

return utils
