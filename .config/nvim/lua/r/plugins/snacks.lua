return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = { enabled = true },
        dim = { enabled = true },
        gitbrowse = { enabled = true },
        indent = {
            animate = { enabled = false },
            only_current = true,
            scope = {
                enabled = true,
                underline = true,
            },
        },
        scope = { enabled = true, treesitter = { blocks = { enabled = true } } },
        -- picker = { enabled = true },
        lazygit = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true, jumplist = false },
        zen = { toggle = { dim = true } },
    },
    keys = {
        {
            ']]',
            function()
                Snacks.words.jump(vim.v.count1)
            end,
            desc = 'Next Reference',
            mode = { 'n', 't' },
        },
        {
            '[[',
            function()
                Snacks.words.jump(-vim.v.count1)
            end,
            desc = 'Prev Reference',
            mode = { 'n', 't' },
        },
    },
}
