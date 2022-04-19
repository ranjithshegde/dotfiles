require("mappings.filetypes").tex()
vim.opt.makeprg = "latexmk"
vim.b.gps = 75
vim.opt_local.tw = 150
vim.fn["util#WordProcessor"]()
