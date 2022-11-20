vim.keymap.set('n', 'L', vim.cmd.cnewer, { buffer = true, desc = 'Jump to Next list' })
vim.keymap.set('n', 'H', vim.cmd.colder, { buffer = true, desc = 'Jump to previous list' })
vim.keymap.set('n', 'dd', require('r.extensions.qf').delete, { buffer = true, desc = 'Delete quickfix item' })
vim.keymap.set({ 'v' }, 'd', require('r.extensions.qf').delete, { buffer = true, desc = 'Delete quickfix item' })
