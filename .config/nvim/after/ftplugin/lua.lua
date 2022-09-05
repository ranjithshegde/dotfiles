local file = vim.fn.expand '%:t:r'
if vim.loop.fs_stat(file .. '.pd_lua') then
    vim.b.isPD = true
end

vim.b.repl = 'rlwrap luajit'
vim.b.make = 'luajit'

vim.keymap.set('n', '<F6>', function()
    vim.cmd.write()
    vim.cmd.source '%'
end, { buffer = true, desc = 'Evaluate current file' })
