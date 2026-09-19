local utils = require 'r.utils'

vim.pack.add({ { src = 'https://github.com/stevearc/overseer.nvim', version = 'v1.6.0' } }, {
    load = function(plug)
        utils.lazy_plugin('overseer', plug.spec.name, function()
            require('overseer').setup {
                templates = { 'builtin', 'r' },
                default_template_prompt = 'avoid',
            }

            vim.keymap.set('n', '<Space>a', vim.cmd.OverseerQuickAction, { desc = 'Overseer task action list' })
        end)

        require('r.plugins.tasks.register').init()
    end,
    confirm = false,
})
