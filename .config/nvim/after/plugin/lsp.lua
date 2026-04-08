local utils = require 'r.utils'

local add = vim.pack.add

add({ 'https://github.com/folke/trouble.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('trouble', plug.spec.name, function()
            require('trouble').setup(require('r.plugins.lsp.trouble').config())
        end)
        utils.lazy_command('Trouble', 'trouble')
    end,
    confirm = false,
})

add({ { src = 'https://github.com/neovim/nvim-lspconfig', name = 'lspconfig' } }, {
    load = function(plug)
        utils.lazy_plugin('lspconfig', plug.spec.name, function()
            require 'r.plugins.lsp.servers'()
        end)
        utils.lazy_event('FileType', 'lspconfig', require('r.utils.tables').lspfiles)
    end,
    confirm = false,
})

add({ 'https://github.com/saecki/live-rename.nvim' }, {
    load = function() end,
    confirm = false,
})

add({ 'https://github.com/ranjithshegde/ccls.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('ccls', plug.spec.name, function()
            require 'r.plugins.lsp.servers.ccls'()
        end)
        utils.lazy_event('FileType', 'ccls', { 'c', 'cpp', 'opencl' })
    end,
    confirm = false,
})

require('r.plugins.lsp.handlers').init()
require('r.plugins.lsp.trouble').init()
