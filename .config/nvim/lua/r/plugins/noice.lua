local function messages()
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

local noice = {
    'folke/noice.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    event = 'VimEnter',
}

function noice.config()
    messages()
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
        commands = { history = { view = 'popup' } },
        lsp = {
            hover = {
                opts = { border = { style = 'rounded' } },
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
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
            },
        },
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
                filter = { event = 'msg_showmode' },
            },
            {
                view = 'mini',
                filter = { event = 'msg_show' },
            },
        },
    }
end

function noice.init()
    vim.print = function(...)
        if package.loaded.snacks then
            return Snacks.debug.inspect(...)
        else
            local objects = {}
            for i = 1, select('#', ...) do
                local v = select(i, ...)
                table.insert(objects, vim.inspect(v))
            end
            vim.api.nvim_echo({ { table.concat(objects, '    '), '' } }, true, {})
        end
    end
end

return noice
