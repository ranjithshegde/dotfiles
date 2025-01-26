------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

local wk = require 'which-key'
local maps = require 'r.utils.expand_maps'

local function git_command(args)
    return function()
        vim.api.nvim_cmd({ cmd = 'G', args = args and args }, {})
    end
end

local function neogit_command(args)
    return function()
        vim.api.nvim_cmd({ cmd = 'Neogit', args = args and args }, {})
    end
end

local function neogit_lua(popup, action, args)
    return function()
        vim.schedule(require('neogit').action(popup, action, args and args))
    end
end

local g = {}

function g.fugitive()
    wk.add(maps {
        ['<leader>g'] = {
            name = 'git functions',
            a = { git_command { 'add %' }, 'add current buffer' },
            b = { git_command { 'branch -a' }, 'branch list' },
            -- c = { neogit_lua('commit', 'commit', { '--verbose' }), 'commit changes' },
            c = { neogit_command { 'commit' }, 'commit changes' },
            C = { git_command { 'commit %' }, 'commit current buffer' },
            d = { git_command { 'difftool' }, 'launch difftool' },
            g = { neogit_command { 'kind=floating' }, 'Git window' },
            l = { neogit_lua('log', 'log_current', { '--graph', '--color', '--decorate' }), 'commit Log' },
            L = { git_command { 'log' }, 'commit history' },
            p = { neogit_command { 'push' }, 'push commits' },
            P = { git_command { 'push -f' }, 'force push commits' },
        },
    })
end

function g.signs(bufnr, gs)
    wk.add(maps({
        ['<leader>g'] = {
            name = 'git functions',
            r = { gs.reset_hunk, 'reset hunk under cursor' },
            R = { gs.reset_buffer, 'reset current buffer' },
            s = { gs.stage_hunk, 'stage hunk under cursor' },
            S = { gs.stage_buffer, 'stage current buffer' },
        },
        sg = {
            name = 'Git',
            i = { gs.preview_hunk_inline, 'Inline diff for hunk' },
            b = { gs.blame_line, 'Blame' },
            B = { gs.blame, 'Blame pane' },
            v = { gs.toggle_current_line_blame, 'toggle blame virtual text' },
            x = { gs.toggle_deleted, 'Toggle deleted' },
            w = { gs.toggle_word_diff, 'Toggle word diff' },
            l = { gs.toggle_linehl, 'Toggle line highlights' },
            h = {
                function()
                    gs.toggle_linehl()
                    gs.toggle_word_diff()
                end,
                'Toggle buffer highlights',
            },
        },
        [']h'] = {
            function()
                if vim.wo.diff then
                    return ']c'
                end
                vim.schedule(function()
                    gs.next_hunk { preview = true }
                end)
                return '<Ignore>'
            end,
            'Preview previous hunk',
            expr = true,
        },
        ['[h'] = {
            function()
                if vim.wo.diff then
                    return '[c'
                end
                vim.schedule(function()
                    gs.prev_hunk { preview = true }
                end)
                return '<Ignore>'
            end,
            'Preview next hunk',
            expr = true,
        },
    }, { buffer = bufnr }))

    vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = 'select git hunk' })
end

return g
