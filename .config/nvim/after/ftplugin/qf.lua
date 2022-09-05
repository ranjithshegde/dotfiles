vim.keymap.set('n', 'L', vim.cmd.cnewer, { buffer = true, desc = 'Jump to Next list' })
vim.keymap.set('n', 'H', vim.cmd.colder, { buffer = true, desc = 'Jump to previous list' })
vim.keymap.set('n', 'dd', require('r.utils.qf').delete, { buffer = true, desc = 'Delete quickfix item' })
