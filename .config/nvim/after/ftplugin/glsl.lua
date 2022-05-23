vim.bo.commentstring = "//%s"

vim.keymap.set("n", "<leader>s", function()
    if vim.fn.expand "%:e" == "vert" then
        vim.cmd("e " .. vim.fn.expand "%:r" .. ".frag")
    else
        vim.cmd("e " .. vim.fn.expand "%:r" .. ".vert")
    end
end, { buffer = 0, silent = true, desc = "Open alternate shader file" })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = "MakeDispatch",
    buffer = 0,
    command = "Dispatch glslangValidator %",
    desc = "Glsl linter",
})
