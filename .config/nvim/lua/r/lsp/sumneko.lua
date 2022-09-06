-----------------------------------------------------------------------
--                       Sumneko lua development 	                  --
------------------------------------------------------------------------

return function()
    local luadev = require('lua-dev').setup {
        library = { plugins = false },
        lspconfig = {
            capabilities = require('r.lsp').capabilities(),
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim', 'pd' } },
                    completion = { callSnippet = 'Replace' },
                },
            },
        },
    }
    if vim.b.isPD then
        table.insert(luadev.settings.Lua.workspace.library, '/usr/lib/pd/extra/pdlua')
    end
    require('lspconfig').sumneko_lua.setup(luadev)
end
