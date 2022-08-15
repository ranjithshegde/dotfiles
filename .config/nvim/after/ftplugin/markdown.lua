vim.opt_local.tabstop = 2
vim.opt_local.tw = 80

vim.keymap.set("n", "<F5>", function ()
    vim.cmd.OverseerRunCmd("glow " .. vim.fn.expand("%"))
end, {buffer = true, desc = "Run glow"})
