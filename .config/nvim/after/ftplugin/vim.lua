vim.keymap.set('n', ',K', function()
    vim.cmd.help(vim.fn.expand '<cword>')
end, { buffer = true, desc = 'Help instead of hover' })

vim.keymap.set('n', '<F6>', function()
    vim.cmd.write()
    vim.cmd.source '%'
end, { buffer = true, desc = 'Evaluate current file' })
