local servers = {}

-----------------------------------------------------------------------
--                       Sumneko lua development 	                  --
------------------------------------------------------------------------

function servers.sumneko()
    local luadev = require("lua-dev").setup {
        library = {
            plugins = { "plenary.nvim", "express_line.nvim", "nvim-lspconfig", "nvim-treesitter" },
        },
        runtime_path = true,
        lspconfig = {
            capabilities = require("lsp").capabilities(),
            settings = { Lua = { diagnostics = { globals = { "vim", "pd" } } } },
        },
    }
    table.insert(luadev.settings.Lua.workspace.library, vim.fs.normalize "~/.config/nvim")
    if vim.b.isPD then
        table.insert(luadev.settings.Lua.workspace.library, "/usr/lib/pd/extra/pdlua")
    end
    require("lspconfig").sumneko_lua.setup(luadev)
end

return servers
