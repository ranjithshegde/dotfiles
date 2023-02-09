local servers = {}

------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

function servers.clangd(navigator)
    local cmd = {
        'clangd',
        '--clang-tidy',
        '--background-index',
        '--all-scopes-completion',
        '--completion-style=detailed',
        '--fallback-style=webkit',
        '--cross-file-rename',
        '--offset-encoding=utf-32',
    }

    local header_cmp = {
        '--header-insertion=iwyu',
        '--header-insertion-decorators',
        '--suggest-missing-includes',
    }

    if vim.b.cpp_type == 'Unreal' then
        table.insert(cmd, '--header-insertion=never')
        local ok, err = pcall(require('Unreal').Start)
        if not ok then
            vim.notify(err, vim.log.levels.ERROR, { title = 'Unreal.nvim' })
        end
    else
        for _, v in ipairs(header_cmp) do
            table.insert(cmd, v)
        end
    end

    local config = {
        capabilities = require('r.lsp').capabilities(),
        filetypes = { 'c', 'cpp', 'opencl' },
        init_options = {
            clangdFileStatus = true,
        },
        cmd = cmd,
    }

    local extensions = {
        autoSetHints = false,
        memory_usage = {
            border = 'rounded',
        },
        symbol_info = {
            border = 'rounded',
        },
    }

    if not navigator then
        require('clangd_extensions').setup {
            server = config,
            extensions = extensions,
        }
    else
        return require('clangd_extensions').prepare {
            server = config,
            extensions = extensions,
        }
    end
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
        cmd = { 'ccls', '--log-file=/tmp/ccls.log', '--v=1' },
        filetypes = filetypes,
        autostart = true,
    }

    -- require('ccls').setup { lsp = { lspconfig = server_config } }
    -- require('ccls').setup { lsp = { use_defaults = true } }
    -- require('ccls').setup { lsp = { use_defaults = true, codelens = { enable = true } } }
    require('ccls').setup {
        filetypes = filetypes,
        lsp = {
            -- lspconfig = server_config,
            server = server_config,
            disable_capabilities = {
                completionProvider = true,
                codeActionProvider = true,
                documentFormattingProvider = true,
                definitionProvider = true,
                documentRangeFormattingProvider = true,
                documentHighlightProvider = true,
                documentSymbolProvider = true,
                hoverProvider = true,
                referencesProvider = true,
                renameProvider = true,
                typeDefinitionProvider = true,
                workspaceSymbolProvider = true,
            },
            disable_diagnostics = true,
            disable_signature = true,
            codelens = {
                enable = true,
            },
        },
    }
end

return servers
