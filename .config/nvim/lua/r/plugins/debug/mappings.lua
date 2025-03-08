------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

return require('which-key').add(require 'r.utils.expand_maps' {
    ['<leader>d'] = {
        name = 'debug',
        c = { require('dap').continue, 'continue to next breakpoint' },
        i = { require('dap').step_into, 'step into' },
        o = { require('dap').step_out, 'step Out' },
        O = { require('dap').step_over, 'step over' },
        ['.'] = { require('dap').terminate, 'End' },

        e = { require('dap.ui.widgets').hover, 'Evaluate Hover', mode = { 'n', 'v', 's' } },
        E = { require('r.plugins.debug.settings').exp.toggle, 'Expressions buffer', mode = { 'n', 'v', 's' } },
        f = { require('r.plugins.debug.settings').fframes, 'Floating Frames' },
        F = { require('r.plugins.debug.settings').frames.toggle, 'Frames' },
        s = { require('r.plugins.debug.settings').fscopes, 'Floating Scopes' },
        S = { require('r.plugins.debug.settings').scopes.toggle, 'Scopes' },
        t = { require('r.plugins.debug.settings').threads.toggle, 'threads' },

        x = { require('dap').set_exception_breakpoints, 'set breakpoint' },
        b = { require('dap').toggle_breakpoint, 'set breakpoint' },
        B = {
            function()
                require('dap').toggle_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end,
            'set breakpoint',
        },
    },
    ['<F10>'] = {
        function()
            require('dap').repl.toggle({ height = 15 }, 'split')
        end,
        'Repl Toggle',
    },
})
