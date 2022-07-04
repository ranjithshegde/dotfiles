local file = vim.fn.expand "%:t:r"
if vim.loop.fs_stat(file .. ".pd_lua") then
    vim.b.isPD = true
end

vim.b.dispatch = "lua %"
vim.g.repl = "lua"

vim.keymap.set("n", "<F6>", "<cmd>w<cr><cmd>source %<CR>", { buffer = true, desc = "Evaluate current file" })
