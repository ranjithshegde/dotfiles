local utils = require 'r.utils'

local function init()
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

local opts = {
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

vim.pack.add({ 'https://github.com/MunifTanjim/nui.nvim' }, {
    load = function(plug)
        require('r.utils').lazy_plugin('nui', plug.spec.name)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/folke/noice.nvim' }, {
    load = function(plug)
        require('r.utils').lazy_plugin('noice', plug.spec.name, function()
            vim.cmd.packadd 'nui.nvim'
            require('noice').setup(opts)
        end)

        utils.lazy_event('VimEnter', 'noice')
    end,
    confirm = false,
})

init()
