vim.keymap.set("n", ",K", function()
    vim.fn.execute("h " .. vim.fn.expand "<cword>")
end, { buffer = true, desc = "Help instead of hover" })
vim.keymap.set("n", "<F6>", function()
    vim.cmd "w | source %"
end, { buffer = true, desc = "evaluate current file" })
