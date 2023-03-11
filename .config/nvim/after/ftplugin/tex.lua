vim.keymap.set('n', '<F3>', vim.cmd.WordCount, { buffer = true, desc = 'Word count' })

vim.bo.makeprg = 'latexmk'
vim.b.gps = 75
vim.bo.textwidth = 148
require('r.extensions').WordProcessor()
