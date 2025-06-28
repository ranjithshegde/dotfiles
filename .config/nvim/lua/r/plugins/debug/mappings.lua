------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

return require('which-key').add(require 'r.utils.expand_maps' {
    -- Shift F6
    ['<F18>'] = { require('dap').continue, 'continue to next breakpoint' },
    ['<F11>'] = { require('dap').step_into, 'step into' },
    -- Shift F11
    ['<F23>'] = { require('dap').step_out, 'step Out' },
    ['<F10>'] = { require('dap').step_over, 'step over' },
    ['<F12>'] = { require('dap').terminate, 'End' },

    ['<leader>d'] = {
        name = 'debug',

        e = { require('dap.ui.widgets').hover, 'Evaluate Hover', mode = { 'n', 'v', 's' } },
        E = { require('r.plugins.debug.settings').exp.toggle, 'Expressions buffer', mode = { 'n', 'v', 's' } },
        f = { require('r.plugins.debug.settings').fframes, 'Floating Frames' },
        F = { require('r.plugins.debug.settings').frames.toggle, 'Frames' },
        s = { require('r.plugins.debug.settings').fscopes, 'Floating Scopes' },
        S = { require('r.plugins.debug.settings').scopes.toggle, 'Scopes' },
        t = { require('r.plugins.debug.settings').threads.toggle, 'threads' },

        r = { require('dap').restart, 'Restart current session' },
        R = { require('dap').run_last, 'Rerun last session' },
        x = { require('dap').set_exception_breakpoints, 'set breakpoint' },
        w = { require('dap-view').add_expr, 'Watch element' },
        b = { require('dap').toggle_breakpoint, 'set breakpoint' },
        B = {
            function()
                require('dap').toggle_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end,
            'set breakpoint',
        },
    },
})
