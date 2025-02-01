------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

return function()
    local handlers = require 'r.plugins.lsp.handlers'

    local base_servers = {
        'html',
        'ruff',
        'cssls',
        'taplo',
        'ts_ls',
        'dartls',
        'glslls',
        'jsonls',
        'yamlls',
        'gdscript',
        'marksman',
        'neocmake',
        'basedpyright',
        'rust_analyzer',
    }

    local configs = {}

    for _, server in ipairs(base_servers) do
        configs[server] = { capabilities = handlers.capabilities() }
    end

    configs.bashls = {
        capabilities = handlers.capabilities(),
        filetypes = { 'sh', 'zsh' },
    }

    configs.lua_ls = {
        capabilities = handlers.capabilities(),
        before_init = function(_, config)
            local file = vim.fn.expand '%:t:r'
            if vim.uv.fs_stat(file .. '.pd_lua') then
                config.settings.Lua.diagnostics = { globals = { 'pd' } }
            end
        end,
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
    }

    configs.ltex = require('r.plugins.lsp.servers.ltex').lsp()

    if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
        configs.texlab = require 'r.plugins.lsp.servers.texlab'
    end

    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        configs.clangd = require('r.plugins.lsp.servers.clang').clangd()
        require('r.plugins.lsp.servers.clang').clangd_ext()
    end

    -- require('lspconfig.ui.windows').default_options.border = 'single'

    for ls, cfg in pairs(configs) do
        require('lspconfig')[ls].setup(cfg)
    end
end
