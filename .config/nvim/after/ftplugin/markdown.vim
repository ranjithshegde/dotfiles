setlocal tabstop=2
setlocal tw=80
lua require("which-key").register({["<F5>"] = {"<cmd>MarkdownPreview<CR>","Preview file"}},{buffer = 0})
