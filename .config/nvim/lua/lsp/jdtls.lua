local servers = {}

------------------------------------------------------------------------
--                       Java Lsp         	                          --
------------------------------------------------------------------------

function servers.jdtls()
    if not package.loaded["lsp.settings"] then
        require("lsp").settings()
    end
    require("debugger").init()
    local home = os.getenv "XDG_DATA_HOME"
    local debug_path =
        "/debug-adapters/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"

    require("jdtls").start_or_attach {
        cmd = { "jdtls" },
        on_attach = function(client, bufnr)
            Attach_props(client, bufnr)
            vim.opt_local.formatexpr = "v:lua.vim.lsp.formatexpr()"
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("jdtls.setup").add_commands()
        end,
        capabilities = Capabilities,
        init_options = {
            bundles = {
                vim.fn.glob(home .. debug_path),
            },
        },
    }
end

return servers
