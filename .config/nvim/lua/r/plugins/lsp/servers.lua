local lsp = {}
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

local opts = { clear = true }

local nofmt = {
    'lua_ls',
    'jsonls',
}

local function filterfmt(client)
    return not vim.tbl_contains(nofmt, client.name)
end

---**************************** Initualize LSP
function lsp.init()
    local id = {}
    id.LspSettings = augroup('LspSettings', opts)
    -- ************** Lsp attach --------------------------------------------
    aucmd('LspAttach', {
        group = id.LspSettings,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require('r.plugins.lsp.servers').attach(client, args.buf)
        end,
        desc = 'Call attach function on event LspAttach',
    })
    aucmd('LspDetach', {
        group = id.LspSettings,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            vim.notify(string.format('Server %s detached from %d', client.name, args.buf))
            auclear { group = vim.g.au_id['LspAutoFormat_' .. client.name .. '_' .. args.buf], buffer = args.buf }
            auclear { group = vim.g.au_id['LspHighlightSymbols_' .. client.name .. '_' .. args.buf], buffer = args.buf }
        end,
        desc = 'Clear AUGroups when LSP detaches',
    })
    require('r.utils').register_au_id(id)
end

---**************************** Snippet capabilities
function lsp.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    return capabilities
end

---**************************** Global attach function
function lsp.attach(client, bufnr)
    local id = {}
    if not vim.g.navigator then
        require('r.plugins.lsp.navigator').attach(client, bufnr)
    end

    require('r.plugins.lsp.mappings').navic(bufnr)
    require('r.plugins.lsp.mappings').lsp(client, bufnr)

    vim.b.hasLsp = true

    local sc = client.server_capabilities

    if client.name == 'ccls' then
        vim.bo[bufnr].tagfunc = ''
        return
    end

    require('r.extensions.diagnostics').attach(
        { all = false, virtual_text = false, underline = false, update_in_insert = false },
        client
    )
    require('r.extensions').diagnostics(bufnr)

    if sc.documentFormattingProvider or sc.rangeFormattingProvider then
        id['LspAutoFormat_' .. client.name .. '_' .. bufnr] =
            augroup('LspAutoFormat_' .. client.name .. '_' .. bufnr, opts)
        aucmd('BufWrite', {
            group = id['LspAutoFormat_' .. client.name .. '_' .. bufnr],
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { filter = filterfmt }
            end,
            desc = 'let LSP format the buffer on save',
        })
        vim.keymap.set({ 'n', 'v' }, ',f', function()
            vim.lsp.buf.format { filter = filterfmt, timeout_ms = 2000 }
        end, { buffer = bufnr })
    end
    require('r.utils').register_au_id(id)

    if sc.renameProvider then
        require('r.extensions.lsp.rename').attach()

        vim.keymap.set('n', ',R', function()
            return ':IncRename ' .. vim.fn.expand '<cword>'
        end, { expr = true, buffer = bufnr, desc = 'Incremental rename' })
    end

    if client.name == 'ltex' then
        vim.lsp.commands['_ltex.addToDictionary'] = require('r.plugins.lsp.ltex').add_to_dict
        vim.lsp.commands['_ltex.disableRules'] = require('r.plugins.lsp.ltex').disable_rule
        vim.lsp.commands['_ltex.hideFalsePositives'] = require('r.plugins.lsp.ltex').false_positive
    end

    vim.api.nvim_buf_create_user_command(
        bufnr,
        'LspCapabilities',
        require 'r.extensions.lsp.capabilities',
        { desc = 'Display Language Server capabilities' }
    )

    if package.loaded['nvim-jdtls'] then
        if client.name == 'jdtls' then
            require('jdtls.setup').add_commands()
        end
    end
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function lsp.servers()
    local pid = vim.fn.getpid()
    local configs = {
        yamlls = {},
        html = { capabilities = lsp.capabilities() },
        cssls = { capabilities = lsp.capabilities() },
        taplo = { capabilities = lsp.capabilities() },
        dartls = { capabilities = lsp.capabilities() },
        jsonls = { capabilities = lsp.capabilities() },
        pyright = { capabilities = lsp.capabilities() },
        marksman = { capabilities = lsp.capabilities() },
        neocmake = { capabilities = lsp.capabilities() },
        tsserver = { capabilities = lsp.capabilities() },
        rust_analyzer = { capabilities = lsp.capabilities() },
        bashls = {
            capabilities = lsp.capabilities(),
            filetypes = { 'sh', 'zsh' },
        },
        omnisharp = {
            capabilities = lsp.capabilities(),
            trace = 'verbose',
            cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(pid) },

            handlers = {
                ['textDocument/definition'] = function(...)
                    require('omnisharp_extended').handler(...)
                end,
            },
        },
        lua_ls = {
            capabilities = lsp.capabilities(),
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

    if not vim.g.navigator then
        for ls, cfg in pairs(configs) do
            require('lspconfig')[ls].setup(cfg)
        end
        require('r.plugins.lsp.ltex').lsp()
        if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
            require('r.plugins.lsp.texlab').lsp()
        end

        if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
            require('r.plugins.lsp.clang').clangd(false)
        end

        require('r.plugins.lsp.navigator').init()
    else
        local navic = require('r.plugins.lsp.navigator').config(true)

        for ls, cfg in pairs(configs) do
            navic.lsp[ls] = cfg
        end

        navic.lsp.ltex = require('r.plugins.lsp.ltex').lsp(true)
        if vim.tbl_contains({ 'tex', 'bib', 'plaintex' }, vim.bo.filetype) then
            navic.lsp.texlab = require('r.plugins.lsp.texlab').lsp(true)
        end

        if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
            local clangd = require('r.plugins.lsp.clang').clangd(true)
            navic.lsp.clangd = clangd
        end
        require('r.plugins.lsp.navigator').init(navic)
    end

    require('lspconfig.ui.windows').default_options.border = 'single'
end

------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

local function glsl()
    local null_ls = require 'null-ls'

    return {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { 'glsl' },
        generator = null_ls.generator {
            command = 'glslangValidator',
            args = { '--stdin', '-S', '$FILEEXT' },
            to_stdin = true,
            from_stderr = true,
            format = 'raw',
            check_exit_code = function(code, stderr)
                local success = code <= 1
                if not success then
                    print(stderr)
                end

                return success
            end,
            on_output = function(params, done)
                if params and params.output then
                    local diagnostics = {}
                    local lines = vim.split(params.output, '\n')
                    local sever, col, row, message = string.match(lines[2], '(%u+):%s(%d+):(%d+):.*:%s+(.*)')

                    table.insert(diagnostics, {
                        row = row,
                        col = col + 1,
                        end_col = col + 2,
                        source = 'GLSLang',
                        message = message,
                        severity = require('null-ls.helpers').diagnostics.severities[vim.fn.tolower(sever)],
                    })
                    done(diagnostics)
                else
                    done()
                end
            end,
        },
    }
end

function lsp.lintFormat()
    local nb = require 'null-ls.builtins'
    local sources = {
        nb.code_actions.shellcheck,

        nb.diagnostics.zsh,
        nb.diagnostics.flake8,
        nb.diagnostics.checkmake,
        nb.diagnostics.stylelint,
        nb.diagnostics.shellcheck,

        nb.formatting.black,
        nb.formatting.isort,
        nb.formatting.shfmt,
        nb.formatting.stylua,
        nb.formatting.beautysh,
        nb.formatting.prettier,
        nb.formatting.clang_format.with {
            filetypes = { 'glsl' },
        },
        nb.formatting.cmake_format.with {
            extra_args = { '--config-file', vim.env.XDG_CONFIG_HOME .. '/cmake-format.json', '--' },
        },
    }
    require('null-ls').setup { sources = sources }
    require('null-ls').register(glsl())
end

------------------------------------------------------------------------

return lsp
