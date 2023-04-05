local setup = require('r.utils').plugin_setup

return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = setup('r.plugins.treesitter.settings', 'setup'),
        init = setup('r.plugins.treesitter.settings', 'autocmds'),
    },
    { 'p00f/nvim-ts-rainbow', event = 'BufReadPre' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    {
        'ThePrimeagen/refactoring.nvim',
        config = setup('r.plugins.treesitter.settings', 'refactoring'),
    },
    {
        'Badhi/nvim-treesitter-cpp-tools',
        ft = { 'c', 'cpp', 'opencl' },
        config = setup('r.plugins.treesitter.settings', 'cpp_tools'),
    },
    {
        'ckolkey/ts-node-action',
        config = setup('r.plugins.treesitter.settings', 'node_action'),
    },
}
