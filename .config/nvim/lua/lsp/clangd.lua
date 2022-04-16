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
end

function servers.clangCmp()
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

function servers.ccls()
    ---@diagnostic disable-next-line: unused-vararg
    local nilfunc = function(...)
        return nil
    end
    local lspconfig = require "lspconfig"
    local ccls = {
        on_init = require("lsp").cinit,
        filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
        handlers = {
            ["textDocument/publishDiagnostics"] = nilfunc,
            ["textDocument/signatureHelp"] = nilfunc,
        },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    }
    require("lspconfig").ccls.setup(ccls)
end

return servers
