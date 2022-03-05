vim.opt_local.tabstop = 2
vim.opt_local.tw = 80
require("which-key").register({ ["<F5>"] = { "<cmd>MarkdownPreview<CR>", "Preview file" } }, { buffer = 0 })
vim.fn["util#WordProcessor"]()
