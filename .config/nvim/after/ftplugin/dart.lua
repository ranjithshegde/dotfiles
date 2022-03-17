vim.keymap.set("n", "<F5>", function()
    vim.ui.select({ "aar", "apk", "appbundle", "bundle", "web" }, { prompt = "Compile flutter for: " }, function(choice)
        vim.cmd("Dispatch flutter build " .. choice)
    end)
end, { desc = "Build Flutter", buffer = true })

vim.keymap.set("n", "<F6>", "<cmd>Dispatch flutter run<CR>", { desc = "Run Flutter", buffer = true })
