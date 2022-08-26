vim.opt_local.tabstop = 2
vim.opt_local.tw = 80

vim.keymap.set("n", "<F5>", function()
    require("overseer").run_template { name = "shell", params = { cmd = "glow " .. vim.fn.expand "%" } }
end, { buffer = true, desc = "Run glow" })
