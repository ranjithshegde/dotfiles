return {
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = 'nvim-lua/plenary.nvim',
        config = require('r.utils').plugin_setup('r.plugins.telescope.settings', 'telescope'),
        keys = { { '<Space>', desc = 'Telescope' } },
    },
    'nvim-telescope/telescope-project.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
