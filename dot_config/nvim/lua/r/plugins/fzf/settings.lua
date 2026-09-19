local fzy = {}

local function dir_changer(entry, cwd)
    entry = entry:gsub('[\128-\255]+', '')
    entry = vim.fs.joinpath(cwd, entry)
    vim.cmd.tcd(vim.fs.dirname(entry))
end

fzy.layouts = {
    full = {
        fullscreen = true,
        border = 'none',
        preview = { horizontal = 'up:75%', bordor = 'none', scrollbar = false },
    },
    center_stack = {
        preview = { horizontal = 'up:50%' },
    },
    stack = {
        row = 1,
        column = 1,
        height = 0.5,
        preview = { horizontal = 'up:85%' },
    },
    partial_stack = {
        row = 1,
        column = 1,
        height = 0.75,
        width = 0.5,
        preview = { horizontal = 'up:30%', layout = 'horizontal' },
    },
    cursor = {
        relative = 'cursor',
        row = 1,
        col = 0,
        height = 0.3,
        preview = { horizontal = 'down:30%' },
    },
}

function fzy.cd_files(prompt, cwd)
    local fzf = require 'fzf-lua'
    local def_action = fzf.actions
    local dir = vim.fs.normalize(cwd)
    fzf.files {
        prompt = prompt,
        cwd = dir,
        actions = {
            ['default'] = {
                fn = function(selected, opts)
                    dir_changer(selected[1], dir)
                    def_action.file_edit(selected, opts)
                end,
            },
            ['ctrl-s'] = {
                fn = function(selected, opts)
                    dir_changer(selected[1], dir)
                    def_action.file_split(selected, opts)
                end,
            },
            ['ctrl-v'] = {
                fn = function(selected, opts)
                    dir_changer(selected[1], dir)
                    def_action.file_vsplit(selected, opts)
                end,
            },
            ['ctrl-t'] = {
                fn = function(selected, opts)
                    dir_changer(selected[1], dir)
                    def_action.file_tabedit(selected, opts)
                end,
            },
        },
    }
end

function fzy.cd_folder(prompt, cwd)
    local fzf = require 'fzf-lua'
    local dir = vim.fs.normalize(cwd)
    local fd_command = 'fd --type d'

    fzf.fzf_exec(fd_command, {
        prompt = prompt,
        fzf_opts = { ['--layout'] = 'reverse-list' },
        cwd = dir,
        actions = {
            ['default'] = {
                fn = function(selected, opts)
                    fzf.actions.cd(selected, opts)
                    fzf.files()
                end,
            },
        },
    })
end

function fzy.setup()
    local config = require 'fzf-lua.config'
    local actions = require 'fzf-lua.actions'

    config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
    config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
    config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
    config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'

    require('fzf-lua').setup {
        defaults = {
            formatter = 'path.dirname_first',
            git_icons = true,
            file_icons = true,
            color_icons = true,
            actions = {
                ['ctrl-q'] = { fn = actions.file_sel_to_qf, prefix = 'select-all' },
                ['ctrl-l'] = { fn = actions.file_sel_to_ll, prefix = 'select-all' },
                ['ctrl-L'] = { fn = actions.file_sel_to_ll },
            },
        },
        files = {
            fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude .ccls-cache --exclude .cache]],
        },
        grep = { multiprocess = true },
        lines = { winopts = fzy.layouts.stack },
        blines = { winopts = fzy.layouts.full },
        lsp = {
            jump1 = true,
            code_actions = {
                winopts = fzy.layouts.cursor,
                previewer = vim.fn.executable 'delta' == 1 and 'codeaction_native' or nil,
                preview_pager = "delta --width=$COLUMNS --hunk-header-style='omit' --file-style='omit'",
            },
        },
        zoxide = {
            actions = {
                ['default'] = {
                    fn = function(selected, opts)
                        actions.cd(selected, opts)
                        require('fzf-lua').git_files()
                    end,
                },
            },
        },
    }
