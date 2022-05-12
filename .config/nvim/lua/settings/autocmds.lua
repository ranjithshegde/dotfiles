local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auexec = vim.api.nvim_exec_autocmds
local exec = vim.api.nvim_command
local opts = { clear = true }

------------------------------------------------------------------------
--                              AutoCommands                          --
------------------------------------------------------------------------

-- ************** Format handling  ---------------------------------------

augroup("FormatOptions", opts)
aucmd("FileType", {
    group = "FormatOptions",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            - "a" -- Dont format pasted code
            - "t" -- Delegate to linter prgs/LSP
            - "o" -- O and o don't continue comments
            - "r" -- Return does not continue comments
            + "c" -- comments respect textwidth
            + "q" -- Allow formatting comments w/ gq
            + "n" -- Recognize numbered lists
            + "j" -- Auto-remove comments if possible.
            + "2" -- Indent according to 2nd line
    end,
})

aucmd({ "InsertEnter", "WinLeave", "FocusLost", "BufNewFile", "BufReadPost" }, {
    group = "FormatOptions",
    callback = function()
        if vim.tbl_contains(require("utils.tables").ignoreFiles, vim.api.nvim_buf_get_option(0, "filetype")) then
            return
        end
        vim.opt.relativenumber = false
    end,
})
aucmd({ "InsertLeave", "WinEnter", "FocusGained" }, {
    group = "FormatOptions",
    callback = function()
        if vim.tbl_contains(require("utils.tables").ignoreFiles, vim.api.nvim_buf_get_option(0, "filetype")) then
            return
        end
        vim.opt.relativenumber = true
    end,
})
aucmd("FileType", {
    group = "FormatOptions",
    callback = function()
        if vim.tbl_contains(require("utils.tables").ignoreFiles, vim.api.nvim_buf_get_option(0, "filetype")) then
            vim.opt_local.foldenable = false
        end
    end,
})

-- ************** Lsp Configuration loading  ------------------------------

augroup("LspSettings", opts)
aucmd("FileType", {
    group = "LspSettings",
    pattern = "vim",
    callback = function()
        vim.keymap.set("n", ",K", function()
            vim.fn.execute("h " .. vim.fn.expand "<cword>")
        end, { buffer = true, desc = "Help instead of hover" })
        vim.keymap.set("n", "<F6>", function()
            vim.cmd "w | source %"
        end, { buffer = true, desc = "evaluate current file" })
    end,
})
aucmd("FileType", {
    group = "LspSettings",
    pattern = require("utils.tables").lspfiles,
    callback = function()
        require("lsp").settings()
        require("lsp").servers()
        require("lsp").lintFormat()
        auexec("FileType", { group = "lspconfig" })
    end,
    once = true,
})
aucmd("FileType", {
    group = "LspSettings",
    pattern = "opencl",
    callback = function()
        require("mappings.clang").clang()
    end,
})
-- ************** Treesitter --------------------------------------
augroup("TreeSitter", opts)
aucmd("BufReadPost", {
    group = "TreeSitter",
    callback = function()
        require "mappings.treesitter"
    end,
})

-- ************** Compilers and REPL  ------------------------------
augroup("MakeDispatch", opts)
aucmd("FileType", {
    group = "MakeDispatch",
    pattern = { "java", "lua", "python", "javascript" },
    nested = true,
    callback = function()
        vim.keymap.set("n", "<F5>", function()
            vim.cmd "w | redraw"
            vim.cmd "Dispatch"
        end, { buffer = true, desc = "Call native compile Dispatch command" })

        vim.keymap.set({ "n", "t" }, "<F10>", function()
            vim.cmd "stopinsert"
            require("utils").toggleTerm(vim.g.repl, "repl")
        end, { desc = "Toggle REPL" })
    end,
})
aucmd("BufWritePost", {
    group = "MakeDispatch",
    pattern = { "*.glsl", "*.vert", "*.frag", "*.geom", "*.vs", "*.fs", "*.gs" },
    command = "Dispatch glslangValidator %",
})

-- Compile packer after writing plugins.lua
augroup("PluginLoad", opts)
aucmd("BufWritePost", {
    group = "PluginLoad",
    pattern = "plugins.lua",
    callback = function()
        exec "source <afile>"
        require("packer").compile()
    end,
})
aucmd("BufReadPost", {
    group = "PluginLoad",
    callback = function()
        require "mappings.pairs"
    end,
})
aucmd("BufReadPost", { group = "PluginLoad", command = "packadd matchit", once = true })
aucmd("User", { pattern = "PackerComplete", group = "PluginLoad", command = "LuaCacheClear" })

-- ************************ Terminal management --------------------

augroup("TermInsertModes", opts)
aucmd(
    { "BufEnter", "BufWinEnter", "TermOpen" },
    { group = "TermInsertModes", pattern = { "term://*", "shell" }, command = "startinsert" }
)
aucmd("TermEnter", { group = "TermInsertModes", command = "startinsert" })
aucmd("TermEnter", {
    group = "TermInsertModes",
    callback = function()
        local fs = vim.fn.expand "%"
        if fs:match "ranger" then
            vim.keymap.set("t", "<S-Esc>", "<C-\\><C-n>", { buffer = true, desc = "Escape Insert" })
        else
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = true, desc = "Escape Insert" })
        end
    end,
})
aucmd("TermClose", {
    group = "TermInsertModes",
    callback = function()
        vim.api.nvim_input "<CR>"
    end,
})

augroup("ProjectDrawer", opts)
aucmd("WinEnter", {
    group = "ProjectDrawer",
    callback = function()
        if
            vim.fn.winnr "$" == 1
            and vim.api.nvim_buf_get_option(vim.fn.winbufnr(vim.fn.winnr()), "filetype") == "netrw"
        then
            vim.cmd "q"
        end
    end,
})
aucmd("FileType", {
    pattern = "netrw",
    group = "ProjectDrawer",
    callback = function()
        vim.opt_local.fillchars:append "vert:║"
        vim.keymap.set("n", "cd", function()
            exec("cd " .. vim.b.netrw_curdir)
            exec "pwd"
        end, { buffer = true, desc = "CD directory under cursor" })
    end,
})

augroup("NoVim", opts)
aucmd("BufRead", {
    pattern = { "*.png", "*.jpg", "*.pdf", "*.gif", "*.jpeg", "*.svg", "*.odt", "*.doc*", "*.rtf" },
    group = "NoVim",
    callback = function()
        ---@diagnostic disable-next-line: missing-parameter
        os.execute("xdg-open " .. vim.fn.shellescape(vim.fn.expand "%:p"))
        vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
        vim.cmd "let &ft = &ft"
    end,
})
