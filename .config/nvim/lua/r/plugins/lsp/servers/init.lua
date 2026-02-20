------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

return function()
    local base_servers = {
        'html',
        'ruff',
        'cssls',
        'taplo',
        'ts_ls',
        'bashls',
        'glslls',
        'jsonls',
        'stylua',
        'yamlls',
        'copilot',
        'digestif',
        'gdscript',
        'marksman',
        'neocmake',
        'sourcekit',
        'basedpyright',
        'glsl_analyzer',
        'rust_analyzer',
    }

    local configs = {}

    for _, server in ipairs(base_servers) do
        configs[server] = {}
    end

    configs.bashls.filetypes = { 'sh', 'zsh', 'bash' }
    configs.sourcekit.filetypes = { 'swift', 'objective-c', 'objective-cpp' }

    configs.copilot = {
        filetypes = { 'sh', 'zsh', 'c', 'cpp', 'lua', 'tex', 'gitcommit', 'markdown', 'yaml', 'html', 'css', 'cmake' },
        settings = { telemetry = { telemetryLevel = 'none' } },
    }

    configs.lua_ls = {
        before_init = function(_, config)
            local file = vim.fn.expand '%:t:r'
            if vim.uv.fs_stat(file .. '.pd_lua') then
                config.settings.Lua.diagnostics = { globals = { 'pd' } }
            end
        end,
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
    }

    configs.ltex_plus = require('r.plugins.lsp.servers.ltex').lsp()

    if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
        configs.texlab = require 'r.plugins.lsp.servers.texlab'
    end

    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        configs.clangd = require('r.plugins.lsp.servers.clang').clangd()
    end

    if vim.bo.filetype == 'org' then
        configs.org = {}
    end

    for ls, cfg in pairs(configs) do
        vim.lsp.config(ls, cfg)
        if ls ~= 'ltex_plus' then
            vim.lsp.enable(ls, true)
        end
    end
end
