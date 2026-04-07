local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/mfussenegger/nvim-dap' }, {
    load = function(plug)
        utils.lazy_plugin('dap', plug.spec.name, function()
            require('r.plugins.debug.settings').setup()
        end)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/theHamsta/nvim-dap-virtual-text' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-dap-virtual-text', plug.spec.name, true)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/igorlfs/nvim-dap-view' }, {
    load = function(plug)
        utils.lazy_plugin('dap-view', plug.spec.name, function()
            require('dap-view').setup {
                winbar = {
                    controls = { enabled = true },
                },
            }
        end)
    end,
    confirm = false,
})

require('r.plugins.debug.settings').init()
