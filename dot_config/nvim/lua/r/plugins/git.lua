------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

local wk = require 'which-key'
local maps = require 'r.utils.expand_maps'

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

function g.neogit_config()
    require('neogit').setup {
        kind = 'split',
        disable_insert_on_commit = true,
        graph_style = 'kitty',
        process_spinner = true,
        integrations = {
            diffview = true,
            fzf_lua = true,
        },
    }
end

function g.neogit_maps()
    wk.add(maps {
        ['<leader>g'] = {
            name = 'git functions',
            a = {
                function()
                    local file = vim.fn.expand '%'
                    require('neogit.lib.git.index').add { file }
                end,
                'add current buffer',
            },
            b = { neogit_command { 'branch' }, 'branch poppup' },
            c = { neogit_command { 'commit' }, 'commit changes' },
            C = { neogit_lua('commit', 'commit', { '--verbose', '--all' }), 'commit changes' },
            d = { '<cmd>DiffviewOpen<CR>', 'launch difftool' },
            D = { '<cmd>DiffviewFileHistory<CR>', 'launch diff history' },
            g = { neogit_command { 'kind=floating' }, 'Git window' },
            l = {
                function()
                    local file = vim.fn.expand '%'
                    neogit_lua('log', 'log_current', { '--graph', '--color', '--decorate', '--', file })()
                end,
                'commit Log file',
            },
            L = {
                neogit_lua('log', 'log_local_branches', { '--graph', '--color', '--decorate' }),
                'commit Log Local',
            },
            p = { neogit_command { 'push' }, 'push commits' },
            P = {
                neogit_lua('push', 'to_pushremote'),
                'Push commits no_confirm',
            },
        },
    })
end

function g.sign_maps(bufnr, gs)
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

function g.signs_init()
    local id = { GitSigns = vim.api.nvim_create_augroup('GitSigns', { clear = true }) }
    vim.api.nvim_create_autocmd({ 'BufReadpost', 'VimEnter', 'DirChanged' }, {
        group = id.GitSigns,
        callback = function(args)
            local git_dir = vim.uv.fs_stat(vim.uv.cwd() .. '/.git')
            if (git_dir and git_dir.type == 'directory') or vim.env.GIT_DIR then
                vim.schedule(function()
                    if not package.loaded['mini.git'] then
                        pcall(require('mini.git').setup)
                    end
                    vim.cmd.packadd 'gitsigns.nvim'
                    g.minigit_commands()
                end)
                vim.api.nvim_del_autocmd(args.id)
            end
        end,
    })
    require('r.utils').register_au_id(id)
end

function g.signs_config()
    require('gitsigns').setup {
        on_attach = function(bufnr)
            require('r.plugins.git').sign_maps(bufnr, package.loaded.gitsigns)
        end,
        preview_config = { focusable = false },
    }
end

function g.minigit_commands()
    vim.api.nvim_create_user_command('Glog', function(args)
        local count = args.args ~= '' and args.args or '25'
        vim.cmd('Git log --graph --decorate --max-count=' .. count .. ' --oneline')
    end, {
        nargs = '?',
        desc = 'Git log graph oneline, optional count: Glog [n]',
    })

    vim.api.nvim_create_user_command('GlogFull', function(args)
        local count = args.args ~= '' and args.args or '25'
        vim.cmd('Git log --graph --decorate --max-count=' .. count)
    end, {
        nargs = '?',
        desc = 'Git log graph full, optional count: GlogFull [n]',
    })
end

return g
