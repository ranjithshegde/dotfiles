local map = vim.keymap.set

------------------------------------------------------------------------
--                              General mappings                      --
------------------------------------------------------------------------

return function()
    local opts = { nowait = true, silent = true }
    -- Extend C-keys
    map({ 'n', 'v' }, 's', '<Nop>', opts)
    map('s', 's', 's', opts)
    map('n', '<C-i>', '<C-i>', { desc = 'Dont map C-i to Tab' })
    map({ 'n', 'i', 's' }, '<BS>', '<BS>', { desc = 'Dont map C-h to backspace' })

    --line movement
    map('x', 'K', "<cmd>move '<-2<CR>gv", { desc = 'Move line up' })
    map('x', 'J', "<cmd>move '>+1<CR>gv", { desc = 'Move line down' })
    -- Indent
    map('v', '<', '<gv', opts)
    map('v', '>', '>gv', opts)

    -- open folds when searching
    map('n', 'n', 'nzzzv', { desc = 'jump to next search result' })
    map('n', 'N', 'Nzzzv', { desc = 'jump to previous search result' })
    map('n', 'J', 'mzJ`z', { desc = 'Adjoin next line' })
    map('i', 'jk', '<Esc>', { desc = 'Map Esc to jk' })

    map('n', 'cr<Space>', function()
        vim.cmd.global "/^/pu=''"
    end, { desc = 'Double space entire file' })

    map('n', '<leader>p', vim.pack.update, { desc = 'Update plugins' })
end
