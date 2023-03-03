local handlers = {}
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
function handlers.init()
    local id = {}
    id.LspSettings = augroup('LspSettings', opts)

    aucmd('LspAttach', {
        group = id.LspSettings,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require('r.plugins.lsp.handlers').attach(client, args.buf)
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
function handlers.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    return capabilities
end

---**************************** Global attach function
function handlers.attach(client, bufnr)
    local id = {}

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
end

------------------------------------------------------------------------

return handlers
