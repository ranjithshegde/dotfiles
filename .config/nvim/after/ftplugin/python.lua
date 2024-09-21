vim.b.repl = 'ipython'
vim.b.make = 'python'
-- vim.keymap.set('n', '<F7>', require('r.extensions.ipython').send_current_line)
-- vim.keymap.set('v', '<F8>', require('r.extensions.ipython').send_visual_selection)

vim.keymap.set('n', '<F7>', '<cmd>REPLSendLine<CR>')
vim.keymap.set('v', '<F8>', '<cmd>REPLSendVisual<CR>')
