return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            ']`',
            function()
                require('harpoon'):list():next()
            end,
            'Navigate to next harpooned file',
        },
        {
            '[`',
            function()
                require('harpoon'):list():prev()
            end,
            'Navigate to previous harpooned file',
        },
        {
            '<leader>`',
            function()
                require('harpoon'):list():add()
            end,
            'Harpoon current file',
        },
        {
            '<leader><leader>',
            function()
                require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
            end,
            'Open harpoon list',
        },
    },
}
