local setup = require('r.utils').plugin_setup

return {
    {
        'saghen/blink.cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        version = 'v0.*',
        config = setup('r.plugins.completion.settings', 'blink'),
        opts_extend = { 'sources.per_filetype' },
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
