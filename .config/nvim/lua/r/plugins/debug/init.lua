return {
    {
        'mfussenegger/nvim-dap',
        init = require('r.utils').plugin_setup('r.plugins.debug.settings', 'init'),
        config = require('r.utils').plugin_setup('r.plugins.debug.settings', 'setup'),
        dependencies = {
            { 'theHamsta/nvim-dap-virtual-text', config = true },
            { 'igorlfs/nvim-dap-view', opts = {} },
        },
    },
}
