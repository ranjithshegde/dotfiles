vim.bo.commentstring = "//%s"

vim.keymap.set("n", "<leader>s", function()
    if vim.fn.expand "%:e" == "vert" then
        vim.cmd.edit(vim.fn.expand "%:r" .. ".frag")
    else
        vim.cmd.edit(vim.fn.expand "%:r" .. ".vert")
    end
end, { buffer = 0, silent = true, desc = "Open alternate shader file" })
