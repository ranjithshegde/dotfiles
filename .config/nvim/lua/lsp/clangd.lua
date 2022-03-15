local servers = {}

------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

function servers.clangd()
    if not package.loaded["lsp.settings"] then
        require("lsp").settings()
    end

    require("clangd_extensions").setup {
        server = {
            on_attach = All_attach,
            capabilities = Capabilities,
            filetypes = { "c", "cpp", "opencl" },
            cmd = {
                "clangd",
                "--clang-tidy",
                "--background-index",
                "--all-scopes-completion",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--suggest-missing-includes",
                "--fallback-style=webkit",
                "--cross-file-rename",
                "--offset-encoding=utf-32",
            },
        },
        extensions = {
            autoSetHints = false,
            memory_usage = {
                border = "rounded",
            },
            symbol_info = {
                border = "rounded",
            },
        },
    }
end

return servers
