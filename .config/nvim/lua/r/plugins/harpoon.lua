local harpoon = {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
}

-- ************** Load harpoon maps ------------------------------------
function harpoon.init()
    local map = vim.keymap.set

    map('n', "<leader>'", function()
        local harp = require 'harpoon'
        harp:list().next()
    end, { desc = 'Navigate to next harpooned file' })

    map('n', '<leader>`', function()
        local harp = require 'harpoon'
        harp:list().prev()
    end, { desc = 'Navigate to previous harpooned file' })

    map('n', '<leader><leader>', function()
        local harp = require 'harpoon'
        harp.ui:toggle_quick_menu(harp:list())
    end, { desc = 'Open harpoon list' })

    map('n', '<leader><Space>', function()
        local harp = require 'harpoon'
        harp:list().add()
    end, { desc = 'Harpoon current file' })
end

return harpoon
