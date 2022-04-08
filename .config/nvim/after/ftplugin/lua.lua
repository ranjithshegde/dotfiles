vim.b.dispatch = "lua %"
vim.g.repl = "lua"
vim.keymap.set("n", "<F6>", "<cmd>w<cr><cmd>source %<CR>", { buffer = true, desc = "Evaluate current file" })
