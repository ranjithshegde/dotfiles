local map = vim.keymap.set
map('n', '<F3>', vim.cmd.WordCount, { buffer = true, desc = 'Word count' })

map('n', '<F4>', function()
    require('r.plugins.lsp.texlab').tex_clean()
end, { buffer = true, desc = 'Clean tex files' })

map('n', '<F5>', vim.cmd.TexlabBuild, { buffer = true, desc = 'Compile tex document' })
map('n', '<F6>', vim.cmd.TexlabForward, { buffer = true, desc = 'Launch zathura' })

vim.bo.makeprg = 'latexmk'
vim.b.gps = 75
vim.bo.textwidth = 148
require('r.extensions').WordProcessor()
