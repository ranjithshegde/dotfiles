local map = vim.keymap.set

------------------------------------------------------------------------
--                              General mappings                      --
------------------------------------------------------------------------

return function()
    local opts = { nowait = true, silent = true }
    -- Extend C-keys
    map('n', '<C-;>', ';')
    map('n', '<C-,>', ',')
    map('n', '<C-i>', '<C-i>', { desc = 'Dont map C-i to Tab' })
    map({ 'n', 'i', 's' }, '<BS>', '<BS>', { desc = 'Dont map C-h to backspace' })

    --line movement
    map('x', 'K', ":move '<-2<CR>gv", { desc = 'Move line up' })
    map('x', 'J', ":move '>+1<CR>gv", { desc = 'Move line down' })
    -- Indent
    map('v', '<', '<gv', opts)
    map('v', '>', '>gv', opts)

    -- Toggle folds
    map('n', '<Tab>', 'za', { desc = 'Toggle fold current' })
    map('n', '<S-Tab>', 'zA', { desc = 'Toggle fold All' })
    -- open folds when searching
    map('n', 'n', 'nzzzv', { desc = 'jump to next search result' })
    map('n', 'N', 'Nzzzv', { desc = 'jump to previous search result' })
    map('n', 'J', 'mzJ`z', { desc = 'Adjoin next line' })

    --Quickfix
    map('n', '-', function()
        require('r.extensions.qf').toggle_qf 'q'
    end, { desc = 'Toggle quickfix' })
    map('n', '_', function()
        require('r.extensions.qf').toggle_qf 'l'
    end, { desc = 'Toggle loclist' })
    -- ScratchPad
    map('n', '<leader>S', function()
        require 'r.extensions.project.scratchpad' 'tab'
    end, { desc = 'Open ScratchPad' })

    -- Misc
    map('n', 'gx', function()
        local word = vim.fn.expand '<cWORD>'
        local begin = word:find '%('
        if begin then
            word = word:sub(begin + 1):gsub('%)', '')
        else
            begin = word:find '%['
            if begin then
                word = word:gsub('%[', '')
                local ends = word:find '%]'
                if ends then
                    word = word:sub(begin, ends - 1)
                end
            end
        end

        require('r.utils').open_in_browser(word)
    end, { desc = 'exec word under cursor' })

    map({ 'n', 't' }, '<F9>', function()
        vim.cmd.stopinsert()
        require('r.extensions').toggleTerm('zsh', 'shell', 1)
    end, {
        desc = 'Toggle current/default terminal',
    })
end
