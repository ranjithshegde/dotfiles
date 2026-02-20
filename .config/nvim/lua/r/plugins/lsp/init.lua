local setup = require('r.utils').plugin_setup

local lua_src = { inherit_defaults = true, 'lazydev' }

return {
    {
        'folke/trouble.nvim',
        opts = require('r.plugins.lsp.trouble').config,
        init = setup('r.plugins.lsp.trouble', 'init'),
        cmd = 'Trouble',
    },
    -- { 'smjonas/inc-rename.nvim', config = true },
    { 'saecki/live-rename.nvim' },
    {
        'folke/lazydev.nvim',
        dependencies = {
            'Bilal2453/luvit-meta',
            {
                'saghen/blink.cmp',
                opts = { sources = { per_filetype = { lua = lua_src, pd_lua = lua_src } } },
            },
        },
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                { path = '/usr/lib/pd/extra/pdlua', words = { 'pd', 'pdx' } },
            },
        },
    },
    {
        'ranjithshegde/ccls.nvim',
        dev = true,
        ft = { 'c', 'cpp', 'opencl' },
        config = setup('r.plugins.lsp.servers.clang', 'ccls'),
    },
    {
        'neovim/nvim-lspconfig',
        ft = require('r.utils.tables').lspfiles,
        dependencies = {
            {
                {
                    'nvimtools/none-ls.nvim',
                    config = setup 'r.plugins.lsp.servers.null_ls',
                },
            },
        },
        init = setup('r.plugins.lsp.handlers', 'init'),
        config = setup 'r.plugins.lsp.servers',
    },
}
