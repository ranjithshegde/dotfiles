local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/numToStr/Comment.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('Comment', plug.spec.name, function()
            require('Comment').setup { ignore = '^$' }
        end)

        utils.lazy_on_key({ 'n', 'v' }, 'gc', 'Toggle comment', function()
            require 'Comment'
        end, true)

        utils.lazy_on_key({ 'n', 'v' }, 'gb', 'Toggle comment block', function()
            require 'Comment'
        end, true)
    end,
    confirm = false,
})

add({ 'https://github.com/kylechui/nvim-surround' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-surround', plug.spec.name, function()
            require('r.plugins.surround').config()
        end)

        local surround_keys = {
            { mode = 'n', key = 'cs', desc = 'Change surround' },
            { mode = 'n', key = 'ds', desc = 'Delete surround' },
            { mode = 'n', key = 'gss', desc = 'Surround current line' },
            { mode = { 'n', 'v' }, key = 'gs', desc = 'Add surround (normal/visual)' },
            { mode = 'v', key = 'gS', desc = 'Add surround (visual linewise)' },
        }

        for _, item in ipairs(surround_keys) do
            utils.lazy_on_key(item.mode, item.key, item.desc, function()
                require 'nvim-surround'
            end, true)
        end

        require('r.plugins.surround').init()
    end,
    confirm = false,
})

add({ 'https://github.com/Bekaboo/dropbar.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('dropbar', plug.spec.name, function()
            require('dropbar').setup {
                sources = {
                    treesitter = {
                        valid_types = require('r.utils.tables').tsNodes,
                    },
                },
                icons = {
                    kinds = {
                        symbols = require('r.utils.tables').nodeSymbols,
                    },
                },
            }
        end)
        utils.lazy_event('BufReadPost', 'dropbar')
    end,
    confirm = false,
})

add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('render-markdown', plug.spec.name, function()
            require('render-markdown').setup {
                file_types = { 'markdown', 'codecompanion' },
                completions = { blink = { enabled = true } },
                document = { render_modes = true },
            }
        end)
        utils.lazy_event('FileType', 'render-markdown', { 'markdown', 'codecompanion' })
    end,
    confirm = false,
})

add({ 'https://github.com/MayaFlux/lila.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('lila', plug.spec.name, true)
    end,
    confirm = false,
})
