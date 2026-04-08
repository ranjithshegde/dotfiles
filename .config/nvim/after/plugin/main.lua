local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/numToStr/Comment.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('Comment', plug.spec.name, function()
            require('Comment').setup { ignore = '^$' }
        end)

        utils.lazy_on_key({ 'n', 'v' }, 'gc', 'Toggle comment', function()
            require 'Comment'
        end)

        utils.lazy_on_key({ 'n', 'v' }, 'gb', 'Toggle comment block', function()
            require 'Comment'
        end)
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
