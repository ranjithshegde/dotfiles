local completion = {}

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

local function cmp_setup()
    require('blink.cmp').setup {
        completion = {
            accept = {
                create_undo_point = true,
                auto_brackets = { enabled = true },
            },
            ghost_text = { enabled = true },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                window = { border = 'single' },
            },
            menu = {
                draw = { treesitter = { 'lsp' } },
                auto_show = function(ctx)
                    return ctx.mode ~= 'cmdline' or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                end,
            },
            list = {
                selection = function(ctx)
                    return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
                end,
            },
        },
        keymap = {
            preset = 'default',
            ['<C-l>'] = { 'snippet_forward', 'fallback' },
            ['<C-h>'] = { 'snippet_backward', 'fallback' },
            ['<Return>'] = { 'select_and_accept', 'fallback' },
            ['<Tab>'] = { 'select_and_accept', 'fallback' },
            ['<S-Tab>'] = { 'fallback' },
            cmdline = {
                ['<CR>'] = { 'accept', 'fallback' },
                ['<Esc>'] = { 'hide', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<C-e>'] = { 'cancel', 'fallback' },
                ['<C-y>'] = { 'select_and_accept' },
            },
        },
        -- signature = { enabled = true },
        snippets = {
            expand = function(snippet)
                require('luasnip').lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then
                    return require('luasnip').jumpable(filter.direction)
                end
                return require('luasnip').in_snippet()
            end,
            jump = function(direction)
                require('luasnip').jump(direction)
            end,
        },
        sources = {
            default = { 'lsp', 'path', 'luasnip', 'buffer' },
        },
    }
end

function completion.init()
    cmp_setup()
    require('luasnip.loaders.from_vscode').lazy_load()
end

function completion.pairs()
    local npairs = require 'nvim-autopairs'
    npairs.setup {
        check_ts = true,
        fast_wrap = {
            map = '<C-e>',
        },
        enable_check_bracket_line = false,
    }
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
end

function completion.luasnip()
    local types = require 'luasnip.util.types'
    require('luasnip').config.set_config {
        history = true,
        update_events = { 'InsertLeave', 'TextChanged', 'TextChangedI' },
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
