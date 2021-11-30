lua << EOF
require("which-key").register({
    dd = { "<cmd>call util#qf_delete(bufnr())<CR>", "Delete quickfix item" },
    H = { "<cmd>colder<CR>", "Jump to previous list" },
    L = { "<cmd>cnewer<CR>", "Jump to Next list" },
}, { buffer = 0 })

require("which-key").register(
    { d = { "<cmd>call util#qf_delete(bufnr()<CR>", "Delete quickfix item" } },
    { mode = "v", buffer = 0 }
)
EOF
