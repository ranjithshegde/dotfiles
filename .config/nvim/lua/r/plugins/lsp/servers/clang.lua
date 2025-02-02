local servers = {}

------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

function servers.clangd()
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
        require('lazy').load { plugins = { 'nvim-ue5' } }

        vim.keymap.set(
            'n',
            '<F6>',
            require('r.plugins.tasks.register').launchUEditor,
            { buffer = true, desc = 'Launch UE5' }
        )
    else
        for _, v in ipairs(header_cmp) do
            table.insert(cmd, v)
        end
    end

    return {
        capabilities = require('r.plugins.lsp.handlers').capabilities(),
        filetypes = { 'c', 'cpp', 'opencl' },
        init_options = {
            clangdFileStatus = true,
        },
        cmd = cmd,
    }
end

function servers.clangd_ext()
    return require('clangd_extensions').setup {
        autoSetHints = false,
        memory_usage = {
            border = 'rounded',
        },
        symbol_info = {
            border = 'rounded',
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

    require('ccls').setup {
        filetypes = filetypes,
        lsp = {
            server = server_config,
            disable_capabilities = {
                completionProvider = true,
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
