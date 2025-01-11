local setup = require('r.utils').plugin_setup

return {
    {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        dependencies = 'rafamadriz/friendly-snippets',
        config = setup('r.plugins.completion.settings', 'luasnip'),
    },
    {
        'saghen/blink.cmp',
        event = 'InsertEnter',
        version = 'v0.10.0',
        config = setup('r.plugins.completion.settings', 'init'),
        dependencies = {
            'windwp/nvim-autopairs',
            config = setup('r.plugins.completion.settings', 'pairs'),
        },
    },
}
