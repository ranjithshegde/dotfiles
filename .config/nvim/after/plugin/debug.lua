local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/mfussenegger/nvim-dap' }, {
    load = function(plug)
        utils.lazy_plugin('dap', plug.spec.name, function()
            require('r.plugins.debug.settings').setup()
        end)

        require('r.plugins.debug.settings').init()
    end,
    confirm = false,
})

add({ 'https://github.com/igorlfs/nvim-dap-view' }, {
    load = function(plug)
        utils.lazy_plugin('dap-view', plug.spec.name, function()
            require('dap-view').setup {
                winbar = {
                    controls = { enabled = true },
                },
                virtual_text = {
                    enabled = true,
                },
            }
        end)
    end,
    confirm = false,
})
