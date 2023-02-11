return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = require('r.utils').plugin_setup('r.plugins.treesitter.settings', 'setup'),
        init = require('r.utils').plugin_setup('r.plugins.treesitter.settings', 'autocmds'),
    },
    { 'p00f/nvim-ts-rainbow', event = 'BufReadPre' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    {
        'ThePrimeagen/refactoring.nvim',
        config = require('r.utils').plugin_setup('r.plugins.treesitter.settings', 'refactoring'),
    },
    { 'Badhi/nvim-treesitter-cpp-tools', ft = { 'c', 'cpp', 'opencl' } },
}
