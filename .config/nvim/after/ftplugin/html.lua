vim.keymap.set("n", "<F5>", "<cmd>silent !qutebrowser % &<CR>", { buffer = true, desc = "Launch Qutebrowser" })
vim.keymap.set("n", "<F6>", function()
    vim.api.nvim_cmd({
        cmd = "Dispatch",
        args = { "browser-sync", "start", "--server", "--files", '"*.js,*.html,*.css"' },
        magic = { file = true },
    }, {})
end, { buffer = true, desc = "Launch in browser" })
