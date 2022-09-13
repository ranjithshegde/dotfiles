vim.bo.tabstop = 2
vim.o.textwidth = 80

vim.keymap.set('n', '<F5>', function()
    require('overseer').run_template { name = 'shell', params = { cmd = 'glow ' .. vim.fn.expand '%' } }
end, { buffer = true, desc = 'Run glow' })
