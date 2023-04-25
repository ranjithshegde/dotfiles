local navigator = {
    default_mapping = false,
    lsp_signature_help = false,
    lsp = {
        format_on_save = false,
        servers = {},
        disable_lsp = { 'ccls', 'sqls' },
        hover = false,
        code_action = { enable = false },
        diagnostic = {
            all = false,
            virtual_text = false,
            underline = false,
            update_in_insert = false,
        },
        disply_diagnostic_qf = false,
    },
}

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

return function()
    local handlers = require 'r.plugins.lsp.handlers'
    local pid = vim.fn.getpid()
    local configs = {
        yamlls = {},
        html = { capabilities = handlers.capabilities() },
        cssls = { capabilities = handlers.capabilities() },
        taplo = { capabilities = handlers.capabilities() },
        dartls = { capabilities = handlers.capabilities() },
        jsonls = { capabilities = handlers.capabilities() },
        pyright = { capabilities = handlers.capabilities() },
        marksman = { capabilities = handlers.capabilities() },
        neocmake = { capabilities = handlers.capabilities() },
        tsserver = { capabilities = handlers.capabilities() },
        rust_analyzer = { capabilities = handlers.capabilities() },
        bashls = {
            capabilities = handlers.capabilities(),
            filetypes = { 'sh', 'zsh' },
        },
        omnisharp = {
            capabilities = handlers.capabilities(),
            trace = 'verbose',
            cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(pid) },

            handlers = {
                ['textDocument/definition'] = function(...)
                    require('omnisharp_extended').handler(...)
                end,
            },
        },
        lua_ls = {
            capabilities = handlers.capabilities(),
            before_init = function(params, config)
                require('neodev.lsp').before_init(params, config)
                local file = vim.fn.expand '%:t:r'
                if vim.loop.fs_stat(file .. '.pd_lua') then
                    table.insert(config.settings.Lua.workspace.library, '/usr/lib/pd/extra/pdlua')
                    config.settings.Lua.diagnostics = { globals = { 'pd' } }
                end
            end,
            settings = { Lua = { completion = { callSnippet = 'Replace' } } },
        },
    }

    for ls, cfg in pairs(configs) do
        navigator.lsp[ls] = cfg
    end
    table.insert(navigator.lsp.servers, 'neocmake')
    table.insert(navigator.lsp.servers, 'marksman')

    navigator.lsp.ltex = require('r.plugins.lsp.ltex').lsp()
    table.insert(navigator.lsp.servers, 'ltex')

    if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
        navigator.lsp.texlab = require('r.plugins.lsp.texlab').lsp()
    end

    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        navigator.lsp.clangd = require('r.plugins.lsp.clang').clangd()
    end

    require('navigator').setup(navigator)

    require('lspconfig.ui.windows').default_options.border = 'single'
end
