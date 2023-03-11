local file = vim.fn.expand '%:t:r'
if vim.loop.fs_stat(file .. '.pd_lua') then
    vim.b.isPD = true
end

vim.b.repl = 'rlwrap luajit'
vim.b.make = 'luajit'

require('r.utils').write_and_source(0)
