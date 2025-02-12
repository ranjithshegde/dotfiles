local setup = require('r.utils').plugin_setup

return {
    { 'p00f/clangd_extensions.nvim' },
    {
        'folke/trouble.nvim',
        opts = require 'r.plugins.lsp.trouble',
        cmd = 'Trouble',
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
        init = function()
            local id = { OrgMode = vim.api.nvim_create_augroup('LazyDev', { clear = true }) }

            vim.api.nvim_create_autocmd('FileType', {
                group = id.LazyDev,
                pattern = 'lua',
                once = true,
                callback = function()
                    require('blink.cmp').add_provider('lazydev', {
                        name = 'Lazydev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    })
                end,
                desc = 'Add lazydev completion source',
            })

            require('r.utils').register_au_id(id)
        end,
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
                    config = setup 'r.plugins.lsp.servers.linters_formatters',
                },
            },
        },
        init = setup('r.plugins.lsp.handlers', 'init'),
        config = setup 'r.plugins.lsp.servers',
    },
}
