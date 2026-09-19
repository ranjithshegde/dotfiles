------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

local mappings = {}
local wk = require 'which-key'
local map = vim.keymap.set
local mapper = require 'r.utils.expand_maps'

function mappings.move()
    map('n', ']e', function()
        require('r.extensions').move_lines('+', vim.v.count1 - 1)
    end, { desc = 'Move current line below to the specified count' })

    map('n', '[e', function()
        require('r.extensions').move_lines('--', vim.v.count1 - 1)
    end, { desc = 'Move current line above to the specified count' })
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

local function open_term(split, mods)
    local shell
    if vim.g.is_win64 then
        shell = 'powershell.exe'
    else
        shell = 'zsh'
    end
    return function()
        require('r.utils').ex_cmd(split, { 'term://' .. shell }, mods, { file = true, bar = true })
    end
end

local function yazi(path, cmd, opts)
    return function()
        require('r.extensions').yazi(path, cmd, true, opts)
    end
end

function mappings.yazi()
    wk.add(mapper {
        ['<leader>r'] = {
            name = 'Yazi file picker',
            r = { yazi('%:p:h', 'e '), 'from current file' },
            R = { yazi('.', 'e '), 'from current directory' },
            h = { yazi('%:h', 'sp '), 'in a split from current file' },
            H = { yazi('.', 'sp '), 'in a split from current directory' },
            v = { yazi('%:h', 'vs '), 'in a vertical split from current file' },
            V = { yazi('.', 'vs '), 'in a vertical split from current directory' },
            t = { yazi('%:p:h', 'tab drop '), 'in a new tab from current file' },
            T = { yazi('.', 'tab drop '), 'in a new tab from current directory' },
        },
    })
end

function mappings.terminal()
    wk.add(mapper {
        ['<leader>t'] = {
            name = 'Launch terminal in split',
            h = { open_term('split', { silent = true }), 'Horizontal' },
            v = { open_term('vsplit', { silent = true }), 'Vertical' },
            t = { open_term('drop', { silent = true, tab = 2 }), 'New tab' },
        },
    })
end

------------------------------------------------------------------------
--                              Documentation                         --
------------------------------------------------------------------------

mappings.cpp = function(buffer)
    require('which-key').add(require 'r.utils.expand_maps'({
        ['go'] = {
            name = 'Online help',
            a = { require('r.extensions.docs').arduino, 'Arduino' },
            c = { require('r.extensions.docs').cppref, 'C++ std reference' },
            g = { require('r.extensions.docs').glref, 'OpenGL reference' },
            u = { require('r.extensions.docs').unrealref, 'Unreal Engine reference' },
            v = { require('r.extensions.docs').vulkanref, 'Unreal Engine reference' },
        },
    }, { buffer = buffer }))
end

mappings.writer = function(buffer)
    require('which-key').add(require 'r.utils.expand_maps'({
        ['go'] = {
            name = 'Online help',
            w = { require('r.extensions.docs').dictionary, 'Lookup Wikitionary' },
            s = { require('r.extensions.docs').synomyms, 'Lookup Synonyms' },
        },
    }, { buffer = buffer }))
end

return mappings
