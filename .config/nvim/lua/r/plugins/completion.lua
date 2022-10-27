local completion = {}

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function completion.init()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
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
        formatting = {
            format = function(_, vim_item)
                vim_item.kind =
                    string.format('%s %s', require('r.utils.tables').kindSymbols[vim_item.kind], vim_item.kind)
                return vim_item
            end,
        },
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
    require('luasnip.loaders.from_vscode').lazy_load()

    if vim.tbl_contains({ 'c', 'cpp', 'opencl' }, vim.bo.filetype) then
        require('r.lsp.clangd').clangCmp()
    end

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
end

function completion.pairs()
    local npairs = require 'nvim-autopairs'
    npairs.setup { check_ts = true }

    local Rule = require 'nvim-autopairs.rule'
    npairs.add_rules {
        Rule('|', '|', 'supercollider'),
        Rule('$', '$', 'tex'),
        Rule('`', "'", 'tex'),
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
    vim.api.nvim_create_autocmd('InsertEnter', {
        pattern = '*.scd, *.sc, *.sc_help, *.quark',
        group = vim.g.au_id.LspSettngs,
        callback = function()
            vim.schedule(function()
                require('luasnip').add_snippets('supercollider', require('scnvim/utils').get_snippets())
            end)
        end,
        once = true,
        desc = 'Lazy load supercollider snippets on filetype',
    })

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
