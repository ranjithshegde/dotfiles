local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-autopairs', plug.spec.name, function()
            vim.print 'Setting up autopairs...'
            require('r.plugins.completion').pairs()
        end)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/rafamadriz/friendly-snippets' }, {
    load = function(plug)
        utils.lazy_plugin('friendly-snippets', plug.spec.name)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/L3MON4D3/LuaSnip' }, {
    load = function(plug)
        utils.lazy_plugin('luasnip', plug.spec.name, function()
            require('r.plugins.completion').luasnip()
        end)
    end,
    confirm = false,
})

vim.pack.add({ { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '^1' } }, {
    load = function(plug)
        utils.lazy_plugin('blink.cmp', plug.spec.name, function()
            require('blink.cmp').setup(require('r.plugins.completion').blink_opts)
        end)
        utils.lazy_event({ 'InsertEnter', 'CmdlineEnter' }, 'blink.cmp')
    end,
    confirm = false,
})

local id = { PackUpdateHook = vim.api.nvim_create_augroup('UpdateLuaSnip', { clear = true }) }

local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
        vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path })
    end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks, group = id.PackUpdateHook })

utils.register_au_id(id)
