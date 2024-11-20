local navigator = {
    default_mapping = false,
    icons = { icons = false },
    lsp_signature_help = false,
    lsp = {
        enabled = false,
        disable_lsp = 'all',
        format_on_save = false,
        hover = { enable = false },
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
    local configs = {
        yamlls = {},
        html = { capabilities = handlers.capabilities() },
        cssls = { capabilities = handlers.capabilities() },
        taplo = { capabilities = handlers.capabilities() },
        dartls = { capabilities = handlers.capabilities() },
        glslls = { capabilities = handlers.capabilities() },
        jsonls = { capabilities = handlers.capabilities() },
        marksman = { capabilities = handlers.capabilities() },
        neocmake = { capabilities = handlers.capabilities() },
        ts_ls = { capabilities = handlers.capabilities() },
        pyright = { capabilities = handlers.capabilities() },
        rust_analyzer = { capabilities = handlers.capabilities() },
        bashls = {
            capabilities = handlers.capabilities(),
            filetypes = { 'sh', 'zsh' },
        },
        lua_ls = {
            capabilities = handlers.capabilities(),
            before_init = function(_, config)
                local file = vim.fn.expand '%:t:r'
                if vim.uv.fs_stat(file .. '.pd_lua') then
                    config.settings.Lua.diagnostics = { globals = { 'pd' } }
                end
            end,
            settings = { Lua = { completion = { callSnippet = 'Replace' } } },
        },
    }

    configs.ltex = require('r.plugins.lsp.ltex').lsp()

    if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
        configs.texlab = require('r.plugins.lsp.texlab').lsp()
    end

    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        configs.clangd = require('r.plugins.lsp.clang').clangd()
        require('r.plugins.lsp.clang').clangd_ext()
    end

    require('navigator').setup(navigator)
    require('lspconfig.ui.windows').default_options.border = 'single'

    for ls, cfg in pairs(configs) do
        require('lspconfig')[ls].setup(cfg)
    end
end
