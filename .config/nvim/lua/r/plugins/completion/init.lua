local setup = require('r.utils').plugin_setup

return {
    {
        'saghen/blink.cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = 'v1.*',
        opts = require('r.plugins.completion.settings').blink_opts,
        opts_extend = {
            'sources.per_filetype',
            'sources.default',
        },
        dependencies = {
            {
                'windwp/nvim-autopairs',
                config = setup('r.plugins.completion.settings', 'pairs'),
            },
            {
                'L3MON4D3/LuaSnip',
                build = 'make install_jsregexp',
                dependencies = 'rafamadriz/friendly-snippets',
                config = setup('r.plugins.completion.settings', 'luasnip'),
            },
        },
    },
}
