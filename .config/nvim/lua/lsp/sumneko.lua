local servers = {}

-----------------------------------------------------------------------
--                       Sumneko lua development 	                  --
------------------------------------------------------------------------

function servers.sumneko()
    local luadev = require("lua-dev").setup {
        library = {
            plugins = { "plenary.nvim", "telescope.nvim", "express_line.nvim", "nvim-lspconfig", "nvim-treesitter" },
        },
        lspconfig = {
            on_attach = require("lsp").efm,
            capabilities = require("lsp").capabilities(),
            settings = { Lua = { diagnostics = { globals = { "vim", "pd" } } } },
        },
    }
    luadev.settings.Lua.workspace.library[vim.fn.expand "~/.config/nvim"] = true
    luadev.settings.Lua.workspace.library["/usr/lib/pd/extra/pdlua"] = true
    require("lspconfig").sumneko_lua.setup(luadev)
end

return servers
