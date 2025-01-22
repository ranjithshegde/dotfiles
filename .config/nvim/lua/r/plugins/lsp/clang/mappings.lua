local wk = require 'which-key'
local maps = require 'r.utils.expand_maps'
local cmap = {}

function cmap.ccls(buf)
    wk.add(maps({
        ['s'] = {
            name = 'Show',
            c = {
                name = 'ccls - Code Structure',
                b = { vim.cmd.CclsBase, 'Show Base Function' },
                c = { vim.cmd.CclsIncomingCalls, 'Show Callers' },
                C = { vim.cmd.CclsOutgoingCalls, 'Show Callees' },
                d = { vim.cmd.CclsDerived, 'Show Derived Functions' },
                v = { vim.cmd.CclsVars, 'Show Variables in Function' },
            },
            m = {
                name = 'ccls - Members',
                m = {
                    function()
                        vim.cmd.CclsMemberHierarchy { args = { 'float' } }
                    end,
                    'Member variables',
                },
                f = {
                    function()
                        vim.cmd.CclsMemberFunctionHierarchy { args = { 'float' } }
                    end,
                    'Member functions',
                },
                t = {
                    function()
                        vim.cmd.CclsMemberTypeHierarchy { args = { 'float' } }
                    end,
                    'Member classes',
                },
            },
            h = {
                name = 'hierarchy',
                b = {
                    function()
                        vim.cmd.CclsBaseHierarchy { args = { 'float' } }
                    end,
                    'Base function',
                },
                c = {
                    function()
                        vim.cmd.CclsIncomingCallsHierarchy { args = { 'float' } }
                    end,
                    'Caller',
                },
                C = {
                    function()
                        vim.cmd.CclsOutgoingCallsHierarchy { args = { 'float' } }
                    end,
                    'Callee',
                },
                d = {
                    function()
                        vim.cmd.CclsDerivedHierarchy { args = { 'float' } }
                    end,
                    'Derived functions',
                },
            },
        },
    }, { buffer = buf }))
end

function cmap.clangd(buf)
    wk.add(maps({
        ['cth'] = {
            function()
                require('clangd_extensions.inlay_hints').toggle_inlay_hints()
            end,
            'Toggle hints',
        },
        ['<leader>s'] = {
            vim.cmd.ClangdSwitchSourceHeader,
            'Switch to Header/Source',
        },
    }, { buffer = buf }))
end

return cmap
