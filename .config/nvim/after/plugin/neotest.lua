local utils = require 'r.utils'

local function nt(cmd, subcmd, args)
    return function()
        if subcmd then
            return require('neotest')[cmd][subcmd](args and args)
        else
            return require('neotest')[cmd]()
        end
    end
end

keys = {
    { '<leader>no', nt('output_panel', 'toggle'), desc = 'Neotest toggle output' },
    { '<leader>ns', nt('output', 'open'), desc = 'Neotest toggle output' },
    { '<leader>nw', nt('watch', 'toggle'), desc = 'Neotest toggle watch' },
    { '<F2>', nt('summary', 'toggle'), desc = 'Neotest Summary' },
    { '<F7>', nt('run', 'run'), desc = 'Neotest Run Nearest' },
    -- Shift F7
    { '<F19>', nt('run', 'run', { strategy = 'dap' }), desc = 'Neotest debug' },
    {
        '<F8>',
        function()
            require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Neotest Run File',
    },
}

vim.pack.add({ 'https://github.com/nvim-neotest/neotest' }, {
    load = function(plug)
        vim.cmd.packadd 'nvim-nio'
        utils.lazy_plugin('neotest', plug.spec.name, function()
            vim.cmd.packadd 'neotest-gtest'
            require('neotest').setup {
                adapters = {
                    require('neotest-gtest').setup {
                        debug_adapter = 'cppdbg',
                    },
                },
            }
        end)
        -- utils.lazy_cmd('Neotest', 'neotest')
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/nvim-neotest/nvim-nio' }, {
    load = function(plug)
        utils.lazy_plugin('nvim-nio', plug.spec.name)
    end,
    confirm = false,
})

vim.pack.add({ 'https://github.com/alfaix/neotest-gtest' }, {
    load = function(plug)
        utils.lazy_plugin('neotest-gtest', plug.spec.name)
    end,
    confirm = false,
})

for _, item in ipairs(keys) do
    local mode = item[4] or 'n'
    local key = item[1]
    local callback = item[2]
    local desc = item[3]
    vim.keymap.set(mode, key, function()
        callback()
    end, { desc = desc })
end
