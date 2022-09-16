local servers = {}

------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

function servers.clangd()
    require('clangd_extensions').setup {
        server = {
            capabilities = require('r.lsp').capabilities(),
            filetypes = { 'c', 'cpp', 'opencl' },
            init_options = {
                clangdFileStatus = true,
            },
            cmd = {
                'clangd',
                '--clang-tidy',
                '--background-index',
                '--all-scopes-completion',
                '--header-insertion=iwyu',
                '--header-insertion-decorators',
                '--completion-style=detailed',
                '--suggest-missing-includes',
                '--fallback-style=webkit',
                '--cross-file-rename',
                '--offset-encoding=utf-32',
            },
        },
        extensions = {
            autoSetHints = false,
            memory_usage = {
                border = 'rounded',
            },
            symbol_info = {
                border = 'rounded',
            },
        },
    }
end

function servers.clangCmp()
    local cmp = require 'cmp'
    cmp.setup.sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require 'clangd_extensions.cmp_scores',
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }
end

function servers.ccls()
    local filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'opencl' }
    local server_config = {
        filetypes = filetypes,
        init_options = {
            cache = {
                directory = vim.fs.normalize '~/.cache/ccls/',
            },
        },
    }
    require('ccls').setup {
        filetypes = filetypes,
        lsp = {
            server = server_config,
            disable_capabilities = {
                completionProvider = true,
                documentFormattingProvider = true,
                documentRangeFormattingProvider = true,
                documentHighlightProvider = true,
                documentSymbolProvider = true,
                workspaceSymbolProvider = true,
                renameProvider = true,
                hoverProvider = true,
                codeActionProvider = true,
            },
            disable_diagnostics = true,
            disable_signature = true,
        },
    }
end

return servers
