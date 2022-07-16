vim.keymap.set("n", "L", "<cmd>cnewer<CR>", { buffer = true, desc = "Jump to Next list" })
vim.keymap.set("n", "H", "<cmd>colder<CR>", { buffer = true, desc = "Jump to previous list" })
vim.keymap.set("n", "dd", require("r.utils.qf").delete, { buffer = true, desc = "Delete quickfix item" })
