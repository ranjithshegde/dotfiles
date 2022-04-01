vim.keymap.set("n", "<CR>", require("utils").fs, { buffer = true, desc = "Follow file under cursor" })
vim.keymap.set("n", "<BS>", require("utils").back, { buffer = true, desc = "Return to previous file" })
