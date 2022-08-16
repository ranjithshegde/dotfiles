local map = vim.keymap.set
map("n", "<F3>", vim.cmd.WordCount, { buffer = true, desc = "Word count" })

map("n", "<F4>", function()
    vim.cmd.OverseerRunCmd { args = { "latexmk", "-C", "-outdir=aux" } }
end, { buffer = true, desc = "Clean tex files" })

map("n", "<F5>", vim.cmd.TexlabBuild, { buffer = true, desc = "Compile tex document" })
map("n", "<F6>", vim.cmd.TexlabForward, { buffer = true, desc = "Launch zathura" })

vim.opt.makeprg = "latexmk"
vim.b.gps = 75
vim.opt_local.tw = 148
require("r.utils.extensions").WordProcessor()
