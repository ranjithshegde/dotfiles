return {
    {
        'mfussenegger/nvim-dap',
        init = require('r.utils').plugin_setup('r.plugins.debug.settings', 'init'),
        config = require('r.utils').plugin_setup('r.plugins.debug.settings', 'setup'),
        dependencies = { { 'theHamsta/nvim-dap-virtual-text', config = true } },
    },
    {
        'rcarriga/nvim-dap-ui',
        config = function()
            require('dapui').setup {
                layouts = {
                    {
                        elements = { 'scopes', 'breakpoints', 'stacks', 'watches' },
                        size = 70,
                        position = 'left',
                    },
                    {
                        elements = { 'repl', 'console' },
                        size = 0.25,
                        position = 'bottom',
                    },
                },
            }
        end,
    },
}
