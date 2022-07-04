local map = vim.keymap.set
map("n", "<F3>", "<cmd>TexWordCount<CR>", { buffer = true, desc = "Word count" })
map("n", "<F4>", "<cmd>Make -C<CR>", { buffer = true, desc = "Clean tex files" })
map("n", "<F5>", "<cmd>TexlabBuild<CR>", { buffer = true, desc = "Compile tex document" })
map("n", "<F6>", "<cmd>TexlabForward<CR>", { buffer = true, desc = "Launch zathura" })

vim.opt.makeprg = "latexmk"
vim.b.gps = 75
vim.opt_local.tw = 150
require("utils.autoload").WordProcessor()
