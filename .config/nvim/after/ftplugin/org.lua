vim.keymap.set("n", "<CR>", require("org").followOrCreate, { buffer = true, desc = "Follow file under cursor" })
vim.keymap.set("n", "<BS>", require("org").back, { buffer = true, desc = "Return to previous file" })
vim.keymap.set("n", "]w", require("org").gotoNext, { buffer = true, desc = "Jump to next link" })
vim.keymap.set("n", "[w", require("org").gotoPrev, { buffer = true, desc = "Jump to previous link" })
