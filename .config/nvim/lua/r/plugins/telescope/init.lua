return {
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = 'nvim-lua/plenary.nvim',
        config = require('r.utils').plugin_setup('r.plugins.telescope.settings', 'telescope'),
        init = function()
            require 'r.plugins.telescope.mappings'
        end,
    },
    'nvim-telescope/telescope-project.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
