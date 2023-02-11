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
end

function overseer.config()
    require('overseer').setup {
        templates = { 'builtin', 'r' },
        default_template_prompt = 'avoid',
    }

    local make_provider = vim.deepcopy(require 'overseer.template.make')
    local original_cb = make_provider.condition.callback
    make_provider.name = 'make'

    make_provider.condition.callback = function(opts)
        local files = require 'overseer.files'
        if files.is_subpath('/storage/Games/Unreal/', opts.dir) then
            return false, 'Inside repo with large Makefile'
        end
        return original_cb(opts)
    end

    require('overseer').register_template(make_provider)
end

return overseer
