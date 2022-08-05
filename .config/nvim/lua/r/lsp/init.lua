---@diagnostic disable: missing-parameter
local lsp = {}
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

local opts = { clear = true }

local nofmt = {
    "sumneko_lua",
    "jsonls",
}

local function filterfmt(client)
    return not vim.tbl_contains(nofmt, client.name)
end

local nofmttex = {
    "sumneko_lua",
    "jsonls",
    "texlab",
}

local function filterfmtex(client)
    return not vim.tbl_contains(nofmttex, client.name)
end

---**************************** LSP AuGroups and Handlers
function lsp.settings()
    local id = {}
    id.SetDiagnosticFuncs = augroup("SetDiagnosticFuncs", opts)
    id.LspHighlightSymbols = augroup("LspHighlightSymbols", opts)
    id.LspAutoFormat = augroup("LspAutoFormat", opts)
    id.LspCodeLens = augroup("LspCodeLens", opts)
    require("r.utils").register_au_id(id)

    aucmd({ "DiagnosticChanged" }, {
        group = id.SetDiagnosticFuncs,
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

    require("r.utils.ls").lsp_messages()
end

---**************************** Snippet capabilities
function lsp.capabilities()
    require("packer").loader "cmp-nvim-lsp"
    return require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

---**************************** Global attach function
function lsp.attach(client, bufnr)
    require("r.utils.ls").lsp_progress()
    require("r.mappings.lsp").lsp(bufnr)
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
            group = vim.g.au_id.LspCodeLens,
            callback = vim.lsp.codelens.refresh,
            desc = "Refresh codelens on save",
        })
        vim.lsp.codelens.refresh()
        vim.bo[bufnr].tagfunc = ""
        return
    end

    require("r.utils.diagnostics").attach({ all = false, underline = false, update_in_insert = false }, client)
    require("r.utils.extensions").diagnostics(bufnr)

    if sc.documentHighlightProvider then
        aucmd("CursorHold", {
            group = vim.g.au_id.LspHighlightSymbols,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
            desc = "highlight Lsp cword on CursorHold",
        })
        aucmd("CursorMoved, CursorMovedI", {
            group = vim.g.au_id.LspHighlightSymbols,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
            desc = "clear Lsp cword highlights on CursorMove",
        })
    end

    if sc.documentFormattingProvider or sc.rangeFormattingProvider then
        vim.bo[bufnr].formatexpr = filterfmtex(client) and [[v:lua.vim.lsp.formatexpr()]] or ""

        aucmd("BufWrite", {
            group = vim.g.au_id.LspAutoFormat,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { filter = filterfmtex }
            end,
            desc = "let LSP format the buffer on save",
        })
        vim.keymap.set({ "n", "v" }, ",f", function()
            vim.lsp.buf.format { filter = filterfmt, timeout_ms = 2000 }
        end, { buffer = bufnr })
    end

    if sc.signatureHelpProvider then
        require("r.lsp.signature").attach(client, bufnr)
    end

    if sc.renameProvider then
        require("r.lsp.rename").attach()

        vim.keymap.set("n", ",R", function()
            return ":IncRename " .. vim.fn.expand "<cword>"
        end, { expr = true, buffer = bufnr, desc = "Incremental rename" })
    end

    if client.name == "ltex" then
        vim.lsp.commands["_ltex.addToDictionary"] = require("r.utils.ls").ltex_add_to_dict
        vim.lsp.commands["_ltex.disableRules"] = require("r.utils.ls").ltex_disable_rule
        vim.lsp.commands["_ltex.hideFalsePositives"] = require("r.utils.ls").ltex_false_positive
    end

    if client.name == "sqls" then
        require("packer").loader "sqls.nvim"
        require("sqls").on_attach(client, bufnr)
        sc.documentFormattingProvider = false
        sc.documentRangeFormattingProvider = false
    end

    vim.api.nvim_buf_create_user_command(
        bufnr,
        "LspCapabilities",
        require("r.utils.ls").lsp_capabilities,
        { desc = "Display Language Server capabilities" }
    )
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function lsp.servers()
    local dict = vim.api.nvim_get_option "spellfile"

    local lspconf = require "lspconfig.configs"
    if not lspconf.neocmake then
        lspconf.neocmake = {
            default_config = {
                cmd = { "neocmakelsp" },
                filetypes = { "cmake" },
                root_dir = function()
                    return vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1])
                end,
                single_file_support = true,
            },
        }
    end

    local configs = {
        yamlls = {},
        html = { capabilities = lsp.capabilities() },
        cssls = { capabilities = lsp.capabilities() },
        vimls = { capabilities = lsp.capabilities() },
        dartls = { capabilities = lsp.capabilities() },
        jsonls = { capabilities = lsp.capabilities() },
        perlpls = { capabilities = lsp.capabilities() },
        pyright = { capabilities = lsp.capabilities() },
        neocmake = { capabilities = lsp.capabilities() },
        dockerls = { capabilities = lsp.capabilities() },
        tsserver = { capabilities = lsp.capabilities() },
        marksman = { capabilities = lsp.capabilities() },
        bashls = { capabilities = lsp.capabilities(), filetypes = { "sh", "zsh" } },
        sqls = {
            capabilities = lsp.capabilities(),
            on_new_config = function(new_config, new_rootdir)
                new_config.cmd = {
                    "sqls",
                    "-config",
                    new_rootdir .. "/config.yml",
                }
            end,
        },
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
                    dictionary = { ["en-GB"] = require("r.utils").concat_fileLines(dict) },
                },
            },
        },
        texlab = {
            cmd = { "texlab", "--log-file", "./aux/texlab-log", "-vvvv" },
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
                            "-outdir=aux",
                            "%f",
                        },
                        executable = "latexmk",
                        forwardSearchAfter = true,
                    },
                    bibtexFormatter = "latexindent",
                    lint = { onSave = true, onChange = true },
                    chktex = { onOpenAndSave = true },
                    auxDirectory = "aux",
                    latexindent = { modifyLineBreaks = true },
                    forwardSearch = {
                        args = { "--synctex-forward", "%l:1:%f", "%p" },
                        executable = "zathura",
                    },
                },
            },
        },
    }

    for ls, cfg in pairs(configs) do
        require("lspconfig")[ls].setup(cfg)
    end
end

------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

function lsp.lintFormat()
    require("packer").loader "null-ls.nvim"
    local null_ls = require "null-ls"
    local sources = {
        null_ls.builtins.code_actions.shellcheck,

        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.vint,
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.diagnostics.stylelint,

        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.clang_format.with {
            filetypes = { "glsl" },
        },
        null_ls.builtins.formatting.cmake_format.with {
            extra_args = { "--config-file", vim.env.XDG_CONFIG_HOME .. "/cmake-format.json", "--" },
        },
        null_ls.builtins.formatting.prettier.with {
            extra_filetypes = { "toml" },
        },
    }
    null_ls.setup { sources = sources }
    null_ls.register(require("r.utils.ls").glsl())
end

------------------------------------------------------------------------

return lsp
