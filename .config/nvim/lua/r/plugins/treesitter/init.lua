local setup = require('r.utils').plugin_setup

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        event = 'VeryLazy',
        build = ':TSUpdate',
        init = setup('r.plugins.treesitter.settings', 'autocmds'),
    },
    { 'HiPhish/rainbow-delimiters.nvim', event = 'BufReadPre' },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        config = setup('r.plugins.treesitter.settings', 'text_objects'),
    },
    {
        'ThePrimeagen/refactoring.nvim',
        config = setup('r.plugins.treesitter.settings', 'refactoring'),
    },
    {
        'ckolkey/ts-node-action',
        config = setup('r.plugins.treesitter.settings', 'node_action'),
    },
    {
        'DanielMSussman/simpleCppTreesitterTools.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ft = 'cpp',
        config = true,
    },
}
