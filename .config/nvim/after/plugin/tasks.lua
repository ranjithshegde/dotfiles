-- tag = 'v1.6.0',
local utils = require 'r.utils'
local map = vim.keymap.set

local function init()
    local id = { Overseer = vim.api.nvim_create_augroup('Overseer', { clear = true }) }

    require('r.plugins.tasks.register').cpp(id.Overseer)
    require('r.plugins.tasks.register').repl(id.Overseer)
    require('r.plugins.tasks.register').LiveServer(id.Overseer)
    require('r.plugins.tasks.register').glow(id.Overseer)

    local cached_ft = nil
    local get_ft = function()
        if cached_ft then
            return cached_ft
        end
        cached_ft = require('r.utils.tables').lspfiles
        table.insert(cached_ft, 'OverseerList')
        return cached_ft
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

local function config()
    require('overseer').setup {
        templates = { 'builtin', 'r' },
        default_template_prompt = 'avoid',
    }

    vim.keymap.set('n', '<Space>a', vim.cmd.OverseerQuickAction, { desc = 'Overseer task action list' })
end

vim.pack.add({ { src = 'https://github.com/stevearc/overseer.nvim', version = 'v1.6.0' } }, {
    load = function(plug)
        utils.lazy_plugin('overseer', plug.spec.name, function()
            config()
        end)
    end,
    confirm = false,
})

init()