end

function fzy.init()
    require 'r.plugins.fzf.mappings'

    local function on_select(...)
        require('fzf-lua').register_ui_select(function(_, items)
            local min_h = 0.25
            local max_h = 0.65
            local h = (#items + 2) / vim.o.lines
            h = math.max(min_h, math.min(h, max_h))
            return { winopts = { height = h, width = 0.60, row = 0.40 } }
        end)
        return vim.ui.select(...)
    end

    if vim.ui.select ~= on_select then
        vim.ui.select = on_select
    end
end

local function get_readme(path)
    if path == '' then
        return ''
    end
    for _, file in ipairs { 'README.md', 'README' } do
        local full = path .. '/' .. file
        if vim.fn.filereadable(full) == 1 then
            return full
        end
    end
    return path
end

function fzy.run_pack_manager(only_non_active)
    local fzf = require 'fzf-lua'
    local utils = require 'fzf-lua.utils'

    local lockfile_path = vim.fn.stdpath 'config' .. '/nvim-pack-lock.json'
    if vim.fn.filereadable(lockfile_path) == 0 then
        vim.notify('nvim-pack-lock.json not found', vim.log.levels.ERROR)
        return
    end

    local lock_content = table.concat(vim.fn.readfile(lockfile_path), '\n')
    local lock_data = vim.json.decode(lock_content)

    if not lock_data or not lock_data.plugins then
        vim.notify('No plugins found in lockfile', vim.log.levels.WARN)
        return
    end

    local pack_plugins = vim.pack.get()
    local pack_info = {}
    for _, p in ipairs(pack_plugins) do
        pack_info[p.spec.name] = p
    end

    local entries = {}
    local entry_to_name = {}

    for plugin_name, info in pairs(lock_data.plugins) do
        local p_data = pack_info[plugin_name] or {}
        local is_active = p_data.active or false
        local plugin_path = p_data.path or ''

        if not only_non_active or not is_active then
            local preview_file = get_readme(plugin_path)
            local display_name = utils.ansi_codes.blue(plugin_name)
            local display_rev = utils.ansi_codes.green(string.sub(info.rev or '', 1, 7))
            local display_text = string.format('[%s] %s', display_rev, display_name)
            local entry_str = string.format('%s:1:1:%s', preview_file, display_text)

            table.insert(entries, entry_str)
            entry_to_name[entry_str] = plugin_name
        end
    end

    if #entries == 0 then
        vim.notify('No plugins to display', vim.log.levels.INFO)
        return
    end

    fzf.fzf_exec(entries, {
        prompt = 'vim.pack> ',
        previewer = 'builtin',
        fzf_opts = {
            ['--delimiter'] = ':',
            ['--with-nth'] = '4..',
            ['--tiebreak'] = 'begin',
        },
        actions = {
            ['default'] = function(selected)
                local plugin_name = entry_to_name[selected[1]]
                local p_data = pack_info[plugin_name]
                if p_data and p_data.path then
                    vim.cmd('edit ' .. p_data.path)
                end
            end,
            ['ctrl-u'] = function(selected)
                local plugin_name = entry_to_name[selected[1]]
                vim.pack.update { plugin_name }
            end,
            ['ctrl-d'] = function(selected)
                local plugin_name = entry_to_name[selected[1]]
                local p_data = vim.iter(vim.pack.get()):find(function(x)
                    return x.spec.name == plugin_name
                end)

                if p_data then
                    if not p_data.active then
                        vim.pack.del { plugin_name }
                        vim.notify('Deleted: ' .. plugin_name, vim.log.levels.INFO)
                    else
                        vim.notify('Cannot delete active plugin: ' .. plugin_name, vim.log.levels.ERROR)
                    end
                else
                    vim.notify('Plugin not found on disk: ' .. plugin_name, vim.log.levels.WARN)
                end
            end,
        },
    })
end

return fzy
