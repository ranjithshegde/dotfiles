local wk = require 'which-key'
local mapper = require 'r.utils.expand_maps'
local lspmap = {}
local map = vim.keymap.set

function lspmap.tex(bufnr)
    map('n', '<F4>', vim.cmd.TexlabCleanArtifacts, { buffer = true, desc = 'Clean tex files' })
    map('n', '<F5>', vim.cmd.TexlabBuild, { buffer = bufnr, desc = 'Compile tex document' })
    map('n', '<F6>', vim.cmd.TexlabForward, { buffer = bufnr, desc = 'Launch zathura' })
end

function lspmap.ccls(buf)
    wk.add(mapper({
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
            H = {
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

function lspmap.clangd(buf)
    map('n', '<leader>s', vim.cmd.ClangdSwitchSourceHeader, { desc = 'Switch to header/source', buffer = buf })

    map('n', '<leader>M', function()
        vim.cmd.tabnew(vim.b.makeFile)
    end, { desc = 'Open Makefile', buffer = buf })
end

return lspmap
