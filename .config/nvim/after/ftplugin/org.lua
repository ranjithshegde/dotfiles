vim.opt_local.iskeyword:append ":,#,+"

require("which-key").register({
    ["<CR>"] = { require("utils").fs, "Follow file under cursor" },
    ["<BS>"] = { require("utils").back, "Return to previous file" },
}, { buffer = 0 })
