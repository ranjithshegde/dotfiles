vim.b.repl = 'node'
vim.b.make = 'node'

vim.keymap.set('n', '<F6>', function()
    require('overseer').run_template { name = 'Live server' }
end, { buffer = true, desc = 'Launch in browser' })
