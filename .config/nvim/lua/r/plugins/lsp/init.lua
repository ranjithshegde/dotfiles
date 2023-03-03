local setup = require('r.utils').plugin_setup

return {
    { 'p00f/clangd_extensions.nvim' },
    { 'Hoffs/omnisharp-extended-lsp.nvim', ft = 'cs' },
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
                'jose-elias-alvarez/null-ls.nvim',
                config = setup 'r.plugins.lsp.linters_formatters',
            },
        },
        init = setup('r.plugins.lsp.handlers', 'init'),
        config = setup 'r.plugins.lsp.servers',
    },
}
