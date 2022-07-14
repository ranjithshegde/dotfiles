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
    local rootDir = function()
        return vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]) or vim.loop.cwd()
    end
    local rootMarker = { vim.loop.cwd() or { ".git/" } }

    local black = { formatCommand = "black --fast -", formatStdin = true }
    local shfmt = { formatCommand = "shfmt -ci -s -bn", formatStdin = true }
    local yamllint = { lintCommand = "yamllint -f parsable -", lintStdin = true }
    local clang_format = { formatCommand = "clang-format -", formatStdin = true }
    local isort = { formatCommand = "isort --stdout --profile black -", formatStdin = true }
    local stylua = { formatCommand = "stylua --search-parent-directories -", formatStdin = true }
    local prettier = { formatCommand = "prettier --stdin --stdin-filepath ${INPUT}", formatStdin = true }
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
        lintCommand = "flake8  --max-line-length 160 --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintIgnoreExitCode = true,
        lintFormats = { "%f:%l:%c: %m" },
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
        markdown = { prettier },
        sh = { shellcheck, shfmt },
        zsh = { shellcheck, shfmt },
        python = { flake8, isort, black },
    }
    lspconfig.efm.setup {
        filetypes = vim.tbl_keys(languages),
        root_dir = rootDir,
        init_options = { documentFormatting = true, codeAction = true },
        settings = { rootMarkers = rootMarker, languages = languages },
    }
end

------------------------------------------------------------------------

return lsp
