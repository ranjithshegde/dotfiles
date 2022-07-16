local lsp = {}
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

local lspconfig = require "lspconfig"
local opts = { clear = true }

local nofmt = {
    "sumneko_lua",
    "jsonls",
}

local function filterfmt(client)
    return not vim.tbl_contains(nofmt, client.name)
end

---**************************** LSP AuGroups and Handlers
function lsp.settings()
    augroup("SetDiagnosticFuncs", opts)
    augroup("LspHighlightSymbols", opts)
    augroup("LspAutoFormat", opts)
    augroup("LspCodeLens", opts)

    aucmd({ "DiagnosticChanged" }, {
        group = "SetDiagnosticFuncs",
        callback = function()
            vim.diagnostic.setloclist { open = false }
        end,
        desc = "Send diagnostics to loclist on new errors",
    })

    -- Signature help always on top
    local function signature(_, result, ctx, config)
        local bufnr, winner = vim.lsp.handlers.signature_help(_, result, ctx, config)
        local current_cursor_line = vim.api.nvim_win_get_cursor(0)[1]

        if winner then
            if current_cursor_line > 3 then
                vim.api.nvim_win_set_config(winner, {
                    anchor = "SW",
                    relative = "cursor",
                    row = 0,
                    col = -1,
                    border = "rounded",
                    focusable = false,
                })
            end
        else
            vim.notify "No signature help available"
        end

        if bufnr and winner then
            return bufnr, winner
        end
    end

    -- borders for floating windows
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "double" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(signature, { focusable = false })

    require("utils.langServers").lsp_messages()
end

---**************************** Snippet capabilities
function lsp.capabilities()
    require("packer").loader "cmp-nvim-lsp"
    return require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

---**************************** Global attach function
function lsp.attach(client, bufnr)
    require("utils.langServers").lsp_progress()
    require("mappings.lsp").lsp(bufnr)
    vim.b.hasLsp = true

    local sc = client.server_capabilities

    if client.name == "ccls" then
        sc.completionProvider = false
        sc.documentFormattingProvider = false
        sc.documentRangeFormattingProvider = false
        sc.documentHighlightProvider = false
        sc.documentSymbolProvider = false
        sc.workspaceSymbolProvider = false
        sc.renameProvider = false
        sc.hoverProvider = false
        sc.codeActionProvider = false
        aucmd("BufWritePost", {
            buffer = bufnr,
            group = "LspCodeLens",
            callback = vim.lsp.codelens.refresh,
            desc = "Refresh codelens on save",
        })
        vim.lsp.codelens.refresh()
        vim.bo[bufnr].tagfunc = ""
        return
    end

    require("utils.diagnostics").attach({ all = false, underline = false, update_in_insert = false }, client)
    require("utils.autoload").diagnostics(bufnr)

    if sc.documentHighlightProvider then
        aucmd("CursorHold", {
            group = "LspHighlightSymbols",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
            desc = "highlight Lsp cword on CursorHold",
        })
        aucmd("CursorMoved, CursorMovedI", {
            group = "LspHighlightSymbols",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
            desc = "clear Lsp cword highlights on CursorMove",
        })
    end

    if sc.documentFormattingProvider or sc.rangeFormattingProvider then
        vim.bo[bufnr].formatexpr = filterfmt(client) and [[v:lua.vim.lsp.formatexpr()]] or ""
        aucmd("BufWrite", {
            group = "LspAutoFormat",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { filter = filterfmt }
            end,
            desc = "let LSP format the buffer on save",
        })
        vim.keymap.set({ "n", "v" }, ",f", function()
            vim.lsp.buf.format { filter = filterfmt, timeout_ms = 2000 }
        end, { buffer = bufnr })
    end

    if sc.signatureHelpProvider then
        require("lsp.signature").attach(client, bufnr)
    end

    if sc.renameProvider then
        require("lsp.rename").attach()

        vim.keymap.set("n", ",R", function()
            return ":IncRename " .. vim.fn.expand "<cword>"
        end, { expr = true, buffer = bufnr, desc = "Incremental rename" })
    end

    vim.api.nvim_buf_create_user_command(
        bufnr,
        "LspCapabilities",
        require("utils.langServers").lsp_capabilities,
        { desc = "Display Language Server capabilities" }
    )
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function lsp.servers()
    local dict = vim.api.nvim_get_option "spellfile"
    local configs = {
        jsonls = {},
        yamlls = {},
        html = { capabilities = lsp.capabilities() },
        cssls = { capabilities = lsp.capabilities() },
        vimls = { capabilities = lsp.capabilities() },
        dartls = { capabilities = lsp.capabilities() },
        perlpls = { capabilities = lsp.capabilities() },
        pyright = { capabilities = lsp.capabilities() },
        dockerls = { capabilities = lsp.capabilities() },
        tsserver = { capabilities = lsp.capabilities() },
        marksman = { capabilities = lsp.capabilities() },
        bashls = { capabilities = lsp.capabilities(), filetypes = { "sh", "zsh" } },
        ltex = {
            autostart = false,
            filetypes = { "bib", "markdown", "org", "tex" },
            capabilities = lsp.capabilities(),
            settings = {
                ltex = {
                    additionalRules = {
                        enablePickyRules = true,
                        motherTongue = "en",
                        languageModel = "/usr/share/Ngrams/",
                    },
                    language = "en-GB",
                    dictionary = { ["en-GB"] = require("utils").concat_fileLines(dict) },
                },
            },
        },
        texlab = {
            cmd = { "texlab", "--log-file", "./texlab-log", "-vvvv" },
            capabilities = lsp.capabilities(),
            settings = {
                texlab = {
                    build = {
                        args = {
                            "-xelatex",
                            "-verbose",
                            "-file-line-error",
                            "-synctex=1",
                            "-interaction=nonstopmode",
                            "-shell-escape",
                            "%f",
                        },
                        executable = "latexmk",
                        forwardSearchAfter = true,
                    },
                    lint = { onSave = true, onChange = true },
                    chktex = { onOpenAndSave = true },
                    forwardSearch = {
                        args = { "--synctex-forward", "%l:1:%f", "%p" },
                        executable = "zathura",
                    },
                },
            },
        },
    }

    for ls, cfg in pairs(configs) do
        lspconfig[ls].setup(cfg)
    end
end

------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

function lsp.lintFormat()
    require("packer").loader "null-ls.nvim"
    local null_ls = require "null-ls"
    local sources = {
        null_ls.builtins.completion.tags,
        null_ls.builtins.code_actions.shellcheck,

        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.vint,

        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.clang_format.with {
            filetypes = { "glsl" },
        },
    }

    null_ls.setup { sources = sources }

    local helpers = require "null-ls.helpers"
    local glslang = {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "glsl" },
        generator = null_ls.generator {
            command = "glslangValidator",
            args = { "--stdin", "-S", "$FILEEXT" },
            to_stdin = true,
            from_stderr = true,
            format = "raw",
            check_exit_code = function(code, stderr)
                local success = code <= 1
                if not success then
                    print(stderr)
                end

                return success
            end,
            on_output = function(params)
                vim.pretty_print(params.output, "\n")
                helpers.diagnostics.from_patterns {
                    {
                        pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
                        groups = { "row", "col", "message" },
                    },
                    {
                        pattern = [[:(%d+) [%w-/]+ (.*)]],
                        groups = { "row", "message" },
                    },
                }
            end,
        },
    }

    null_ls.register(glslang)
end

------------------------------------------------------------------------

return lsp
