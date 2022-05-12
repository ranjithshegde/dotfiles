vim.b.dispatch = "dart %"
vim.keymap.set("n", "<F5>", function()
    vim.ui.select({ "aar", "apk", "appbundle", "bundle", "web" }, { prompt = "Compile flutter for: " }, function(choice)
        vim.cmd { cmd = "Dispatch", args = { "flutter", "build", choice } }
    end)
end, { desc = "Build Flutter", buffer = true })

vim.keymap.set("n", "<F6>", function()
    vim.cmd { cmd = "Dispatch", args = { "flutter", "run" } }
end, { desc = "Run Flutter", buffer = true })

vim.keymap.set("n", "<F4>", function()
    vim.cmd "Dispatch"
end, { desc = "Run single file Dart", buffer = true })
