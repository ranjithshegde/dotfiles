return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            "<leader>'",
            function()
                local harp = require 'harpoon'
                harp:list():next()
            end,
            'Navigate to next harpooned file',
        },
        {
            '<leader>`',
            function()
                local harp = require 'harpoon'
                harp:list():prev()
            end,
            'Navigate to previous harpooned file',
        },
        {
            '<leader><leader>',
            function()
                local harp = require 'harpoon'
                harp.ui:toggle_quick_menu(harp:list())
            end,
            'Open harpoon list',
        },
        {
            '<leader><Space>',
            function()
                local harp = require 'harpoon'
                harp:list():add()
            end,
            'Harpoon current file',
        },
    },
}
