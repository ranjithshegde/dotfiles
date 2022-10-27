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
            i = { vim.lsp.buf.implementation, 'Jump to Implementation' },
            a = { vim.lsp.buf.code_action, 'Code actions for buffer', mode = { 'n', 'v' } },
            D = {
                function()
                    vim.lsp.buf.declaration { reuse_win = true }
                end,
                'Jump to Declaration',
            },
            d = {
                function()
                    vim.lsp.buf.definition { reuse_win = true }
                end,
                'Jump to Definition',
            },
            t = {
                function()
                    vim.lsp.buf.type_definition { reuse_win = true }
                end,
                'Jump to Type definition',
            },
            r = {
                function()
                    vim.lsp.buf.references { includeDeclaration = false }
                end,
                'References',
            },
            c = {
                name = 'Codelens',
                c = { vim.lsp.codelens.display, 'Display' },
                r = { vim.lsp.codelens.run, 'Run' },
                R = { vim.lsp.codelens.refresh, 'Refresh' },
                g = { vim.lsp.codelens.get, 'Fetch' },
            },
            l = {
                name = 'Toggle diagnostics',
                v = { require('r.extensions.diagnostics').toggle_virtual_text, 'Virtual text' },
                s = { require('r.extensions.diagnostics').toggle_signs, 'Sings' },
                u = { require('r.extensions.diagnostics').toggle_underline, 'Underline' },
            },
            w = {
                name = 'Workspace',
                a = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
                r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
                l = {
                    function()
                        vim.pretty_print(vim.lsp.buf.list_workspace_folders())
                    end,
                    'List workspace folder',
                },
            },
        },
    }, { buffer = bufnr })

    map('n', '<F1>', function()
        require('overseer').window.toggle { enter = false }
    end, { desc = 'Open Task panel' })
end

-- ******************************** Diagnostics------------------------

function lspmap.diagnostic(bufnr)
    map('n', ',ld', vim.diagnostic.open_float, { desc = 'Show line diagnostics', buffer = bufnr })
    map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Show previous diagnostics', buffer = bufnr })
    map('n', ']d', vim.diagnostic.goto_next, { desc = 'Show next diagnostics', buffer = bufnr })
end

------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

function lspmap.debug()
    wk.register({
        ['<leader>'] = {
            d = {
                name = 'debug',
                b = { require('dap').toggle_breakpoint, 'set breakpoint' },
                x = { require('dap').set_exception_breakpoints, 'set breakpoint' },
                o = { require('dapui').float_element, 'Open float element', mode = { 'n', 'v' } },
                E = { require('r.debuggers').exp.toggle, 'Expressions buffer', mode = { 'n', 'v', 's' } },
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
        },
    }, { buffer = 0 })
    wk.register {
        ['<leader>d'] = {
            name = 'debug',
            ['.'] = { require('dap').terminate, 'End' },
            ['?'] = { require('r.debuggers').frames.toggle, 'Frames' },
            ['/'] = { require('r.debuggers').scopes.toggle, 'Scopes' },
            t = { require('r.debuggers').threads.toggle, 'threads' },
            u = { require('dapui').toggle, 'Toggle all UI' },
            c = { require('dap').continue, 'continue to next breakpoint' },
            n = { require('dap').step_over, 'step over' },
            s = { require('dap').step_into, 'step into' },
            S = { require('dap').step_out, 'step Out' },
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
