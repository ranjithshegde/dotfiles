local utils = require 'r.utils'
local ui = require 'r.plugins.ui'

vim.pack.add({ 'https://github.com/MunifTanjim/nui.nvim' }, {
    load = function(plug)
        require('r.utils').lazy_plugin('nui', plug.spec.name)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/folke/noice.nvim' }, {
    load = function(plug)
        require('r.utils').lazy_plugin('noice', plug.spec.name, function()
            vim.cmd.packadd 'nui.nvim'
            require('noice').setup(ui.noice_opts)
        end)

        utils.lazy_event('VimEnter', 'noice')

        ui.noice_init()
    end,
    confirm = false,
})
