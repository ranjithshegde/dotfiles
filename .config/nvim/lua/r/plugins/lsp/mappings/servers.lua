local wk = require 'which-key'
local mapper = require 'r.utils.expand_maps'
local lspmap = {}
local map = vim.keymap.set

local function cmdl(cmd, args)
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
                m = { cmdl('CclsMemberHierarchy', { args = { 'float' } }), 'Member variables' },
                f = { cmdl('CclsMemberFunctionHierarchy', { args = { 'float' } }), 'Member functions' },
                t = { cmdl('CclsMemberTypeHierarchy', { args = { 'float' } }), 'Member classes' },
            },
            H = {
                name = 'hierarchy',
                b = { cmdl('CclsBaseHierarchy', { args = { 'float' } }), 'Base function' },
                c = { cmdl('CclsIncomingCallsHierarchy', { args = { 'float' } }), 'Caller' },
                C = { cmdl('CclsOutgoingCallsHierarchy', { args = { 'float' } }), 'Callee' },
                d = { cmdl('CclsDerivedHierarchy', { args = { 'float' } }), 'Derived functions' },
            },
        },
    }, { buffer = buf }))
end

function lspmap.clangd(buf)
    map('n', '<leader>s', vim.cmd.ClangdSwitchSourceHeader, { desc = 'Switch to header/source', buffer = buf })
end

return lspmap
