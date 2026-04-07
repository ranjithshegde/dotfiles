local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-treesitter', plug.spec.name)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-treesitter-textobjects', plug.spec.name, function()
            require('r.plugins.treesitter.settings').text_objects()
        end)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/ThePrimeagen/refactoring.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('refactoring', plug.spec.name, function()
            require('r.plugins.treesitter.settings').refactoring()
        end)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/ckolkey/ts-node-action' }, {
    load = function(plug)
        utils.lazy_plugin('ts-node-action', plug.spec.name, function()
            require('r.plugins.treesitter.settings').node_action()
        end)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/DanielMSussman/simpleCppTreesitterTools.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('simpleCppTreesitterTools', plug.spec.name, true)
        utils.lazy_event('FileType', 'simpleCppTreesitterTools', 'cpp')
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/HiPhish/rainbow-delimiters.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('rainbow-delimiters', plug.spec.name)
        utils.lazy_event('BufReadPre', 'rainbow-delimiters')
    end,
    confirm = false,
})

local id = { PackUpdateHook = vim.api.nvim_create_augroup('UpdateLuaSnip', { clear = true }) }

local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
        vim.cmd.TSUpdate()
    end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks, group = id.PackUpdateHook })

utils.register_au_id(id)

require('r.plugins.treesitter.settings').autocmds()
