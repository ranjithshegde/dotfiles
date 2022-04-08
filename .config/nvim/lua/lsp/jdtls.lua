local servers = {}

------------------------------------------------------------------------
--                       Java Lsp         	                          --
------------------------------------------------------------------------

function servers.jdtls()
    require("debugger").init()
    local home = os.getenv "XDG_DATA_HOME"
    local debug_path =
        "/debug-adapters/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"

    require("jdtls").start_or_attach {
        cmd = { "jdtls" },
        on_attach = function(client, bufnr)
            require("lsp").attach(client, bufnr)
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("jdtls.setup").add_commands()
        end,
        capabilities = require("lsp").capabilities(),
        init_options = {
            bundles = {
                vim.fn.glob(home .. debug_path),
            },
        },
    }
end

return servers
