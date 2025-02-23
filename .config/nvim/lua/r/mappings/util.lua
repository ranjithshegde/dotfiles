local utilmaps = {}
local wk = require 'which-key'
local map = vim.keymap.set
local mapper = require 'r.utils.expand_maps'

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

local function yazi(path, cmd, opts)
    return function()
        vim.api.nvim_open_win(
            0,
            true,
            opts or { relative = 'editor', row = 0, col = 30, width = 150, height = 150, border = 'double' }
        )
        require('r.extensions').yazi(path, cmd)
    end
end

local function open_term(split, mods)
    return function()
        require('r.utils').ex_cmd(split, { 'term://zsh' }, mods, { file = true, bar = true })
    end
end

function utilmaps.yazi()
    wk.add(mapper {
        ['<leader>r'] = {
            name = 'Yazi file picker',
            r = { yazi('%:p:h', 'e '), 'from current file' },
            R = { yazi('.', 'e '), 'from current directory' },
            v = { yazi('%:h', 'vs '), 'in a split from current file' },
            V = { yazi('.', 'vs '), 'in a split from current directory' },
            t = { yazi('%:p:h', 'tab drop '), 'in a new tab from current file' },
            T = { yazi('.', 'tab drop '), 'in a new tab from current directory' },
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
        require('r.extensions').move_lines('+', vim.v.count1 - 1)
    end, { desc = 'Move current line below to the specified count' })

    map('n', '[e', function()
        require('r.extensions').move_lines('--', vim.v.count1 - 1)
    end, { desc = 'Move current line above to the specified count' })
end

return utilmaps
