setlocal tabstop=2
setlocal tw=80
setlocal colorcolumn=80
lua require("which-key").register({["<F5>"] = {"<cmd><MarkdownPreviewCR>","Preview file"}},{buffer = 0})
