local servers = {}

------------------------------------------------------------------------
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------

function servers.clangd()
    require("clangd_extensions").setup {
        server = {
            on_attach = require("lsp").attach,
            capabilities = require("lsp").capabilities(),
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
    local cmp = require "cmp"
    cmp.setup.sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require "clangd_extensions.cmp_scores",
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }
end

return servers
