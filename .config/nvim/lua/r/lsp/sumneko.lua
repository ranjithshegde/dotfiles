-----------------------------------------------------------------------
--                       Sumneko lua development 	                  --
------------------------------------------------------------------------

return function()
    local luadev = require("lua-dev").setup {
        library = {
            plugins = {},
        },
        runtime_path = true,
        lspconfig = {
            capabilities = require("r.lsp").capabilities(),
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim", "pd" } },
                },
            },
        },
    }
    table.insert(luadev.settings.Lua.workspace.library, vim.fs.normalize "~/.config/nvim")
    if vim.b.isPD then
        table.insert(luadev.settings.Lua.workspace.library, "/usr/lib/pd/extra/pdlua")
    end
    require("lspconfig").sumneko_lua.setup(luadev)
end
