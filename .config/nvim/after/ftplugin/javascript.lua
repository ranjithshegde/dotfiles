vim.b.dispatch = "node %"
vim.g.repl = "node"
vim.keymap.set("n", "<F6>", function()
    vim.api.nvim_cmd({
        cmd = "Dispatch",
        args = { "browser-sync", "start", "--server", "--files", '"*.js,*.html,*.css"' },
        magic = { file = true },
    }, {})
end, { buffer = true, desc = "Launch in browser" })
