local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/nvim-treesitter/nvim-treesitter' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-treesitter', plug.spec.name)
    end,
    confirm = false,
})

add({ 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-treesitter-textobjects', plug.spec.name, function()
            require('r.plugins.treesitter.settings').text_objects()
        end)
    end,
    confirm = false,
})

add({ 'https://github.com/ThePrimeagen/refactoring.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('refactoring', plug.spec.name, function()
            require('r.plugins.treesitter.settings').refactoring()
        end)
    end,
    confirm = false,
})

add({ 'https://github.com/ckolkey/ts-node-action' }, {
    load = function(plug)
        utils.lazy_plugin('ts-node-action', plug.spec.name, function()
            require('r.plugins.treesitter.settings').node_action()
        end)
    end,
    confirm = false,
})

utils.plugin_hook('nvim-treesitter', 'UpdateTreesitter', function(_)
    require('nvim-treesitter.install').update()
end)

require('r.plugins.treesitter.settings').autocmds()
