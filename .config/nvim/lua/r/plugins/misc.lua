return {
    'folke/snacks.nvim',
    priority = 1000,
    event = 'VimEnter',
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
        lazygit = { enabled = true },
        statuscolumn = { enabled = true },
        zen = { toggle = { dim = true } },
    },
}
