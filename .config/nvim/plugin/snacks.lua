local utils = require 'r.utils'
local ui = require 'r.plugins.ui'

vim.pack.add({
    'https://github.com/folke/snacks.nvim',
}, { confirm = false })

ui.snacks_init()

vim.schedule(function()
    require('snacks').setup(ui.snacks_opts)
end)
