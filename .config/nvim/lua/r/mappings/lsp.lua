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
        ['<F7>'] = { require('r.debuggers').init, 'Initialize debugger adapter' },
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

    map('n', '<F1>', function()
        require('overseer').window.toggle { enter = false }
    end, { desc = 'Open Task panel' })

    -- if not navigator then
    --     wk.register({
    --         [','] = {
    --             name = 'LSP functions',
    --             a = { vim.lsp.buf.code_action, 'Code actions for buffer', mode = { 'n', 'v' } },
    --             i = { vim.lsp.buf.implementation, 'Jump to Implementation' },
    --             w = {
    --                 name = 'Workspace',
    --                 a = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
    --                 r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
    --                 l = {
    --                     function()
    --                         vim.pretty_print(vim.lsp.buf.list_workspace_folders())
    --                     end,
    --                     'List workspace folder',
    --                 },
    --             },
    --             d = {
    --                 function()
    --                     vim.lsp.buf.definition { reuse_win = true }
    --                 end,
    --                 'Jump to Definition',
    --             },
    --             r = {
    --                 function()
    --                     vim.lsp.buf.references { includeDeclaration = false }
    --                 end,
    --                 'References',
    --             },
    --         },
    --     }, { buffer = bufnr })
    -- end
end

-- ******************************** Diagnostics------------------------

function lspmap.diagnostic(bufnr)
    map('n', ',ld', vim.diagnostic.open_float, { desc = 'Show line diagnostics', buffer = bufnr })
    map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Show previous diagnostics', buffer = bufnr })
    map('n', ']d', vim.diagnostic.goto_next, { desc = 'Show next diagnostics', buffer = bufnr })
end

function lspmap.navic(bufnr)
    -- map('n', ',r', require('navigator.reference').async_ref, { buffer = bufnr, desc = 'Lsp Async reference' })
    -- map('n', ',s', require('navigator.symbols').document_symbols, { buffer = bufnr, desc = 'document_symbols' })
    -- map('n', ',S', require('navigator.workspace').workspace_symbol_live, { buffer = bufnr, desc = 'workspace symbol' })
    -- map('n', ',d', require('navigator.definition').definition, { buffer = bufnr, desc = 'definition' })
    -- map('n', ',p', require('navigator.definition').definition_preview, { buffer = bufnr, desc = 'definition_preview' })
    -- map('n', '<Leader>gt', require('navigator.treesitter').buf_ts, { buffer = bufnr, desc = 'buf_ts' })
    -- map('n', '<Leader>gT', require('navigator.treesitter').bufs_ts, { buffer = bufnr, desc = 'bufs_ts' })
    -- map('n', ',a', require('navigator.codeAction').code_action, { buffer = bufnr, desc = 'code_action' })
    -- map('v', ',a', require('navigator.codeAction').range_code_action, { buffer = bufnr, desc = 'range_code_action' })
    -- map('n', ',Ci', vim.lsp.buf.incoming_calls, { buffer = bufnr, desc = 'incoming_calls' })
    -- map('n', ',Co', vim.lsp.buf.outgoing_calls, { buffer = bufnr, desc = 'outgoing_calls' })
    -- map('n', ',i', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'implementation' })
    -- map('n', ',ll', require('navigator.diagnostics').show_diagnostics, { buffer = bufnr, desc = 'show_diagnostics' })
    -- map('n', ',lb', require('navigator.diagnostics').show_buf_diagnostics, { buffer = bufnr, desc = 'buf diagnostics' })
    -- map('n', ']r', require('navigator.treesitter').goto_next_usage, { buffer = bufnr, desc = 'next usage' })
    -- map('n', '[r', require('navigator.treesitter').goto_previous_usage, { buffer = bufnr, desc = 'previous usage' })
    -- map( 'n', '<Leader>k',  require('navigator.dochighlight').hi_symbol, {desc = 'hi_symbol'} )
    -- map( 'n', '<Space>la', mode = 'n',  require('navigator.codelens').run_action, {desc = 'run code lens action'} )
    wk.register({
        [','] = {
            name = 'Lsp',
            -- { 's', require('navigator.symbols').document_symbols, 'document_symbols' },
            -- { 'S', require('navigator.workspace').workspace_symbol_live, 'workspace symbol' },
            -- '<Leader>gr' = {   require('navigator.reference').reference,  'eference' },
            -- '<Space>rn' = {   require('navigator.rename').rename, desc = 'rename'}
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
            -- r = { , 'Reference list' },
            -- "command! -nargs=* Calltree lua require'navigator.hierarchy'.calltree(<f-args>)<CR>",
        },
    }, { buffer = bufnr })
end

------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

function lspmap.debug()
    wk.register {
        ['<leader>d'] = {
            name = 'debug',
            b = { require('dap').toggle_breakpoint, 'set breakpoint' },
            x = { require('dap').set_exception_breakpoints, 'set breakpoint' },
            o = { require('dapui').float_element, 'Open float element', mode = { 'n', 'v' } },
            E = { require('r.debuggers').exp.toggle, 'Expressions buffer', mode = { 'n', 'v', 's' } },
            ['.'] = { require('dap').terminate, 'End' },
            ['?'] = { require('r.debuggers').frames.toggle, 'Frames' },
            ['/'] = { require('r.debuggers').scopes.toggle, 'Scopes' },
            t = { require('r.debuggers').threads.toggle, 'threads' },
            u = { require('dapui').toggle, 'Toggle all UI' },
            c = { require('dap').continue, 'continue to next breakpoint' },
            n = { require('dap').step_over, 'step over' },
            s = { require('dap').step_into, 'step into' },
            S = { require('dap').step_out, 'step Out' },
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
            e = {
                function()
                    require('dapui').eval()
                    require('dapui').eval()
                end,
                'Evaluate Hover',
                mode = { 'n', 'v', 's' },
            },
        },
        ['<F10>'] = {
            function()
                require('dap').repl.toggle({ height = 10 }, 'split')
            end,
            'Repl Toggle',
        },
    }
end

return lspmap
