require("mappings").tex()
vim.opt.makeprg = "latexmk"
vim.opt_local.tw = 150
vim.fn["util#WordProcessor"]()
