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
        move('+', vim.v.count1 - 1)
    end, { desc = 'Move current line below to the specified count' })

    map('n', '[e', function()
        move('--', vim.v.count1 - 1)
    end, { desc = 'Move current line above to the specified count' })
end

function utilmaps.cpp_ref(buf)
    wk.add(require 'r.utils.expand_maps'({
        ['gk'] = {
            name = 'Online help',
            c = {
                require('r.extensions.cpp').cppref,
                'C++ std reference',
            },
            g = {
                require('r.extensions.cpp').glref,
                'OpenGL reference',
            },
            u = {
                require('r.extensions.cpp').unrealref,
                'Unreal Engine reference',
            },
        },
    }, { buffer = buf }))
end

return utilmaps
