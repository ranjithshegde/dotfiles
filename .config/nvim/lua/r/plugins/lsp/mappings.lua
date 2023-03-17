local lspmap = {}
local wk = require 'which-key'
local map = vim.keymap.set
------------------------------------------------------------------------
--                              Language servers                      --
------------------------------------------------------------------------

function lspmap.lsp(client, bufnr)
    if client.name == 'ltex' then
        return
    end
    map('n', 'K', function()
        local winid = package.loaded.ufo and require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
            if vim.bo[bufnr].filetype == 'org' then
                require('orgWiki.wiki').hover()
                return
            end
            vim.lsp.buf.hover()
        end
    end, { desc = 'Hover or peek-fold', buffer = bufnr })

    wk.register({
        [','] = {
            name = 'Lsp functions',
            s = { vim.lsp.buf.signature_help, 'Show signature' },
            D = {
                function()
                    vim.lsp.buf.declaration { reuse_win = true }
                end,
                'Jump to Declaration',
            },
            T = {
                function()
                    vim.lsp.buf.type_definition { reuse_win = true }
                end,
                'Jump to Type definition',
            },
            c = {
                name = 'Codelens',
                c = { vim.lsp.codelens.display, 'Display' },
                r = { vim.lsp.codelens.run, 'Run' },
                R = { vim.lsp.codelens.refresh, 'Refresh' },
                g = { vim.lsp.codelens.get, 'Fetch' },
            },
            l = {
                name = 'Diagnostic action',
                v = { require('r.extensions.diagnostics').toggle_virtual_text, 'Toggle Virtual text' },
                s = { require('r.extensions.diagnostics').toggle_signs, 'Toggle Sings' },
                u = { require('r.extensions.diagnostics').toggle_underline, 'Toggle Underline' },
            },
        },
    }, { buffer = bufnr })
end

-- ******************************** Diagnostics------------------------

function lspmap.diagnostic(bufnr)
    map('n', ',ld', vim.diagnostic.open_float, { desc = 'Show line diagnostics', buffer = bufnr })
    map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Show previous diagnostics', buffer = bufnr })
    map('n', ']d', vim.diagnostic.goto_next, { desc = 'Show next diagnostics', buffer = bufnr })
end

function lspmap.navic(bufnr)
    wk.register({
        [','] = {
            name = 'Lsp',
            r = { require('navigator.reference').async_ref, 'Lsp Async reference' },
            a = { require('navigator.codeAction').code_action, 'code_action' },
            i = { vim.lsp.buf.implementation, 'implementation' },
            d = { require('navigator.definition').definition, 'definition' },
            p = { require('navigator.definition').definition_preview, 'definition_preview' },
            ca = { require('navigator.codelens').run_action, 'run code lens action' },
            l = {
                name = 'Diagnostic action',
                l = { require('navigator.diagnostics').show_diagnostics, 'show_diagnostics' },
                b = { require('navigator.diagnostics').show_buf_diagnostics, 'buf diagnostics' },
            },
            C = {
                name = 'Calls',
                i = { vim.lsp.buf.incoming_calls, 'incoming_calls' },
                o = { vim.lsp.buf.outgoing_calls, 'outgoing_calls' },
            },
            t = {
                name = 'Treesitter',
                s = { require('navigator.treesitter').buf_ts, 'buf_ts' },
                S = { require('navigator.treesitter').bufs_ts, 'bufs_ts' },
            },
            w = {
                name = 'Workspace',
                a = { require('navigator.workspace').add_workspace_folder, 'Add workspace folder' },
                r = { require('navigator.workspace').remove_workspace_folder, 'Remove workspace folder' },
                l = { require('navigator.workspace').list_workspace_folders, 'List workspace folder' },
            },
        },
        [',a'] = { require('navigator.codeAction').range_code_action, 'range_code_action', mode = 'v' },
        [']r'] = { require('navigator.treesitter').goto_next_usage, 'next usage' },
        ['[r'] = { require('navigator.treesitter').goto_previous_usage, 'previous usage' },

        ['<leader>l'] = {
            name = 'Minimap',
            l = { require('navigator.symbols').side_panel, 'Lsp Symbols' },
            t = { require('navigator.treesitter').side_panel, 'Treesitter Symbols' },
            r = { require('navigator.reference').side_panel, 'Reference list' },
        },
    }, { buffer = bufnr })
end

function lspmap.tex(bufnr)
    map('n', '<F4>', function()
        require('r.plugins.lsp.texlab').tex_clean()
    end, { buffer = true, desc = 'Clean tex files' })

    map('n', '<F5>', vim.cmd.TexlabBuild, { buffer = bufnr, desc = 'Compile tex document' })
    map('n', '<F6>', vim.cmd.TexlabForward, { buffer = bufnr, desc = 'Launch zathura' })
end

return lspmap
