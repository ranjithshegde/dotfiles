------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

return function()
    local cpu_count = #vim.uv.cpu_info()
    local ccls_threads = math.max(1, cpu_count - 1)

    local server_config = {
        cmd = { 'ccls', '--log-file=/tmp/ccls.log', '--v=0' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'opencl' },
        init_options = {
            threads = ccls_threads,
            index = {
                trackDependency = 1,
                blacklist = { '^build/', '^.cache/', '^bin/', '^packaging', '^res' },
            },
            cache = {
                directory = '.ccls-cache',
            },
        },
    }

    require('ccls').setup {
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
            -- codelens = {
            --     enable = true,
            -- },
        },
    }
end
