local lsp = {}

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

local lspconfig = require "lspconfig"
function lsp.settings()
    AuGroup("SetDiagnosticFuncs", {})
    AuCmd({ "DiagnosticChanged" }, {
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

-- **************************** Snippet capabilities--------------------
function lsp.capabilities()
    local ok, cmp = pcall(require, "cmp_nvim_lsp")
    if ok then
        return cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
    end
end

-- **************************** Global attach function------------------
function lsp.attach(client, bufnr)
    require("mappings").nvim_lsp()

    vim.cmd "PackerLoad lsp-status.nvim"
    local lsp_status = require "lsp-status"
    if client.name ~= "ltex" and client.name ~= "efm" then
        lsp_status.register_progress()
    end
    lsp_status.on_attach(client)
    require("utils.diagnostics").attach({ all = false, underline = false, update_in_insert = false }, client)

    local rc = client.resolved_capabilities
    if rc.document_highlight then
        AuGroup("LspHighlightSymbols", {})
        AuCmd("CursorHold", {
            group = "LspHighlightSymbols",
            buffer = 0,
            callback = vim.lsp.buf.document_highlight,
        })
        AuCmd("CursorMoved, CursorMovedI", {
            group = "LspHighlightSymbols",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    if rc.document_formatting then
        AuGroup("LspAutoFormat", {})
        AuCmd("BufWrite", {
            group = "LspAutoFormat",
            pattern = "*.html,*.css,*.js,*.hpp,*.h,*.sh,*.lua,*.cpp,*.json,*.py,*.yaml,*.toml,*.vs,*.fs,*.gs,*.vert,*.frag,*.geom,*.glsl",
            callback = function()
                vim.lsp.buf.formatting_sync(nil, 500)
            end,
        })
    end
    Api.nvim_add_user_command("LspCapabilities", require("utils.langServers").lsp_capabilities, {})
end

-- **************************** Ccls reduction function-----------------
function lsp.cinit(client)
    require("mappings").nvim_lsp()
    local ok, lsp_status = pcall(require, "lsp-status")
    if ok then
        lsp_status.register_progress()
    end
    client.server_capabilities.completionProvider = false
    local rc = client.resolved_capabilities
    rc.document_formatting = false
    rc.document_range_formatting = false
    rc.document_highlight = false
    rc.document_symbol = false
    rc.workspace_symbol = false
    rc.rename = false
    rc.hover = false
    rc.code_action = false
end

-- **************************** Attach without formatting --------------
function lsp.efm(client, bufnr)
    lsp.attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function lsp.servers()
    local dict = os.getenv "XDG_CONFIG_HOME" .. "/nvim/spell/en.utf-8.add"
    local configs = {
        jsonls = { on_attach = lsp.efm },
        yamlls = { on_attach = lsp.attach },
        html = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        cssls = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        cmake = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        vimls = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        dartls = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        pyright = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        tsserver = { on_attach = lsp.attach, capabilities = lsp.capabilities() },
        bashls = { on_attach = lsp.attach, capabilities = lsp.capabilities(), filetypes = { "sh", "zsh" } },
        ccls = {
            on_init = lsp.cinit,
            filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
            handlers = {
                ["textDocument/publishDiagnostics"] = function(...)
                    return nil
                end,
                ["textDocument/signatureHelp"] = function(...)
                    return nil
                end,
            },
            single_file_support = true,
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        },
        ltex = {
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
        return vim.fn.getcwd() or lspconfig.util.root_pattern ".git/"
    end
    local rootMarker = { vim.fn.getcwd() or { ".git/" } }

    local checkmake = { lintCommand = "checkmake", lintStdin = true }
    local yamllint = { lintCommand = "yamllint -f parsable -", lintStdin = true }
    local shfmt = { formatCommand = "shfmt -ci -s -bn", formatStdin = true }
    local prettier = { formatCommand = "prettier --stdin --stdin-filepath ${INPUT}", formatStdin = true }
    local isort = { formatCommand = "isort --stdout --profile black -", formatStdin = true }
    local black = { formatCommand = "black --fast -", formatStdin = true }
    local clang_format = { formatCommand = "clang-format -", formatStdin = true }
    local mypy = {
        lintCommand = "mypy --show-column-numbers",
        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
        lintSource = "mypy",
    }
    local flake8 = {
        lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintIgnoreExitCode = true,
        lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
        lintSource = "flake8",
    }
    local shellcheck = {
        lintCommand = "shellcheck -f gcc -x -",
        lintStdin = true,
        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
    }
    local markdownlint = {
        lintCommand = "markdownlint -f ${INPUT}",
        lintStdin = true,
        lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
    }
    local stylua = { formatCommand = "stylua --search-parent-directories -", formatStdin = true }
    local vint = {
        lintCommand = "vint -f '{file_path}:{line_number}:{column_number}: {severity}: {description} (see: {reference})' --enable-neovim",
        lintStdin = false,
        lintFormats = { "%f:%l:%c: %m" },
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
        vimwiki = { markdownlint },
        markdown = { prettier },
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
