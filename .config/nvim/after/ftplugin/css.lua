local open_cmd = vim.loop.fs_stat(vim.fn.glob 'css/*.css') and vim.fn.glob 'css/*.css' or vim.fn.glob '*.css'

vim.keymap.set('n', '<leader>s', function()
    if vim.fn.expand '%:e' == 'html' then
        vim.cmd.edit(open_cmd)
    else
        vim.cmd.edit 'index.html'
    end
end, { buffer = 0, silent = true, desc = 'Open alternate shader file' })

vim.keymap.set('n', '<F6>', function()
    require('overseer').run_template { name = 'Live server' }
end, { buffer = true, desc = 'Launch in browser' })
