local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('lualine', plug.spec.name, function()
            require('r.plugins.ui').lualine()
        end)

        utils.lazy_event('UIEnter', 'lualine')
    end,
    confirm = false,
})
