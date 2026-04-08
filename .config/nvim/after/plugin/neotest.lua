local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/nvim-neotest/nvim-nio' }, {
    load = function(plug)
        utils.lazy_plugin('nio', plug.spec.name)
    end,
    confirm = false,
})

add({ 'https://github.com/nvim-neotest/neotest' }, {
    load = function(plug)
        utils.lazy_plugin('neotest', plug.spec.name, function()
            require('r.plugins.neotest').config()
        end)
        utils.lazy_command('Neotest', 'neotest')

        require('r.plugins.neotest').init()
    end,
    confirm = false,
})

add({ 'https://github.com/alfaix/neotest-gtest' }, {
    load = function(plug)
        utils.lazy_plugin('neotest-gtest', plug.spec.name)
    end,
    confirm = false,
})
