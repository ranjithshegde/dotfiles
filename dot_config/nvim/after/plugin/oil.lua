local utils = require 'r.utils'

vim.pack.add({
    'https://github.com/stevearc/oil.nvim',
}, {
    load = function(plug)
        utils.lazy_plugin('oil', plug.spec.name, function()
            require('oil').setup {
                columns = { 'icon', 'size' },
                view_options = { show_hidden = true },
                keymaps = {
                    ['<C-c>'] = false,
                    ['<C-h>'] = false,
                    ['q'] = { 'actions.close', mode = 'n' },
                    ['<C-f>'] = { 'actions.preview_scroll_down', mode = 'n' },
                    ['<C-b>'] = { 'actions.preview_scroll_up', mode = 'n' },
                    ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
                    ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
                },
            }
        end)

        utils.lazy_command('Oil', 'oil')

        vim.keymap.set('n', '<leader>e', function()
            require('oil').open_float(vim.uv.cwd())
        end, { desc = 'Open file explorer' })

        vim.keymap.set('n', '<leader>E', function()
            require('oil').open_float()
        end, { desc = 'Open file explorer from current file dir' })

        local id = { ProjectDrawer = vim.api.nvim_create_augroup('ProjectDrawer', { clear = true }) }

        -- ************************ Handle netrw -------------------------------
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufReadPre' }, {
            group = id.ProjectDrawer,
            callback = function(args)
                local fs = vim.uv.fs_stat(args.file)
                if fs and fs.type == 'directory' and not package.loaded.oil then
                    vim.api.nvim_del_autocmd(args.id)
                    vim.schedule(function()
                        require('oil').open(args.file)
                    end)
                end
            end,
            desc = 'Hijack netrw with Oil.nvim',
        })

        utils.register_au_id(id)
    end,
    confirm = false,
})
