vim.pretty_print = function(...)
    local msg = vim.inspect(...)
    vim.notify(msg, vim.log.levels.OFF)
end

require('noice').setup {
    cmdline = {
        view = 'cmdline',
        view_search = 'cmdline',
        format = {
            inc_rename = { pattern = '^:%s*IncRename%s+', icon = ' ', ft = 'text' },
        },
    },
    presets = {
        long_message_to_split = true,
    },
    lsp = {
        hover = { enabled = true, opts = { border = { style = 'single' } } },
        signature = { enabled = true, opts = { border = { style = 'rounded' } } },
        documentation = {
            opts = {
                position = { row = 2 },
                win_options = {
                    concealcursor = '',
                    winhighlight = { Normal = 'LspFloat', FloatBorder = 'LspFloatBorder' },
                },
            },
        },
    },
    routes = {
        {
            view = 'mini',
            filter = { event = 'msg_showmode' },
        },
        {
            view = 'split',
            filter = { event = 'notify', min_height = 20 },
            opts = { enter = true, lang = 'lua' },
        },
    },
}
