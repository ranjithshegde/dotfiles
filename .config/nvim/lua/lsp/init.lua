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

local function filterfmt(clients)
    return vim.tbl_filter(function(client)
        if client.name == "efm" then
            return true
        elseif vim.tbl_contains(nofmt, client.name) then
            return false
        end
    end, clients)
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
            require("utils").commands()
        end,
    })

    -- borders for floating windows
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "double" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
    )
end

---**************************** Snippet capabilities
function lsp.capabilities()
    require("packer").loader "cmp-nvim-lsp"
    return require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

---**************************** Global attach function
function lsp.attach(client, bufnr)
    require("mappings.lsp").lsp(bufnr)
    vim.b.hasLsp = true

    require("packer").loader "fidget.nvim"
    require("utils.diagnostics").attach({ all = false, underline = false, update_in_insert = false }, client)

    local sc = client.server_capabilities
    if sc.documentHighlightProvider then
        aucmd("CursorHold", {
            group = "LspHighlightSymbols",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        aucmd("CursorMoved, CursorMovedI", {
            group = "LspHighlightSymbols",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    if sc.documentFormattingProvider or sc.rangeFormattingProvider then
        aucmd("BufWrite", {
            group = "LspAutoFormat",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { filter = filterfmt }
            end,
        })
        vim.keymap.set({ "n", "v" }, ",f", function()
            vim.lsp.buf.format { filter = filterfmt, timeout_ms = 2000 }
        end, { buffer = bufnr })
    end
    vim.api.nvim_create_user_command("LspCapabilities", require("utils.langServers").lsp_capabilities, {})
end

---**************************** Ccls reduction function
function lsp.cattach(client, bufnr)
    local sc = client.server_capabilities
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
    })
    vim.lsp.codelens.refresh()
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function lsp.servers()
    local dict = vim.api.nvim_get_option "spellfile"
    local configs = {
        jsonls = { on_attach = lsp.attach },
        yamlls = { on_attach = lsp.attach },
        html = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        cssls = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        cmake = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        vimls = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        dartls = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        pyright = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        tsserver = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        bashls = { on_attach = lsp.attach, capabilities = lsp.capabilities(), filetypes = { "sh", "zsh" } },
        ltex = {
            autostart = false,
            filetypes = { "bib", "markdown", "org", "tex" },
            on_attach = lsp.attach,
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
            on_attach = lsp.attach,
            -- capabilities = lsp.capabilities,
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
    local rootDir = function()
        return vim.fn.getcwd() or lspconfig.util.root_pattern ".git/"
    end
    local rootMarker = { vim.fn.getcwd() or { ".git/" } }

    local checkmake = { lintCommand = "checkmake", lintStdin = true }
    local black = { formatCommand = "black --fast -", formatStdin = true }
    local shfmt = { formatCommand = "shfmt -ci -s -bn", formatStdin = true }
    local yamllint = { lintCommand = "yamllint -f parsable -", lintStdin = true }
    local clang_format = { formatCommand = "clang-format -", formatStdin = true }
    local isort = { formatCommand = "isort --stdout --profile black -", formatStdin = true }
    local stylua = { formatCommand = "stylua --search-parent-directories -", formatStdin = true }
    local prettier = { formatCommand = "prettier --stdin --stdin-filepath ${INPUT}", formatStdin = true }
    local markdownlint = {
        lintCommand = "markdownlint -f ${INPUT}",
        lintStdin = true,
        lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
    }
    local mypy = {
        lintCommand = "mypy --show-column-numbers",
        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
        lintSource = "mypy",
    }
    local shellcheck = {
        lintCommand = "shellcheck -f gcc -x -",
        lintStdin = true,
        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
    }
    local vint = {
        lintCommand = "vint -f '{file_path}:{line_number}:{column_number}: {severity}: {description} (see: {reference})' --enable-neovim",
        lintStdin = false,
        lintFormats = { "%f:%l:%c: %m" },
    }
    local flake8 = {
        lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintIgnoreExitCode = true,
        lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
        lintSource = "flake8",
    }

    local languages = {
        vim = { vint },
        yaml = { yamllint },
        json = { prettier },
        html = { prettier },
        css = { prettier },
        toml = { prettier },
        lua = { stylua },
        glsl = { clang_format },
        make = { checkmake },
        markdown = { prettier, markdownlint },
        sh = { shellcheck, shfmt },
        zsh = { shellcheck, shfmt },
        python = { flake8, isort, black, mypy },
    }
    lspconfig.efm.setup {
        filetypes = vim.tbl_keys(languages),
        root_dir = rootDir,
        on_attach = lsp.attach,
        init_options = { documentFormatting = true, codeAction = true },
        settings = { rootMarkers = rootMarker, languages = languages },
    }
end

------------------------------------------------------------------------

return lsp
