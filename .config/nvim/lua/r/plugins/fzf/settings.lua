local fzy = {}

local function dir_changer(entry, cwd)
    entry = entry:gsub('.*([%z\1-\127\128-\255]+)', '')
    entry = vim.fs.joinpath(cwd, entry)
    if vim.uv.fs_stat(entry).type == 'directory' then
        vim.cmd.tcd(entry)
    else
        vim.cmd.tcd(vim.fs.dirname(entry))
    end
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
    local fd_command = 'fd --base-directory=' .. dir .. ' --type d .'

    fzf.fzf_exec(fd_command, {
        prompt = prompt,
        fzf_opts = { ['--layout'] = 'reverse-list' },
        actions = {
            ['default'] = {
                fn = function(selected, _)
                    dir_changer(selected[1], dir)
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

return fzy
