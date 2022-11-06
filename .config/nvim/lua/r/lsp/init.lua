local lsp = {}
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

local opts = { clear = true }

local nofmt = {
    'sumneko_lua',
    'jsonls',
}

local function filterfmt(client)
    return not vim.tbl_contains(nofmt, client.name)
end

local id = {}

---**************************** Snippet capabilities
function lsp.capabilities()
    if not package.loaded.cmp_nvim_lsp then
        require('packer').loader 'cmp-nvim-lsp'
    end
    return require('cmp_nvim_lsp').default_capabilities()
end

---**************************** Global attach function
function lsp.attach(client, bufnr)
    require('r.mappings.lsp').lsp(client, bufnr)
    vim.b.hasLsp = true

    local sc = client.server_capabilities

    if client.name == 'ccls' then
        id['LspCodeLens_' .. client.name .. '_' .. bufnr] = augroup('LspCodeLens_' .. client.name .. '_' .. bufnr, opts)
        aucmd({ 'BufEnter', 'BufWritePost' }, {
            buffer = bufnr,
            group = id['LspCodeLens_' .. client.name .. '_' .. bufnr],
            callback = vim.lsp.codelens.refresh,
            desc = 'Refresh codelens on save',
        })
        require('r.utils').register_au_id(id)
        vim.lsp.codelens.refresh()
        vim.bo[bufnr].tagfunc = ''
        return
    end

    require('r.extensions.diagnostics').attach({ all = false, underline = false, update_in_insert = false }, client)
    require('r.extensions').diagnostics(bufnr)

    if sc.documentHighlightProvider then
        id['LspHighlightSymbols_' .. client.name .. '_' .. bufnr] =
            augroup('LspHighlightSymbols_' .. client.name .. '_' .. bufnr, opts)
        aucmd('CursorHold', {
            group = id['LspHighlightSymbols_' .. client.name .. '_' .. bufnr],
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
            desc = 'highlight Lsp cword on CursorHold',
        })
        aucmd('CursorMoved, CursorMovedI', {
            group = id['LspHighlightSymbols_' .. client.name .. '_' .. bufnr],
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
            desc = 'clear Lsp cword highlights on CursorMove',
        })
    end

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
        require('r.lsp.rename').attach()

        vim.keymap.set('n', ',R', function()
            return ':IncRename ' .. vim.fn.expand '<cword>'
        end, { expr = true, buffer = bufnr, desc = 'Incremental rename' })
    end

    if client.name == 'ltex' then
        vim.lsp.commands['_ltex.addToDictionary'] = require('r.lsp.ltex').add_to_dict
        vim.lsp.commands['_ltex.disableRules'] = require('r.lsp.ltex').disable_rule
        vim.lsp.commands['_ltex.hideFalsePositives'] = require('r.lsp.ltex').false_positive
    end

    if client.name == 'sqls' then
        require('packer').loader 'sqls.nvim'
        require('sqls').on_attach(client, bufnr)
        sc.documentFormattingProvider = false
        sc.documentRangeFormattingProvider = false
    end

    vim.api.nvim_buf_create_user_command(
        bufnr,
        'LspCapabilities',
        require 'r.lsp.capabilities',
        { desc = 'Display Language Server capabilities' }
    )
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function lsp.servers()
    local lspconf = require 'lspconfig.configs'
    if not lspconf.neocmake then
        lspconf.neocmake = {
            default_config = {
                cmd = { 'neocmakelsp', '--stdio' },
                filetypes = { 'cmake' },
                root_dir = function()
                    return vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1])
                end,
                single_file_support = true,
            },
        }
    end

    local pid = vim.fn.getpid()
    local configs = {
        yamlls = {},
        html = { capabilities = lsp.capabilities() },
        cssls = { capabilities = lsp.capabilities() },
        vimls = { capabilities = lsp.capabilities() },
        dartls = { capabilities = lsp.capabilities() },
        jsonls = { capabilities = lsp.capabilities() },
        perlpls = { capabilities = lsp.capabilities() },
        pyright = { capabilities = lsp.capabilities() },
        neocmake = { capabilities = lsp.capabilities() },
        dockerls = { capabilities = lsp.capabilities() },
        tsserver = { capabilities = lsp.capabilities() },
        marksman = { capabilities = lsp.capabilities() },
        rust_analyzer = { capabilities = lsp.capabilities() },
        bashls = {
            capabilities = lsp.capabilities(),
            filetypes = { 'sh', 'zsh' },
        },
        sqls = {
            capabilities = lsp.capabilities(),
            on_new_config = function(new_config, new_rootdir)
                new_config.cmd = {
                    'sqls',
                    '-config',
                    new_rootdir .. '/config.yml',
                }
            end,
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
        sumneko_lua = {
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

    for ls, cfg in pairs(configs) do
        require('lspconfig')[ls].setup(cfg)
    end
    require('r.lsp.ltex').lsp()
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
    require('packer').loader 'null-ls.nvim'
    local nb = require 'null-ls.builtins'
    local sources = {
        nb.code_actions.shellcheck,

        nb.diagnostics.checkmake,
        nb.diagnostics.flake8,
        nb.diagnostics.shellcheck,
        nb.diagnostics.zsh,
        nb.diagnostics.stylelint,

        nb.formatting.black,
        nb.formatting.cbfmt,
        nb.formatting.isort,
        nb.formatting.shfmt,
        nb.formatting.stylua,
        nb.formatting.clang_format.with {
            filetypes = { 'glsl' },
        },
        nb.formatting.cmake_format.with {
            extra_args = { '--config-file', vim.env.XDG_CONFIG_HOME .. '/cmake-format.json', '--' },
        },
        nb.formatting.prettier.with {
            extra_filetypes = { 'toml' },
        },
    }
    require('null-ls').setup { sources = sources }
    require('null-ls').register(glsl())
end

------------------------------------------------------------------------

return lsp
