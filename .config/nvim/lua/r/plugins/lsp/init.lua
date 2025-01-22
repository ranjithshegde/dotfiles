local setup = require('r.utils').plugin_setup

return {
    { 'p00f/clangd_extensions.nvim' },
    {
        'dnlhc/glance.nvim',
        cmd = 'Glance',
        config = function()
            local glance = require 'glance'
            local actions = glance.actions
            glance.setup {
                border = { enable = true },
                mappings = { list = { ['<leader>s'] = actions.enter_win 'preview' } },
            }
        end,
    },
    {
        'folke/lazydev.nvim',
        dependencies = 'Bilal2453/luvit-meta',
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
        config = setup('r.plugins.lsp.clang', 'ccls'),
    },
    {
        'neovim/nvim-lspconfig',
        ft = require('r.utils.tables').lspfiles,
        dependencies = {
            {
                {
                    'nvimtools/none-ls.nvim',
                    config = setup 'r.plugins.lsp.linters_formatters',
                },
            },
        },
        init = setup('r.plugins.lsp.handlers', 'init'),
        config = setup 'r.plugins.lsp.servers',
    },
}
