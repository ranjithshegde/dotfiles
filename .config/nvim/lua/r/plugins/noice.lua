local noice = {
    'folke/noice.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    event = 'VimEnter',
}

function noice.init()
    require('which-key').add(require 'r.utils.expand_maps' {
        ['<leader>m'] = {
            name = 'Messages',
            n = { vim.cmd.Noice, 'Notifications window' },
            e = { vim.cmd.NoiceErrors, 'Error list' },
            m = { vim.cmd.messages, 'Messages' },
            c = {
                function()
                    vim.cmd.messages 'clear'
                end,
                'Clear all messaages',
            },
        },
    })
end

noice.opts = {
    presets = {
        long_message_to_split = true,
        bottom_search = true,
        command_palette = true,
        inc_rename = true,
    },
    lsp = {
        hover = { enabled = false },
        signature = { enabled = false },
    },
    commands = { history = { view = 'popup' } },
    routes = {
        {
            filter = {
                event = 'msg_show',
                any = {
                    { find = '%d+L, %d+B' },
                    { find = '; after #%d+' },
                    { find = '; before #%d+' },
                    { find = '%d fewer lines' },
                    { find = '%d more lines' },
                    { find = '%dL' },
                },
            },
            opts = { skip = true },
        },
        {
            view = 'mini',
            filter = {
                event = 'msg_show',
                any = {
                    { find = 'E85: There is no listed buffer' },
                    { find = 'E486: Pattern not found: ?$' },
                    { find = 'E490: No fold found' },
                    { find = 'Already at oldest change' },
                    { kind = 'wmsg' },
                },
            },
        },
        {
            view = 'mini',
            filter = { event = 'msg_showmode' },
        },
        {
            view = 'mini',
            filter = { event = 'msg_show' },
        },
    },
}

return noice
