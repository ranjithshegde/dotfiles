local fzy = {}

local function dir_changer(entry, cwd)
    entry = entry:gsub('[\128-\255]+', '')
    entry = vim.fs.joinpath(cwd, entry)
    if vim.uv.fs_stat(entry).type == 'directory' then
        vim.cmd.tcd(entry)
    else
        vim.cmd.tcd(vim.fs.dirname(entry))
    end
end

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

function fzy.project()
    local fzf = require 'fzf-lua'
    local fd_command = "fd '.git$' --prune -utd " .. table.concat(require('r.utils.tables').workspace_folderes, ' ')

    fzf.fzf_exec(fd_command .. ' | xargs dirname', {
        prompt = 'Select Project: ',
        fzf_opts = { ['--layout'] = 'default' },
        actions = {
            ['default'] = function(selected, _)
                vim.cmd.tcd(selected[1])
                fzf.git_files { cwd = selected[1] }
            end,
            ['ctrl-f'] = function(selected, _)
                vim.cmd.tcd(selected[1])
                fzf.grep_project { cwd = selected[1] }
            end,
            ['ctrl-r'] = function(selected, _)
                vim.cmd.tcd(selected[1])
                fzf.oldfiles { cwd = selected[1] }
            end,
        },
    })
end

function fzy.setup()
    local config = require 'fzf-lua.config'
    local actions = require 'fzf-lua.actions'

    config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
    config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
    config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
    config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
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
                ['ctrl-Q'] = { fn = actions.file_sel_to_qf },
                ['ctrl-L'] = { fn = actions.file_sel_to_ll },
            },
        },
        files = {
            fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude .ccls-cache --exclude .cache]],
        },
        grep = {
            multiprocess = true,
        },
        lsp = {
            jump_to_single_result = true,
            code_actions = {
                winopts = {
                    relative = 'cursor',
                    row = 1,
                    col = 0,
                    height = 0.4,
                    preview = { vertical = 'down:70%' },
                },
                previewer = vim.fn.executable 'delta' == 1 and 'codeaction_native' or nil,
                preview_pager = "delta --width=$COLUMNS --hunk-header-style='omit' --file-style='omit'",
            },
        },
    }
end

function fzy.init()
    require 'r.plugins.fuzzy.mappings'

    local function on_select(...)
        require('fzf-lua').register_ui_select(function(_, items)
            local min_h, max_h = 0.15, 0.70
            local h = (#items + 4) / vim.o.lines
            if h < min_h then
                h = min_h
            elseif h > max_h then
                h = max_h
            end
            return { winopts = { height = h, width = 0.60, row = 0.40 } }
        end)
        return vim.ui.select(...)
    end

    if vim.ui.select ~= on_select then
        vim.ui.select = on_select
    end
end

return fzy
