local lspmap = {}
local wk = require 'which-key'
local map = vim.keymap.set
local mapper = require 'r.utils.expand_maps'
------------------------------------------------------------------------
--                              Language servers                      --
------------------------------------------------------------------------

function lspmap.lsp(client, bufnr)
    if client.name == 'ltex' then
        return
    end
    map('n', 'K', function()
        if vim.bo[bufnr].filetype == 'org' then
            require('orgWiki.wiki').hover()
            return
        end
        vim.lsp.buf.hover()
    end, { desc = 'Hover or peek-fold', buffer = bufnr })

    wk.add(mapper({
        [','] = {
            name = 'Lsp functions',
            s = { vim.lsp.buf.signature_help, 'Show signature' },
            a = { vim.lsp.buf.code_action, 'Code action', mode = { 'n', 'v' } },
            c = {
                name = 'Codelens',
                c = { vim.lsp.codelens.display, 'Display' },
                r = { vim.lsp.codelens.run, 'Run' },
                R = { vim.lsp.codelens.refresh, 'Refresh' },
                g = { vim.lsp.codelens.get, 'Fetch' },
            },
            C = {
                name = 'Calls',
                i = { vim.lsp.buf.incoming_calls, 'incoming_calls' },
                o = { vim.lsp.buf.outgoing_calls, 'outgoing_calls' },
            },
            w = {
                name = 'Workspace',
                a = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
                r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
                l = { vim.lsp.buf.list_workspace_folders, 'List workspace folder' },
            },
            l = {
                name = 'Diagnostic action',
                v = { require('r.extensions.diagnostics').toggle_virtual_text, 'Toggle Virtual text' },
                s = { require('r.extensions.diagnostics').toggle_signs, 'Toggle Sings' },
                u = { require('r.extensions.diagnostics').toggle_underline, 'Toggle Underline' },
                d = { vim.diagnostic.open_float, 'Show line diagnostics' },
            },
        },
        g = {
            name = 'Go to',
            I = { vim.lsp.buf.implementation, 'implementation' },
            r = { vim.lsp.buf.references, 'Lsp Async reference' },
            d = { vim.lsp.buf.definition, 'definition' },
            D = {
                function()
                    vim.lsp.buf.declaration { reuse_win = true }
                end,
                'Go to Declaration',
            },
            y = {
                function()
                    vim.lsp.buf.type_definition { reuse_win = true }
                end,
                'Go to Type definition',
            },
        },
    }, { buffer = bufnr }))
end

function lspmap.tex(bufnr)
    map('n', '<F4>', function()
        require('r.plugins.lsp.texlab').tex_clean()
    end, { buffer = true, desc = 'Clean tex files' })

    map('n', '<F5>', vim.cmd.TexlabBuild, { buffer = bufnr, desc = 'Compile tex document' })
    map('n', '<F6>', vim.cmd.TexlabForward, { buffer = bufnr, desc = 'Launch zathura' })
end

return lspmap
