local library = {
    vim.env.VIMRUNTIME,
    vim.fn.stdpath 'config',
}

local is_pd = vim.fn.expand '%:e' == 'pd_lua' or vim.fs.root(0, { '*.pd_lua' }) ~= nil

if is_pd then
    table.insert(library, '/usr/lib/pd/extra/pdlua')
end

return {
    before_init = function(_, config)
        if vim.fn.expand '%:e' == 'pd_lua' then
            config.settings.Lua.diagnostics = { globals = { 'pd', 'pdx' } }
        end
    end,
    settings = {
        Lua = {
            completion = { callSnippet = 'Replace' },
            workspace = {
                library = library,
                checkThirdParty = false,
            },
            runtime = { version = 'LuaJIT' },
        },
    },
}
