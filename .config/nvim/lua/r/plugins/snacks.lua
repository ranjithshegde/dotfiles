return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = {
            sections = {
                { section = 'header' },
                { section = 'keys', gap = 1, padding = 1 },
                {
                    title = 'Orgmode',
                    icon = ' ',
                },
                {
                    title = 'Agenda',
                    indent = 3,
                    action = ':lua require("orgmode").agenda:agenda()',
                    key = 'a',
                },
                {
                    title = 'Capture',
                    indent = 3,
                    action = '<leader>oc',
                    key = 'C',
                    padding = 1,
                    gap = 2,
                },
                { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
                { section = 'startup' },
            },
        },
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
        notifier = { enabled = true },
        scope = { enabled = true, treesitter = { blocks = { enabled = true } } },
        lazygit = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true, jumplist = false },
        zen = { toggle = { dim = true } },
    },
    keys = {
        {
            ']r',
            function()
                ---@diagnostic disable-next-line
                Snacks.words.jump(vim.v.count1)
            end,
            desc = 'Next Reference',
            mode = { 'n', 't' },
        },
        {
            '[r',
            function()
                ---@diagnostic disable-next-line
                Snacks.words.jump(-vim.v.count1)
            end,
            desc = 'Prev Reference',
            mode = { 'n', 't' },
        },
        {
            '<leader>.',
            function()
                ---@diagnostic disable-next-line
                Snacks.scratch()
            end,
            desc = 'Create scratch buffer',
        },
        {
            '<leader>s',
            function()
                ---@diagnostic disable-next-line
                Snacks.scratch.select()
            end,
            desc = 'Select scratch buffer',
        },
    },
}
