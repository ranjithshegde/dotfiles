---@diagnostic disable: missing-parameter
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
    desc = "Custom formatoptions",
})
aucmd("FileType", {
    group = "FormatOptions",
    callback = function(args)
        if vim.tbl_contains(require("utils.tables").ignoreFiles, args.match) then
            vim.opt.relativenumber = false
            vim.opt_local.cursorline = false
            vim.wo.foldcolumn = "0"
            return
        end
        vim.opt.relativenumber = true
        vim.opt_local.cursorline = true
        vim.wo.winbar = ""
    end,
    desc = "Disable all custom decoration rules for non-language filetypes",
})
aucmd({ "InsertEnter", "WinLeave", "FocusLost", "BufNewFile" }, {
    group = "FormatOptions",
    callback = function()
        if vim.tbl_contains(require("utils.tables").ignoreFiles, vim.bo.filetype) then
            return
        end
        vim.opt.relativenumber = false
    end,
    desc = "Dont use relativenumber where it makes no sense",
})
aucmd({ "InsertLeave", "WinEnter", "FocusGained" }, {
    group = "FormatOptions",
    callback = function()
        if
            vim.tbl_contains(require("utils.tables").ignoreFiles, vim.bo.filetype)
            or vim.api.nvim_win_get_height(vim.api.nvim_get_current_win()) <= 15
        then
            return
        end
        vim.opt.relativenumber = true
    end,
    desc = "use relativenumber conditionally",
})
aucmd({ "FocusGained", "WinEnter" }, {
    group = "FormatOptions",
    callback = function()
        require("statusline").winbar(vim.api.nvim_get_current_win())
        if
            vim.tbl_contains(require("utils.tables").ignoreFiles, vim.bo.filetype)
            or vim.api.nvim_win_get_height(vim.api.nvim_get_current_win()) <= 15
        then
            return
        end
        vim.opt_local.cursorline = true
        vim.wo.foldcolumn = "auto:1"
    end,
    desc = "use cursorline only on active buffers && Winbar on tabpages with more than one window",
})
aucmd({ "FocusLost", "WinLeave" }, {
    group = "FormatOptions",
    callback = function()
        if vim.tbl_contains(require("utils.tables").ignoreFiles, vim.bo.filetype) then
            return
        end
        vim.opt_local.cursorline = false
        vim.wo.foldcolumn = "0"
    end,
    desc = "dont use cursorline on inactive buffers",
})

-- ************** Lsp Configuration loading  ------------------------------

augroup("LspSettings", opts)
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
    desc = "Initialize lsp settings, AuGroups and server configurations",
})
aucmd("FileType", {
    group = "LspSettings",
    pattern = "opencl",
    callback = function()
        require("mappings.clang").clang()
    end,
    desc = "OpenCL filetype to handle C++ lsp",
})
aucmd("FileType", {
    group = "LspSettings",
    pattern = "cmake",
    callback = function()
        vim.lsp.start {
            name = "neocmake",
            cmd = { "neocmakelsp" },
            filetypes = "cmake",
            root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
            -- autostart = true,
            capabilities = require("lsp").capabilities(),
        }
    end,
})

aucmd("LspAttach", {
    group = "LspSettings",
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp").attach(client, bufnr)
    end,
    desc = "Call attach function on event LspAttach",
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
    desc = "set compiler and toggleable REPL for capable filetypes",
})

-- ************** Load plugins and mappings ------------------------------
-- Compile packer after writing plugins.lua
augroup("PluginLoad", opts)
aucmd("BufWritePost", {
    group = "PluginLoad",
    pattern = "plugins.lua",
    callback = function()
        exec "source <afile>"
        require("packer").compile()
    end,
    desc = "Autocompile packer",
})
aucmd("BufReadPost", {
    group = "PluginLoad",
    callback = function()
        require "mappings.pairs"
        require "mappings.treesitter"
    end,
    desc = "Load mappings for unimparied and treesiiter after reading buffer",
})
aucmd(
    "BufReadPost",
    { group = "PluginLoad", command = "packadd matchit", once = true, desc = "Conditionally load matchit" }
)
aucmd("User", {
    pattern = "PackerComplete",
    group = "PluginLoad",
    command = "LuaCacheClear",
    desc = "Clear cache after compiling packer",
})

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
    desc = "Especial insertexit for ranger windows",
})
aucmd("TermClose", {
    group = "TermInsertModes",
    callback = function()
        vim.api.nvim_input "<CR>"
    end,
    desc = "Remove the annoying [exited] termexit prompt",
})

augroup("ProjectDrawer", opts)
aucmd("WinEnter", {
    group = "ProjectDrawer",
    callback = function()
        if vim.fn.winnr "$" == 1 and vim.bo.filetype == "netrw" then
            vim.cmd "q"
        end
    end,
    desc = "Autoclose NetRW if its the last buffer",
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
    pattern = { "*.png", "*.PNG", "*.jpg", "*.pdf", "*.gif", "*.jpeg", "*.svg", "*.odt", "*.doc*", "*.rtf" },
    group = "NoVim",
    callback = function()
        vim.loop.spawn("xdg-open", { args = { vim.fn.expand "%:p" } })
        vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
        vim.cmd "let &ft = &ft"
    end,
    desc = "Open non text files with MIME",
})
