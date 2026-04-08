local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' }, {
    load = function(plug)
        utils.lazy_plugin('fzf-lua', plug.spec.name, function()
            require('r.plugins.fzf.settings').setup()
        end)
        utils.lazy_command('FzfLua', 'fzf-lua')

        require('r.plugins.fzf.settings').init()
    end,
})

vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-web-devicons', plug.spec.name)
    end,
})
