vim.keymap.set("n", "<F5>", "<cmd>silent !qutebrowser % &<CR>", { buffer = true, desc = "Launch Qutebrowser" })
vim.keymap.set(
    "n",
    "<F6>",
    '<cmd>Dispatch browser-sync start --server --files "*.js,*.html,*.css"<CR>',
    { buffer = true, desc = "Launch in browser" }
)
