local overseer = {
    'stevearc/overseer.nvim',
}

local map = vim.keymap.set

function overseer.init()
    local id = {}
    id.Overseer = vim.api.nvim_create_augroup('Overseer', { clear = true })

    require('r.plugins.tasks.register').repl(id.Overseer)
    require('r.plugins.tasks.register').LiveServer(id.Overseer)
    require('r.plugins.tasks.register').glow(id.Overseer)
    require('r.plugins.tasks.register').flutter(id.Overseer)

    local get_ft = function()
        local ft = require('r.utils.tables').lspfiles
        table.insert(ft, 'OverseerList')
        return ft
    end

    vim.api.nvim_create_autocmd('FileType', {
        group = id.Overseer,
        pattern = get_ft(),
        callback = function(args)
            map('n', '<F1>', function()
                require('overseer').window.toggle { enter = false, direction = 'left' }
            end, { desc = 'Open Task panel', buffer = args.buf })
        end,
    })

    require('r.utils').register_au_id(id)

    map('n', '<leader>c', function()
        require('overseer').run_template()
    end, { desc = 'Run task  with Overseer' })

    map('n', '<leader>C', function()
        require('overseer').run_template { name = 'shell' }
    end, { desc = 'Run quick command with Overseer' })
end

function overseer.config()
    require('overseer').setup {
        templates = { 'builtin', 'r' },
        default_template_prompt = 'avoid',
    }

    vim.keymap.set('n', '<Space>a', vim.cmd.OverseerQuickAction, { desc = 'Overseer task action list' })
end

return overseer
