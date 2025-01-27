local lspmap = {}
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
        ['-'] = { trouble('toggle', 'quickfix'), 'Toggle qflist' },
        ['_'] = { trouble('toggle', 'loclist'), 'Toggle loclist' },
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
