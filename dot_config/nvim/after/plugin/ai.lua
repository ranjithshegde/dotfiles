local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/folke/sidekick.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('sidekick', plug.spec.name, true)
        utils.lazy_command('Sidekick', 'sidekick')

        vim.keymap.set('n', '<leader>ac', function()
            require('sidekick.cli').toggle { name = 'claude', focus = true }
        end, { desc = 'Sidekick: Claude' })

        vim.keymap.set('n', '<leader>ag', function()
            require('sidekick.cli').toggle { name = 'codex', focus = true }
        end, { desc = 'Sidekick: Codex' })
    end,
    confirm = false,
})
