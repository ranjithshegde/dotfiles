local wk = require 'which-key'
local mapper = require 'r.utils.expand_maps'
local lspmap = {}
local map = vim.keymap.set

local function c_cmd(cmd, args)
    return function()
        vim.cmd[cmd](args)
    end
end

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
                m = { c_cmd('CclsMemberHierarchy', { args = { 'float' } }), 'Member variables' },
                f = { c_cmd('CclsMemberFunctionHierarchy', { args = { 'float' } }), 'Member functions' },
                t = { c_cmd('CclsMemberTypeHierarchy', { args = { 'float' } }), 'Member classes' },
            },
            H = {
                name = 'hierarchy',
                b = { c_cmd('CclsBaseHierarchy', { args = { 'float' } }), 'Base function' },
                c = { c_cmd('CclsIncomingCallsHierarchy', { args = { 'float' } }), 'Caller' },
                C = { c_cmd('CclsOutgoingCallsHierarchy', { args = { 'float' } }), 'Callee' },
                d = { c_cmd('CclsDerivedHierarchy', { args = { 'float' } }), 'Derived functions' },
            },
        },
    }, { buffer = buf }))
end

function lspmap.clangd(buf)
    map('n', 'sa', vim.cmd.ClangdSwitchSourceHeader, { desc = 'Switch to header/source/alternate', buffer = buf })
    map('n', 'smi', vim.cmd.ClangdShowSymbolInfo, { desc = 'Show symbol info', buffer = buf })
end

return lspmap
