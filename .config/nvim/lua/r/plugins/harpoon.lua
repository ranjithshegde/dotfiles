local num = 1
local function open_term(split)
    return function()
        local open_num = nil
        if vim.v.count ~= 0 then
            open_num = vim.v.count
        else
            open_num = num
            num = num + 1
        end
        vim.notify('Opening terminal indexed ' .. open_num)
        if not split then
            require('harpoon.term').gotoTerminal(open_num)
            return
        end
        local args = { idx = open_num }
        if split == 'split' then
            args.create_with = 'botright new | terminal'
        elseif split == 'vsplit' then
            args.create_with = 'belowright vnew | terminal'
        elseif split == 'tabnew' then
            args.create_with = 'tabnew | terminal'
        end
        require('harpoon.term').gotoTerminal(args)
    end
end

local function toggle_term()
    local wk = require 'which-key'
    local map = vim.keymap.set
    wk.register {
        ['<leader>t'] = {
            name = 'Launch terminal in split',
            h = { open_term 'split', 'Horizontal' },
            v = { open_term 'vsplit', 'Vertical' },
            t = { open_term 'tabnew', 'New tab' },
        },
    }

    map('n', "<leader>'", function()
        require('harpoon.ui').nav_next()
    end, { desc = 'Navigate to next harpooned file' })

    map('n', '<leader>`', function()
        require('harpoon.ui').nav_prev()
    end, { desc = 'Navigate to previous harpooned file' })

    map('n', '<leader><Tab>', open_term(), { desc = 'Navigate to harpooned terminal' })

    map('n', '<leader><leader>', function()
        require('harpoon.ui').toggle_quick_menu()
    end, { desc = 'Open harpoon list' })

    map('n', '<leader><Space>', function()
        require('harpoon.mark').add_file()
    end, { desc = 'Harpoon current file' })
end

local harpoon = {
    'ThePrimeagen/harpoon',
}

-- ************** Load harpoon maps ------------------------------------
function harpoon.init()
    local id = {}
    id.Harpoon = vim.api.nvim_create_augroup('Harpoon', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'harpoon',
        group = id.Harpoon,
        callback = function()
            vim.keymap.set('n', '<C-v>', function()
                local curline = vim.api.nvim_get_current_line()
                local working_directory = vim.fn.getcwd() .. '/'
                vim.cmd 'vs'
                vim.cmd('e ' .. working_directory .. curline)
            end, { noremap = true, silent = true })

            vim.keymap.set('n', '<C-t>', function()
                local curline = vim.api.nvim_get_current_line()
                local working_directory = vim.fn.getcwd() .. '/'
                vim.cmd 'tabnew'
                vim.cmd('e ' .. working_directory .. curline)
            end, { noremap = true, silent = true })
        end,
        desc = 'Make harpoon open in splits',

        toggle_term(),
    })

    require('r.utils').register_au_id(id)
end

return harpoon
