local wk = require 'which-key'
local maps = require 'r.utils.maps'
local cmap = {}

function cmap.ccls(buf)
    wk.add(maps.convert_maps({
        [';'] = {
            b = { vim.cmd.CclsBase, 'Base function' },
            c = { vim.cmd.CclsIncomingCalls, 'Callers' },
            C = { vim.cmd.CclsOutgoingCalls, 'Callees' },
            d = { vim.cmd.CclsDerived, 'Derived functions' },
            m = {
                function()
                    vim.cmd.CclsMemberHierarchy { args = { 'float' } }
                end,
                'Member variables',
            },
            F = {
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
            v = { vim.cmd.CclsVars, 'Variables in function' },
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
    wk.add(maps.convert_maps({
        [',h'] = {
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
