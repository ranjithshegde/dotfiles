vim.b.dispatch = "node %"
vim.g.repl = "node"
vim.keymap.set(
    "n",
    "<F6>",
    '<cmd>Dispatch browser-sync start --server --files "*.js,*.html,*.css"<CR>',
    { buffer = true, desc = "Launch in browser" }
)
