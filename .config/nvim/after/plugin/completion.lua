local utils = require 'r.utils'

local add = vim.pack.add

add({ 'https://github.com/windwp/nvim-autopairs' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-autopairs', plug.spec.name, function()
            require('r.plugins.completion').pairs()
        end)

        utils.lazy_event('InsertEnter', 'nvim-autopairs')
    end,
    confirm = false,
})

add({ 'https://github.com/rafamadriz/friendly-snippets' }, {
    load = function(plug)
        utils.lazy_plugin('friendly-snippets', plug.spec.name)
    end,
    confirm = false,
})

add({ 'https://github.com/L3MON4D3/LuaSnip' }, {
    load = function(plug)
        utils.lazy_plugin('luasnip', plug.spec.name, function()
            require('r.plugins.completion').luasnip()
        end)
    end,
    confirm = false,
})

add({ { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '^1' } }, {
    load = function(plug)
        utils.lazy_plugin('blink.cmp', plug.spec.name, function()
            require('blink.cmp').setup(require('r.plugins.completion').blink_opts)
        end)
        utils.lazy_event({ 'InsertEnter', 'CmdlineEnter' }, 'blink.cmp')
    end,
    confirm = false,
})

utils.plugin_hook('luasnip', 'UpdateLuaSnip', function(ev)
    vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path })
end)
