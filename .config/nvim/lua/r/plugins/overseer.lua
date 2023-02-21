local overseer = {
    'stevearc/overseer.nvim',
}

function overseer.init()
    -- ************** Compilers and REPL  ----------------------------------
    local id = {}
    id.Overseer = vim.api.nvim_create_augroup('Overseer', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
        group = id.Overseer,
        pattern = { 'java', 'lua', 'python', 'javascript', 'perl' },
        nested = true,
        callback = function()
            vim.keymap.set('n', '<F5>', function()
                require('overseer').run_template { name = 'Run Single' }
            end, { buffer = true, desc = 'Call native compile command' })

            vim.keymap.set({ 'n', 't' }, '<F10>', function()
                vim.cmd.stopinsert()
                require('r.extensions').toggleTerm(vim.b.repl, 'repl')
            end, { desc = 'Toggle REPL' })
        end,
        desc = 'set compiler and toggleable REPL for capable filetypes',
    })

    require('r.utils').register_au_id(id)

    -- Terminals and Jobs
    vim.keymap.set('n', '<leader>C', function()
        require('overseer').run_template { name = 'shell' }
    end, { desc = 'Run quick command with Overseer' })

    vim.keymap.set('n', '<leader>c', function()
        require('overseer').run_template()
    end, { desc = 'Run task  with Overseer' })
end

function overseer.config()
    require('overseer').setup {
        templates = { 'builtin', 'r' },
        default_template_prompt = 'avoid',
    }
end

return overseer
