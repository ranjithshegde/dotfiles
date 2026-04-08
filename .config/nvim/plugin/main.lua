local utils = require 'r.utils'
local add = vim.pack.add

add({ 'https://github.com/folke/which-key.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('which-key', plug.spec.name, function()
            require('which-key').setup {
                preset = 'modern',
                show_help = false,
                show_keys = false,
                layout = { spacing = 10 },
                triggers = {
                    { '<auto>', mode = 'nixsotc' },
                    { 'c', mode = { 'n', 'v' } },
                    { 's', mode = { 'n', 'v' } },
                },
            }
        end)

        local triggers = { '<auto>', 'c', 's' }
        for _, t in ipairs(triggers) do
            utils.lazy_on_key({ 'n', 'v' }, t, 'which-key', function() end, 'Load which-key')
        end
    end,
})

add({
    { src = 'https://github.com/neko-night/nvim', name = 'nekonight' },
}, {
    load = function(plug)
        utils.lazy_plugin('nekonight', plug.spec.name, function()
            require('nekonight').setup {
                transparent = true,
                on_highlights = function(hl, c)
                    hl.Folded = { bg = c.bg_dark1 }
                end,
            }
        end)
        vim.cmd.colorscheme 'nekonight-moon'
    end,
})

add({ 'https://github.com/nvim-lua/plenary.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('plenary', plug.spec.name)
    end,
    confirm = false,
})
