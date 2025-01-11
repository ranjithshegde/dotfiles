local utilmaps = {}
local wk = require 'which-key'
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

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

function utilmaps.ranger()
    wk.add(require('r.utils.maps').convert_maps {
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

function utilmaps.wordProcessor()
    map('n', '<leader><Space>', function()
        vim.cmd.global "/^/pu=''"
    end, { desc = 'Double space entire file' })
    map('n', ',K', function()
        require('r.utils').dictionary(vim.fn.expand '<cword>')
    end, { desc = 'Lookup Wikitionary' })
    map('n', ',T', function()
        require('r.utils').thesaurus(vim.fn.expand '<cword>')
    end, { desc = 'Lookup Synonyms' })
end

return utilmaps
