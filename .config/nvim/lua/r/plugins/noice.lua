vim.pretty_print = function(...)
    local objects = {}
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    vim.api.nvim_echo({ { table.concat(objects, '    '), '' } }, true, {})
end

require('noice').setup {
    cmdline = {
        view = 'cmdline',
        view_search = 'cmdline',
        format = {
            inc_rename = { pattern = '^:%s*IncRename%s+', icon = ' ', ft = 'text' },
            input = { icon = ' ', lang = 'text', view = 'cmdline_popup' },
        },
    },
    presets = {
        long_message_to_split = true,
    },
    lsp = {
        hover = {
            opts = { border = { style = 'single' } },
        },
        signature = {
            opts = { border = { style = 'rounded' } },
        },
        documentation = {
            opts = {
                position = { row = 2 },
                win_options = {
                    concealcursor = '',
                    winhighlight = { Normal = 'LspFloat', FloatBorder = 'LspFloatBorder' },
                },
            },
        },
        override = {
            ['vim.lsp.util.stylize_markdown'] = true,
        },
    },
    routes = {
        {
            view = 'mini',
            filter = { event = 'msg_showmode' },
        },
    },
}
