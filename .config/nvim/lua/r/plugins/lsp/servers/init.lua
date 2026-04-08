------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

return function()
    local base_servers = {
        'html',
        'ruff',
        'cssls',
        'oxfmt',
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

    if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
        vim.lsp.enable('texlab', true)
    end

    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        vim.lsp.enable('clangd', true)
    end

    if vim.tbl_contains({ 'lua', 'pd_lua', 'pdlua' }, vim.bo.filetype) then
        vim.lsp.enable('lua_ls', true)
    end

    if vim.bo.filetype == 'org' then
        configs.org = {}
    end

    for ls, cfg in pairs(configs) do
        vim.lsp.config(ls, cfg)
        vim.lsp.enable(ls, true)
    end
end
