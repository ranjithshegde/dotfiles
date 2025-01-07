return {
    -- File browser/editor
    'stevearc/oil.nvim',
    cmd = 'Oil',
    opts = { columns = { 'icon', 'size' }, view_options = { show_hidden = true } },

    init = function()
        vim.keymap.set('n', '<leader>e', function()
            require('oil').open_float(vim.uv.cwd())
        end, { desc = 'Open file explorer' })
        local id = {}

        id.ProjectDrawer = vim.api.nvim_create_augroup('ProjectDrawer', { clear = true })
        -- ************************ Handle netrw -------------------------------
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufReadPre' }, {
            group = id.ProjectDrawer,
            callback = function(args)
                local fs = vim.uv.fs_stat(args.file)
                if fs and fs.type == 'directory' then
                    if not package.loaded.oil then
                        vim.api.nvim_del_autocmd(args.id)
                        vim.schedule(function()
                            require('oil').open(args.file)
                        end)
                    end
                end
            end,
            desc = 'Hijack netrw with ranger or Oil.nvim',
        })

        vim.api.nvim_create_autocmd('BufEnter', {
            group = id.ProjectDrawer,
            callback = function(args)
                if vim.bo.filetype == 'oil' then
                    vim.keymap.set('n', 'q', vim.cmd.quit, { desc = 'Close file browser', buffer = args.buf })
                end
            end,
            desc = 'Close oil on Q',
        })
        require('r.utils').register_au_id(id)
    end,
}
