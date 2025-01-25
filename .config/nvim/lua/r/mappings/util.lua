local utilmaps = {}
local wk = require 'which-key'
local map = vim.keymap.set
local mapper = require 'r.utils.expand_maps'

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

local function move(cmd, count)
    local old_fold = vim.wo.foldmethod
    if old_fold ~= 'manual' then
        vim.wo.foldmethod = 'manual'
    end
    vim.cmd.normal { args = { 'm`' }, bang = true }
    vim.cmd.move { args = { cmd, tostring(count) } }
    vim.cmd.normal { args = { '``' }, bang = true }
    if old_fold ~= 'manual' then
        vim.wo.foldmethod = old_fold
    end
end

local function ranger(path, cmd, opts)
    return function()
        if vim.g.is_win32 then
            vim.notify(
                'ranger is not available in Windows. Use `Oil` instead',
                vim.log.levels.ERROR,
                { title = 'Ranger' }
            )
            return
        end
        vim.api.nvim_open_win(
            0,
            true,
            opts or { relative = 'editor', row = 0, col = 30, width = 150, height = 150, border = 'double' }
        )
        require('r.extensions').ranger(path, cmd)
    end
end

local function open_term(split, mods)
    return function()
        require('r.utils').ex_cmd(split, { 'term://zsh' }, mods, { file = true, bar = true })
    end
end

function utilmaps.ranger()
    wk.add(mapper {
        ['<leader>r'] = {
            name = 'Ranger file picker',
            r = { ranger('%:p:h', 'e '), 'from current file' },
            R = { ranger('.', 'e '), 'from current directory' },
            v = { ranger('%:h', 'vs '), 'in a split from current file' },
            V = { ranger('.', 'vs '), 'in a split from current directory' },
            t = { ranger('%:p:h', 'tab drop '), 'in a new tab from current file' },
            T = { ranger('.', 'tab drop '), 'in a new tab from current directory' },
        },
    })
end

function utilmaps.terminal()
    wk.add(mapper {
        ['<leader>t'] = {
            name = 'Launch terminal in split',
            h = { open_term('split', { silent = true }), 'Horizontal' },
            v = { open_term('vsplit', { silent = true }), 'Vertical' },
            t = { open_term('drop', { silent = true, tab = 2 }), 'New tab' },
        },
    })
end

function utilmaps.wordProcessor()
    map('n', '<leader><Space>', function()
        vim.cmd.global "/^/pu=''"
    end, { desc = 'Double space entire file' })
    map('n', 'sm', function()
        require('r.utils').dictionary(vim.fn.expand '<cword>')
    end, { desc = 'Lookup Wikitionary' })
    map('n', 'ss', function()
        require('r.utils').thesaurus(vim.fn.expand '<cword>')
    end, { desc = 'Lookup Synonyms' })
end

function utilmaps.move()
    map('n', ']e', function()
        move('+', vim.v.count1 - 1)
    end, { desc = 'Move current line below to the specified count' })

    map('n', '[e', function()
        move('--', vim.v.count1 - 1)
    end, { desc = 'Move current line above to the specified count' })
end

return utilmaps
