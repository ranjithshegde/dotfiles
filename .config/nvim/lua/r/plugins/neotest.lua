local function nt(cmd, subcmd, args)
    return function()
        if subcmd then
            return require('neotest')[cmd][subcmd](args and args)
        else
            return require('neotest')[cmd]()
        end
    end
end

return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'ranjithshegde/neotest-gtest', branch = 'treesitter_main_fix' },
        'nvim-neotest/nvim-nio',
    },
    config = function()
        require('neotest').setup {
            adapters = {
                require('neotest-gtest').setup {
                    debug_adapter = 'cppdbg',
                },
            },
        }
    end,
    cmd = 'Neotest',
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
    },
}
