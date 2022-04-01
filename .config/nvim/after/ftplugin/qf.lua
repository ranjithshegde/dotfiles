vim.keymap.set("n", "L", "<cmd>cnewer<CR>", { buffer = true, desc = "Jump to Next list" })
vim.keymap.set("n", "H", "<cmd>colder<CR>", { buffer = true, desc = "Jump to previous list" })
vim.keymap.set("v", "d", "util#qf_delete(bufnr())", { buffer = true, expr = true, desc = "Delete quickfix item" })
vim.keymap.set("n", "dd", "util#qf_delete(bufnr())", { buffer = true, expr = true, desc = "Delete quickfix item" })
