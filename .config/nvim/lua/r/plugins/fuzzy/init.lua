return {
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cmd = 'FzfLua',
        config = require('r.utils').plugin_setup('r.plugins.fuzzy.settings', 'setup'),
        init = function()
            require 'r.plugins.fuzzy.mappings'
        end,
    },
}
