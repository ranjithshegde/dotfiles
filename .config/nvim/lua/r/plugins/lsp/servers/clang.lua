local servers = {}

------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

function servers.ccls()
    local filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'opencl' }
    local server_config = {
        cmd = { 'ccls', '--log-file=/tmp/ccls.log', '--v=0' },
        filetypes = filetypes,
        autostart = true,
        root_dir = vim.fs.dirname(
            vim.fs.find({ 'compile_commands.json', 'compile_flags.txt', '.git', '.ccls' }, { upward = true })[1]
        ),
    }

    local cpu_count = #vim.uv.cpu_info()
    local ccls_threads = math.max(1, cpu_count - 1)

    require('ccls').setup {
        filetypes = filetypes,
        lsp = {
            server = server_config,
            init_options = {
                threads = ccls_threads,
                index = {
                    onChange = false,
                    trackDependency = 1,
                    multiVersion = 0,
                    blacklist = { '^build/', '^.cache/', '^bin/', '^packaging', '^res' },
                },
                cache = {
                    directory = '.ccls-cache',
                },
            },
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

return servers
