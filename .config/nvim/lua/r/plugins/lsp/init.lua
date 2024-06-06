local setup = require('r.utils').plugin_setup

return {
    { 'p00f/clangd_extensions.nvim' },
    {
        'folke/neodev.nvim',
        config = setup 'r.plugins.lsp.neodev',
    },
    {
        'ray-x/navigator.lua',
        dependencies = { { 'ray-x/guihua.lua', build = { 'cd lua/fzy && make' } } },
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
                    dependencies = {
                        'nvimtools/none-ls-extras.nvim',
                        'gbprod/none-ls-shellcheck.nvim',
                    },
                    config = setup 'r.plugins.lsp.linters_formatters',
                },
            },
        },
        init = setup('r.plugins.lsp.handlers', 'init'),
        config = setup 'r.plugins.lsp.servers',
    },
}
