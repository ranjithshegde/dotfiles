local wk = require 'which-key'
local map = vim.keymap.set
local mapper = require 'r.utils.expand_maps'

local function has_fzf()
    return package.loaded['fzf-lua']
end

local function trouble(action, mode)
    return function()
        require('trouble')[action] { mode = mode }
    end
end
------------------------------------------------------------------------
--                              Language servers                      --
------------------------------------------------------------------------

return function(client, bufnr)
    if client.name == 'ltex' then
        return
    end
    map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation', buffer = bufnr })

    map('n', '-', trouble('toggle', 'quickfix'), { desc = 'Toggle qflist' })
    map('n', '_', trouble('toggle', 'loclist'), { desc = 'Toggle loclist' })

    wk.add(mapper({
        s = {
            name = 'show',
            o = { trouble('open', 'symbols'), 'Symbol Outline' },
            M = { trouble('open', 'lsp'), 'Lsp Map' },
            k = { vim.lsp.buf.signature_help, 'Show signature' },
            l = {
                name = 'Codelens',
                r = { vim.lsp.codelens.refresh, 'Refresh' },
                g = { vim.lsp.codelens.get, 'Fetch' },
                s = { vim.lsp.codelens.display, 'Display' },
            },
            C = {
                name = 'Calls',
                i = { vim.lsp.buf.incoming_calls, 'incoming_calls' },
                o = { vim.lsp.buf.outgoing_calls, 'outgoing_calls' },
            },
            d = {
                name = 'Diagnostic action',
                v = { require('r.extensions.diagnostics').toggle_virtual_text, 'Toggle Virtual text' },
                s = { require('r.extensions.diagnostics').toggle_signs, 'Toggle Sings' },
                l = { require('r.extensions.diagnostics').toggle_lines, 'Toggle Lines' },
                u = { require('r.extensions.diagnostics').toggle_underline, 'Toggle Underline' },
                d = { vim.diagnostic.open_float, 'Show line diagnostics' },
            },
            w = {
                function()
                    vim.print(vim.lsp.buf.list_workspace_folders())
                end,
                'List workspace folder',
            },
        },
        g = {
            name = 'Go to',
            a = {
                name = 'Add or Apply',
                a = { vim.lsp.buf.code_action, 'Code action', mode = { 'n', 'v' } },
                w = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
                c = { vim.lsp.codelens.run, 'Run Codelens' },
            },
            R = {
                name = 'remove',
                r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
            },
            I = { vim.lsp.buf.implementation, 'implementation' },
            r = { trouble('open', 'lsp_references'), 'Lsp Async reference' },
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
            p = {
                name = 'preview',
                d = { trouble('open', 'lsp_definitions'), 'Peek definition' },
                t = { trouble('open', 'lsp_type_definitions'), 'Peek type definition' },
            },
            O = {
                function()
                    if has_fzf() then
                        require('fzf-lua').lsp_document_symbols { winopts = { row = 1, col = 0 } }
                    else
                        vim.lsp.buf.document_symbol()
                    end
                end,
                'Document symbol',
            },
        },
    }, { buffer = bufnr }))
end
