local wk = require 'which-key'
local map = vim.keymap.set

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

------------------------------------------------------------------------
--                              General mappings                      --
------------------------------------------------------------------------

return function()
    local opts = { nowait = true, silent = true }
    -- Extend C-keys
    map('n', '<C-;>', ';')
    map('n', '<C-,>', ',')
    map('n', '<C-i>', '<C-i>', { desc = 'Dont map C-i to Tab' })
    map({ 'n', 'i', 's' }, '<BS>', '<BS>', { desc = 'Dont map C-h to backspace' })

    --line movement
    map('x', 'K', ":move '<-2<CR>gv", { desc = 'Move line up' })
    map('x', 'J', ":move '>+1<CR>gv", { desc = 'Move line down' })
    -- visual cut for replase
    map({ 'v', 's' }, 'P', '"_dP', opts)
    -- Indent
    map('v', '<', '<gv', opts)
    map('v', '>', '>gv', opts)

    -- Toggle folds
    map('n', '<Tab>', 'za', { desc = 'Toggle fold current' })
    map('n', '<S-Tab>', 'zA', { desc = 'Toggle fold All' })
    -- open folds when searching
    map('n', 'n', 'nzzzv', { desc = 'jump to next search result' })
    map('n', 'N', 'Nzzzv', { desc = 'jump to previous search result' })
    map('n', 'J', 'mzJ`z', { desc = 'Adjoin next line' })

    map('n', '<leader>e', function()
        vim.cmd.Oil(vim.loop.cwd())
    end, { desc = 'Open file explorer' })

    --Quickfix
    map('n', '-', function()
        require('r.extensions.qf').toggle_qf 'q'
    end, { desc = 'Toggle quickfix' })
    map('n', '_', function()
        require('r.extensions.qf').toggle_qf 'l'
    end, { desc = 'Toggle loclist' })
    -- ScratchPad
    map('n', '<leader>S', function()
        require 'r.extensions.project.scratchpad' 'tab'
    end, { desc = 'Open ScratchPad' })

    -- Misc
    map('n', 'gx', function()
        local word = vim.fn.expand '<cWORD>'
        local begin = word:find '%('
        if begin then
            word = word:sub(begin + 1):gsub('%)', '')
        else
            begin = word:find '%['
            if begin then
                word = word:gsub('%[', '')
                local ends = word:find '%]'
                if ends then
                    word = word:sub(begin, ends - 1)
                end
            end
        end

        require('r.utils').open_in_browser(word)
    end, { desc = 'exec word under cursor' })

    map('n', 'gm', function()
        local virt = vim.fn.virtcol '$'
        vim.fn.cursor { 0, virt / 2 }
    end, { desc = 'Move cursor to middle of the line' })

    -- Terminals and Jobs
    map('n', '<leader>C', function()
        require('overseer').run_template { name = 'shell' }
    end, { desc = 'Run quick command with Overseer' })

    map('n', '<leader>c', function()
        require('overseer').run_template()
    end, { desc = 'Run task  with Overseer' })

    map({ 'n', 't' }, '<F9>', function()
        vim.cmd.stopinsert()
        require('r.extensions').toggleTerm('zsh', 'shell', 1)
    end, {
        desc = 'Toggle current/default terminal',
    })

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

    map('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })
end
