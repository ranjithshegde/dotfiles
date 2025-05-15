local completion = {}
------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

local blink_opts = {
    enabled = function()
        return not vim.tbl_contains({ 'org-roam-select' }, vim.bo.filetype)
            and vim.bo.buftype ~= 'prompt'
            and vim.b.completion ~= false
    end,
    completion = {
        keyword = { range = 'full' },
        ghost_text = { enabled = true },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
        },
        menu = {
            draw = {
                treesitter = { 'lsp', 'buffer', 'snippets' },
                columns = {
                    { 'label', 'label_description', gap = 1 },
                    { 'kind_icon', gap = 1, 'kind' },
                },
            },
            border = 'none',
        },
        list = {
            selection = {
                preselect = false,
            },
        },
    },
    keymap = {
        preset = 'default',
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'fallback' },
        ['<S-Tab>'] = { 'fallback' },
    },
    cmdline = {
        completion = { ghost_text = { enabled = false } },
        keymap = {
            preset = 'cmdline',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
            ['<C-n>'] = { 'show_and_insert', 'select_next' },
            ['<C-p>'] = { 'show_and_insert', 'select_prev' },
        },
    },
    snippets = { preset = 'luasnip' },
    sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
        per_filetype = {
            org = { 'orgmode', 'buffer', 'snippets' },
        },
    },
    appearance = { nerd_font_variant = 'mono' },
}

function completion.blink()
    require('blink.cmp').setup(blink_opts)
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
    local luasnip = require 'luasnip'
    local types = require 'luasnip.util.types'
    luasnip.config.set_config {
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

    require('luasnip.loaders.from_vscode').lazy_load()

    local id = { UnrealSnip = vim.api.nvim_create_augroup('UnrealSnip', { clear = true }) }
    vim.api.nvim_create_autocmd('FileType', {
        group = id.UnrealSnip,
        pattern = { 'c', 'cpp' },
        callback = function()
            if vim.b.cpp_type and vim.b.cpp_type == 'Unreal' then
                luasnip.filetype_extend('cpp', { 'unreal' })
            end
        end,
        desc = 'Load UE5 snippets in UECpp files',
    })
    require('r.utils').register_au_id(id)

    vim.keymap.set({ 'i', 's' }, '<C-s>', function()
        if luasnip.choice_active() then
            require 'luasnip.extras.select_choice'()
        end
    end, { desc = 'Select choice' })
end

return completion
