local function messages()
    require('which-key').register {
        ['<leader>n'] = {
            name = 'Noice',
            n = { vim.cmd.Noice, 'Noice window' },
            e = { vim.cmd.NoiceErrors, 'Open error list' },
            m = { vim.cmd.messages, 'Open messages' },
            c = {
                function()
                    vim.cmd.messages 'clear'
                end,
                'Clear all messaages',
            },
        },
    }
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
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
                -- ['cmp.entry.get_documentation'] = false,
            },
        },
        routes = {
            {
                view = 'mini',
                filter = { event = 'msg_showmode' },
            },
        },
    }
end

function noice.init()
    vim.print = function(...)
        local objects = {}
        for i = 1, select('#', ...) do
            local v = select(i, ...)
            table.insert(objects, vim.inspect(v))
        end
        vim.api.nvim_echo({ { table.concat(objects, '    '), '' } }, true, {})
    end
end

return noice
