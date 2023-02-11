return {
    {
        'nvim-telescope/telescope.nvim',
        init = function()
            require('r.utils').lazy_on_key('n', '<Space>', 'Telescope', require, 'r.plugins.telescope.mappings')
        end,
        cmd = 'Telescope',
        dependencies = 'nvim-lua/plenary.nvim',
        config = require('r.utils').plugin_setup('r.plugins.telescope.settings', 'telescope'),
    },
    'nvim-telescope/telescope-project.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
