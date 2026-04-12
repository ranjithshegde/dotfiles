local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/lewis6991/gitsigns.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('gitsigns', plug.spec.name, function()
            require('r.plugins.git').signs_config()
        end)

        require('r.plugins.git').signs_init()
    end,
    confirm = false,
})

add({ 'https://github.com/NeogitOrg/neogit' }, {
    load = function(plug)
        utils.lazy_plugin('neogit', plug.spec.name, function()
            require('r.plugins.git').neogit_config()
        end)

        utils.lazy_command('Neogit', 'neogit')

        require('r.plugins.git').neogit_maps()
    end,
    confirm = false,
})

add({ 'https://github.com/dlyongemallo/diffview.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('diffview', plug.spec.name)
        utils.lazy_command({ 'DiffviewOpen', 'DiffviewFileHistory' }, 'diffview')
    end,
    confirm = false,
})
