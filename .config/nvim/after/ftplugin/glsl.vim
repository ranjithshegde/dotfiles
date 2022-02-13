setlocal commentstring=//%s
au BufWritePost *.glsl,*.vert,*.frag,*.geom,*.vs,*.fs Dispatch glslangValidator %

lua << EOF
vim.keymap.set( "n", "<leader>s", function()
    if vim.fn.expand("%:e") == "vert" then
        vim.cmd ("e " .. vim.fn.expand("%:r") .. ".frag")
    else
        vim.cmd ("e " .. vim.fn.expand("%:r") .. ".vert")
    end
end, {buffer = 0, silent = true, desc = "Open alternate shader file" })
EOF
