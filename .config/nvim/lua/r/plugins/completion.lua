local completion = {}
------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

completion.blink_opts = {
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
    sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
        per_filetype = {
            org = { 'orgmode', 'buffer', 'snippets' },
        },
        providers = {
            snippets = {
                opts = {
                    friendly_snippets = true,
                    extended_filetypes = {
                        markdown = { 'jekyll' },
                        sh = { 'shelldoc' },
                        cpp = { 'unreal' },
                    },
                },
            },
        },
    },
    appearance = { nerd_font_variant = 'mono' },
}

function completion.pairs()
    require('blink.pairs').setup {
        mappings = {
            wrap = {
                ['<C-e>'] = 'treesitter',
                ['<C-S-e>'] = 'treesitter_reverse',
            },
        },
        highlights = {
            enabled = true,
            cmdline = true,
            groups = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterGreen',
                'RainbowDelimiterCyan',
                'RainbowDelimiterViolet',
            },
            unmatched_group = 'HopUnmatched',

            matchparen = {
                enabled = true,
                cmdline = true,
                include_surrounding = false,
                group = 'MatchParen',
                priority = 250,
            },
        },
        -- debug = false,
    }
end

return completion
