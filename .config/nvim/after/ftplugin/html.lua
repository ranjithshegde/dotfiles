require("which-key").register(
    { ["<F5>"] = { "<cmd>silent !qutebrowser % &<CR>", "Launch Qutebrowser" } },
    { ["<F6>"] = { '<cmd>Dispatch browser-sync start --server --files "*.js,*.html,*.css"<CR>', "Launch in browser" } },
    { buffer = 0 }
)
