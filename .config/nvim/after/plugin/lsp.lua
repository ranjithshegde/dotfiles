local utils = require 'r.utils'
local setup = utils.plugin_setup

-- local lua_src = { inherit_defaults = true, 'lazydev' }

-- local pd_lua = {
--     'saghen/blink.cmp',
--     opts = { sources = { per_filetype = { lua = lua_src, pd_lua = lua_src } } },
-- }

vim.pack.add({ 'https://github.com/folke/trouble.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('trouble', plug.spec.name, function()
            require('trouble').setup(require('r.plugins.lsp.trouble').config())
        end)
        utils.lazy_command('Trouble', 'trouble')
    end,
    confirm = false,
})

vim.pack.add({ { src = 'https://github.com/neovim/nvim-lspconfig', name = 'lspconfig' } }, {
    load = function(plug)
        utils.lazy_plugin('lspconfig', plug.spec.name, function()
            setup 'r.plugins.lsp.servers'()
        end)
        utils.lazy_event('FileType', 'lspconfig', require('r.utils.tables').lspfiles)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/nvimtools/none-ls.nvim' }, {
    load = function(plug)
        vim.cmd.packadd 'plenary.nvim'
        utils.lazy_plugin('null-ls', plug.spec.name, function()
            require 'r.plugins.lsp.servers.null_ls'()
        end)
        utils.lazy_event('FileType', 'null-ls', require('r.utils.tables').lspfiles)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/saecki/live-rename.nvim' }, {
    load = function() end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/ranjithshegde/ccls.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('ccls', plug.spec.name, function()
            setup('r.plugins.lsp.servers.clang', 'ccls')()
        end)
        utils.lazy_event('FileType', 'ccls', { 'c', 'cpp', 'opencl' })
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/folke/lazydev.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('lazydev', plug.spec.name, function()
            require('lazydev').setup {
                library = {
                    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                    { path = '/usr/lib/pd/extra/pdlua', words = { 'pd', 'pdx' } },
                },
            }
        end)
        utils.lazy_event('FileType', 'lazydev', { 'lua', 'pd_lua' })
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/Bilal2453/luvit-meta' }, {
    load = function(plug)
        utils.lazy_plugin('luvit-meta', plug.spec.name)
    end,
    confirm = false,
})

setup('r.plugins.lsp.handlers', 'init')()
setup('r.plugins.lsp.trouble', 'init')()
