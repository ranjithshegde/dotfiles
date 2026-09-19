local utils = require 'r.utils'

vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' }, {
    load = function(plug)
        utils.lazy_plugin('fzf-lua', plug.spec.name, function()
            if not package.loaded['mini.icons'] then
                require('mini.icons').setup()
            end
            require('r.plugins.fzf.settings').setup()
        end)
        utils.lazy_command('FzfLua', 'fzf-lua')

        require('r.plugins.fzf.settings').init()
    end,
})
