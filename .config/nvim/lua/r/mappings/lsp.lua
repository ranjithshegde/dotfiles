local lspmap = {}
local wk = require "which-key"
local map = vim.keymap.set
------------------------------------------------------------------------
--                              Language servers                      --
------------------------------------------------------------------------

function lspmap.lsp(client, bufnr)
    if client.name == "ltex" then
        return
    end
    vim.keymap.set("n", "K", function()
        local winid = package.loaded.ufo and require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, { desc = "Hover or peek-fold", buffer = bufnr })

    vim.keymap.set({ "n", "v" }, ",a", vim.lsp.buf.code_action, { desc = "Code actions for buffer", buffer = bufnr })

    wk.register({
        ["<F7>"] = { require("r.debugger").init, "Initialize Debugger adapter" },
        [","] = {
            name = "Lsp functions",
            s = { vim.lsp.buf.signature_help, "Show signature" },
            i = { vim.lsp.buf.implementation, "Jump to Implementation" },
            D = {
                function()
                    vim.lsp.buf.declaration { reuse_win = true }
                end,
                "Jump to Declaration",
            },
            d = {
                function()
                    vim.lsp.buf.definition { reuse_win = true }
                end,
                "Jump to Definition",
            },
            t = {
                function()
                    vim.lsp.buf.type_definition { reuse_win = true }
                end,
                "Jump to Type definition",
            },
            r = {
                function()
                    vim.lsp.buf.references { includeDeclaration = false }
                end,
                "References",
            },
            c = {
                name = "Codelens",
                c = { vim.lsp.codelens.display, "Display" },
                r = { vim.lsp.codelens.run, "Run" },
                R = { vim.lsp.codelens.refresh, "Refresh" },
                g = { vim.lsp.codelens.get, "Fetch" },
            },
            l = {
                name = "Toggle diagnostics",
                v = { require("r.utils.diagnostics").toggle_virtual_text, "Virtual text" },
                s = { require("r.utils.diagnostics").toggle_signs, "Sings" },
                u = { require("r.utils.diagnostics").toggle_underline, "Underline" },
            },
            w = {
                name = "Workspace",
                a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
                r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
                l = {
                    function()
                        vim.pretty_print(vim.lsp.buf.list_workspace_folders())
                    end,
                    "List workspace folder",
                },
            },
        },
    }, { buffer = bufnr })

    map("n", "<F1>", function()
        require("overseer").window.toggle { enter = false }
    end, { desc = "Open Task panel" })

    map("n", "<F11>", function()
        require("symbols-outline").toggle_outline()
    end, { desc = "Toggle Symbolsbar" })
end

-- ******************************** Diagnostics------------------------

function lspmap.diagnostic(bufnr)
    map("n", ",ld", vim.diagnostic.open_float, { desc = "Show line diagnostics", buffer = bufnr })
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "Show previous diagnostics", buffer = bufnr })
    map("n", "]d", vim.diagnostic.goto_next, { desc = "Show next diagnostics", buffer = bufnr })
end

------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

function lspmap.debug()
    wk.register({
        ["<leader>"] = {
            d = {
                name = "debug",
                b = { require("dap").toggle_breakpoint, "set breakpoint" },
                x = { require("dap").set_exception_breakpoints, "set breakpoint" },
                f = {
                    function()
                        require("dapui").float_element("scopes", { enter = true })
                    end,
                    "Floating Scopes",
                },
                F = {
                    function()
                        require("dapui").float_element("stacks", { enter = true })
                    end,
                    "Floating Stacks",
                },
                B = {
                    function()
                        require("dap").toggle_breakpoint(vim.fn.input "Breakpoint condition: ")
                    end,
                    "set breakpoint",
                },
            },
        },
    }, { buffer = 0 })
    wk.register {
        ["<leader>d"] = {
            name = "debug",
            ["."] = { require("dap").terminate, "End" },
            ["?"] = { require("r.debugger").frames.toggle, "Frames" },
            ["/"] = { require("r.debugger").scopes.toggle, "Scopes" },
            t = { require("r.debugger").threads.toggle, "threads" },
            u = { require("dapui").toggle, "Toggle all UI" },
            c = { require("dap").continue, "continue to next breakpoint" },
            n = { require("dap").step_over, "step over" },
            s = { require("dap").step_into, "step into" },
            S = { require("dap").step_out, "step Out" },
        },
        ["<F10>"] = {
            function()
                require("dap").repl.toggle({ height = 10 }, "split")
            end,
            "Repl Toggle",
        },
    }

    map({ "n", "v", "s" }, "<leader>de", function()
        require("dapui").eval()
        require("dapui").eval()
    end, { buffer = true, desc = "Evaluate Hover " })

    map({ "n", "v" }, "<leader>do", require("dapui").float_element, { buffer = true, desc = "Open floating elements" })

    map({ "n", "v", "s" }, "<leader>dE", require("r.debugger").exp.toggle, { buffer = true, desc = "Expressions" })
end

return lspmap
