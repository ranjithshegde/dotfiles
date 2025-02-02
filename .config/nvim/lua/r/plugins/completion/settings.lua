local completion = {}
------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

local function cmp_setup()
    require('blink.cmp').setup {
        completion = {
            keyword = { range = 'full' },
            ghost_text = { enabled = true },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                window = { border = 'single' },
            },
            menu = {
                draw = { treesitter = { 'lsp' } },
                auto_show = function(ctx)
                    --     return ctx.mode ~= 'cmdline' or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                    return not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                end,
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
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
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<C-e>'] = { 'cancel', 'fallback' },
                ['<C-y>'] = { 'select_and_accept' },
                ['<Esc>'] = {
                    function(cmp)
                        if cmp.is_visible() then
                            cmp.cancel()
                        else
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true)
                        end
                    end,
                },
            },
        },
        snippets = { preset = 'luasnip' },
        sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
            per_filetype = {
                org = { 'orgmode', 'buffer', 'snippets' },
            },
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    score_offset = 100,
                    enabled = function()
                        return vim.bo.filetype == 'lua' or vim.bo.filetype == 'pd_lua'
                    end,
                },
            },
        },
        appearance = { nerd_font_variant = 'mono' },
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

    if vim.b.cpp_type and vim.b.cpp_type == 'Unreal' then
        require('luasnip').filetype_extend('cpp', { 'unreal' })
    end
end

return completion
