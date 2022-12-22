local completion = {}

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

local function cmp_setup(cmp, luasnip)
    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        -- Setup mappings
        mapping = cmp.mapping.preset.insert {
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm { select = false },
            ['<C-h>'] = cmp.mapping(function(_)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, { 'i', 's' }),
            ['<C-l>'] = cmp.mapping(function(_)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end, { 'i', 's' }),
            ['<C-j>'] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<C-p>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<C-n>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        },
        -- setup and chain sources
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'orgmode' },
            { name = 'path' },
        }, {
            {
                name = 'buffer',
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end,
                },
            },
        }),
        -- Popup menu strategy
        formatting = {
            format = function(_, vim_item)
                vim_item.kind =
                    string.format('%s %s', require('r.utils.tables').kindSymbols[vim_item.kind], vim_item.kind)
                return vim_item
            end,
        },
        -- Individual window properties
        window = {
            completion = {
                scrollbar = '║',
            },
            documentation = {
                border = 'single',
            },
        },
        experimental = { ghost_text = true },
    }
end

local function cmp_extras(cmp)
    -- Load completion sources
    require('lazy').load { plugins = { 'cmp-path', 'cmp-buffer', 'cmp_luasnip' } }

    -- Single keystroke to toggle between cmp and ins-completion
    local isCmp = true
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if isCmp then
            cmp.mapping.close()
            isCmp = false
        else
            isCmp = true
            require('r.utils').feedkey('<C-e>', 'n')
            cmp.complete()
        end
        return '<C-N>'
    end, { expr = true })

    -- Load special LSP sorter for c/c++/opencl
    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        require('r.lsp.clangd').clangCmp()
    end

    -- Lazy load friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()
end

function completion.init()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp_setup(cmp, luasnip)

    cmp_extras(cmp)
end

function completion.pairs()
    local npairs = require 'nvim-autopairs'
    npairs.setup { check_ts = true }
    local ts_conds = require 'nvim-autopairs.ts-conds'

    local Rule = require 'nvim-autopairs.rule'
    npairs.add_rules {
        Rule('|', '|', 'supercollider'),
        Rule('$', '$', 'tex'),
        Rule('`', "'", 'tex'),
        Rule('"', '",', 'lua'):with_pair(ts_conds.is_ts_node 'table_constructor'),
        Rule('{', '},', 'lua'):with_pair(ts_conds.is_ts_node 'table_constructor'),
        Rule("'", "',", 'lua'):with_pair(ts_conds.is_ts_node 'table_constructor'),
    }

    require('cmp').event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done {
            filetypes = {
                tex = {
                    ['{'] = {
                        kind = {
                            require('cmp').lsp.CompletionItemKind.Function,
                        },
                        handler = require('nvim-autopairs.completion.handlers')['*'],
                    },
                },
            },
        }
    )
end

function completion.luasnip()
    local types = require 'luasnip.util.types'
    require('luasnip').config.set_config {
        history = true,
        update_events = 'InsertLeave, TextChanged, TextChangedI',
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { '✿' } },
                },
            },
        },
    }
end

return completion
