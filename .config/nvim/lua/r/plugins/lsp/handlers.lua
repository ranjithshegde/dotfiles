local handlers = {}
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

local au_opts = { clear = true }

local nofmt = {
    'lua_ls',
    'jsonls',
}

local function filterfmt(client)
    return not vim.tbl_contains(nofmt, client.name)
end

---**************************** Initualize LSP
function handlers.init()
    local id = { LspSettings = augroup('LspSettings', au_opts) }

    vim.keymap.del('n', 'grn')
    vim.keymap.del('n', 'gri')
    vim.keymap.del('n', 'grr')
    vim.keymap.del({ 'n', 'v' }, 'gra')

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
        end,
        desc = 'Clear AUGroups when LSP detaches',
    })
    aucmd('LspNotify', {
        group = id.LspSettings,
        callback = function(args)
            if args.data.method == 'textDocument/didOpen' then
                vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
            end
        end,
        desc = 'close fold on file register',
    })

    require('r.utils').register_au_id(id)
end

---**************************** Snippet capabilities
function handlers.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    return capabilities
end

---**************************** Global attach function
function handlers.attach(client, bufnr)
    local id = {}

    require 'r.plugins.lsp.mappings'(client, bufnr)

    vim.b.hasLsp = true

    if client.name == 'ccls' then
        vim.bo[bufnr].tagfunc = ''
        vim.g.ccls_levels = 5
        require('r.plugins.lsp.mappings.servers').ccls(bufnr)
        return
    elseif client.name == 'texlab' then
        require('r.plugins.lsp.mappings.servers').tex(bufnr)
    elseif client.name == 'clangd' then
        require('r.plugins.lsp.mappings.servers').clangd(bufnr)
    end

    if client.name ~= 'null-ls' then
        if client:supports_method 'textDocument/foldingRange' then
            vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
        else
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end
    end

    require('r.extensions.diagnostics').attach(client, bufnr, { underline = false, update_in_insert = false })

    if
        client:supports_method 'textDocument/documentFormatting'
        or client:supports_method 'textDocument/rangeFormatting'
    then
        id['LspAutoFormat_' .. client.name .. '_' .. bufnr] =
            augroup('LspAutoFormat_' .. client.name .. '_' .. bufnr, au_opts)
        aucmd('BufWrite', {
            group = id['LspAutoFormat_' .. client.name .. '_' .. bufnr],
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { filter = filterfmt }
            end,
            desc = 'let LSP format the buffer on save',
        })
        vim.keymap.set({ 'n', 'v' }, 'gaf', function()
            vim.lsp.buf.format { filter = filterfmt, timeout_ms = 2000 }
        end, { buffer = bufnr })
    end

    require('r.utils').register_au_id(id)

    if client:supports_method 'textDocument/inlayHint' then
        vim.keymap.set('n', 'sh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'Toggle inlay hint' })
    end

    if client:supports_method 'textDocument/rename' then
        vim.keymap.set('n', 'crr', function()
            if not package.loaded['inc-rename'] then
                require('lazy').load { plugins = { 'inc-rename.nvim' } }
            end
            return ':IncRename ' .. vim.fn.expand '<cword>'
        end, { expr = true, buffer = bufnr, desc = 'Incremental rename' })
    end

    if client.name == 'ltex' then
        vim.lsp.commands['_ltex.addToDictionary'] = require('r.plugins.lsp.ltex').add_to_dict
        vim.lsp.commands['_ltex.disableRules'] = require('r.plugins.lsp.ltex').disable_rule
        vim.lsp.commands['_ltex.hideFalsePositives'] = require('r.plugins.lsp.ltex').false_positive
    end

    local complete = function()
        return require('r.utils').get_client_names()
    end

    vim.api.nvim_buf_create_user_command(bufnr, 'LspCapabilities', function(opt)
        local cap_client = vim.lsp.get_clients { name = opt.args, bufnr = bufnr }
        if cap_client and cap_client[1] then
            vim.print(cap_client[1].server_capabilities)
        else
            vim.print(
                string.format(
                    'Cannot retrieve capabilities: %s is not currently attached to buffer %d',
                    opt.args,
                    bufnr
                )
            )
        end
    end, { nargs = '*', complete = complete, desc = 'Toggle diagnostic virtual text for a client' })
end

------------------------------------------------------------------------

return handlers
