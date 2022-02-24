require("which-key").register({
    dd = { "util#qf_delete(bufnr())", "Delete quickfix item", expr = true },
    H = { "<cmd>colder<CR>", "Jump to previous list" },
    L = { "<cmd>cnewer<CR>", "Jump to Next list" },
    d = { "util#qf_delete(bufnr())", "Delete quickfix item", expr = true, mode = "v" },
}, { buffer = 0 })
