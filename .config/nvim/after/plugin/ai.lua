local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/olimorris/codecompanion.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('codecompanion', plug.spec.name, function()
            require('codecompanion').setup {
                strategies = {
                    chat = { adapter = 'copilot' },
                    inline = { adapter = 'copilot' },
                    cmd = { adapter = 'copilot' },
                },
            }
        end)

        utils.lazy_command('CodeCompanionChat', 'codecompanion')
    end,
    confirm = false,
})
