local servers = {}

------------------------------------------------------------------------
--                       Java Lsp         	                          --
------------------------------------------------------------------------

function servers.luadev()
    if not package.loaded["lsp.settings"] then
        require("lsp").settings()
    end
    local luadev = require("lua-dev").setup {
        library = { plugins = { "plenary.nvim", "telescope.nvim", "express_line.nvim", "nvim-lspconfig" } },
        lspconfig = {
            on_attach = EfmAttach,
            capabilities = Capabilities,
            settings = { Lua = { diagnostics = { globals = { "vim", "pd" } } } },
        },
    }
    luadev.settings.Lua.workspace.library[vim.fn.expand "~/.config/nvim"] = true
    luadev.settings.Lua.workspace.library["/usr/lib/pd/extra/pdlua"] = true
    Lsp.sumneko_lua.setup(luadev)
end

return servers
