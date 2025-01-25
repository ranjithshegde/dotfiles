vim.b.repl = 'ipython'
vim.b.make = 'python'

vim.keymap.set('n', '<F7>', '<cmd>REPLSendLine<CR>')
vim.keymap.set('v', '<F8>', '<cmd>REPLSendVisual<CR>')
