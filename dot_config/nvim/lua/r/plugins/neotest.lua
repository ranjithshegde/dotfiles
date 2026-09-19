local tests = {}

local function nt(cmd, subcmd, args)
    return function()
        if subcmd then
            return require('neotest')[cmd][subcmd](args and args)
        else
            return require('neotest')[cmd]()
        end
    end
end

local keys = {
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

function tests.init()
    local id = { Neotest = vim.api.nvim_create_augroup('Neotest', { clear = true }) }

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp' },
        group = id.Neotest,
        callback = function()
            for _, item in ipairs(keys) do
                local mode = item[4] or 'n'
                local key = item[1]
                local callback = item[2]
                local desc = item[3]
                vim.keymap.set(mode, key, function()
                    callback()
                end, { desc = desc })
            end
        end,
    })

    require('r.utils').register_au_id(id)
end

function tests.config()
    require('neotest').setup {
        adapters = {
            require('neotest-gtest').setup {
                debug_adapter = 'cppdbg',
            },
        },
    }
end

return tests
