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
                    { 'd', mode = { 'n', 'v', 'o' } },
                    { 'a', mode = { 'n', 'v', 'o' } },
                    { 'c', mode = { 'n', 'v', 'o' } },
                    { 's', mode = { 'n', 'v', 'o' } },
                },
            }
        end)
    end,
})

add({
    'https://github.com/nvim-mini/mini.nvim',
}, {
    load = function(plug)
        utils.lazy_plugin('mini', plug.spec.name)
        vim.schedule(function()
            require('mini.base16').setup {
                palette = require('r.framework.palettes').nekonight_moon,
                use_cterm = true,
            }
            -- vim.cmd [[
            --     hi Normal guibg=NONE
            --     hi NormalFloat guibg=NONE
            --     hi NormalNC guibg=NONE
            -- ]]
        end)
    end,
})

add({ 'https://github.com/nvim-lua/plenary.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('plenary', plug.spec.name)
    end,
    confirm = false,
})
