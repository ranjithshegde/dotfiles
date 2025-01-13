------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

return require('which-key').add(require 'r.utils.expand_maps' {
    ['<leader>d'] = {
        name = 'debug',
        b = { require('dap').toggle_breakpoint, 'set breakpoint' },
        x = { require('dap').set_exception_breakpoints, 'set breakpoint' },
        o = { require('dapui').float_element, 'Open float element', mode = { 'n', 'v' } },
        E = { require('r.plugins.debug.settings').exp.toggle, 'Expressions buffer', mode = { 'n', 'v', 's' } },
        ['.'] = { require('dap').terminate, 'End' },
        ['?'] = { require('r.plugins.debug.settings').frames.toggle, 'Frames' },
        ['/'] = { require('r.plugins.debug.settings').scopes.toggle, 'Scopes' },
        t = { require('r.plugins.debug.settings').threads.toggle, 'threads' },
        u = { require('dapui').toggle, 'Toggle all UI' },
        c = { require('dap').continue, 'continue to next breakpoint' },
        n = { require('dap').step_over, 'step over' },
        s = { require('dap').step_into, 'step into' },
        S = { require('dap').step_out, 'step Out' },
        e = { require('dapui').eval, 'Evaluate Hover', mode = { 'n', 'v', 's' } },
        f = {
            function()
                require('dapui').float_element('scopes', { enter = true })
            end,
            'Floating Scopes',
        },
        F = {
            function()
                require('dapui').float_element('stacks', { enter = true })
            end,
            'Floating Stacks',
        },
        B = {
            function()
                require('dap').toggle_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end,
            'set breakpoint',
        },
    },
    ['<F10>'] = {
        function()
            require('dap').repl.toggle({ height = 10 }, 'split')
        end,
        'Repl Toggle',
    },
})
