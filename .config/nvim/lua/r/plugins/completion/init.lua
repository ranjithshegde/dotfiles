local setup = require('r.utils').plugin_setup

return {
    {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = 'rafamadriz/friendly-snippets',
        config = setup('r.plugins.completion.settings', 'luasnip'),
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            {
                'windwp/nvim-autopairs',
                config = setup('r.plugins.completion.settings', 'pairs'),
            },
        },
        config = setup('r.plugins.completion.settings', 'init'),
    },
}
