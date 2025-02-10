return {
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cmd = 'FzfLua',
        config = require('r.utils').plugin_setup('r.plugins.fzf.settings', 'setup'),
        init = require('r.utils').plugin_setup('r.plugins.fzf.settings', 'init'),
    },
}
