local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Vim config files                      --
------------------------------------------------------------------------

local open = function(path)
    return function()
        require("r.utils").ex_cmd(
            "drop",
            { "~/.config/nvim/" .. path },
            { tab = 2, silent = true },
            { file = true, bar = true }
        )
    end
end

local function open_term(split, mods)
    return function()
        require("r.utils").ex_cmd(split, { "term://zsh" }, mods, { file = true, bar = true })
    end
end

local function config_files()
    wk.register {
        ["<leader>"] = {
            a = {
                name = "vimrc files",
                p = { open "lua/r/plugins.lua", "Packer config" },
                m = {
                    name = "Mappings",
                    m = { open "lua/r/mappings/init.lua", "Common" },
                    l = { open "lua/r/mappings/lsp.lua", "Lsp" },
                    c = { open "lua/r/mappings/clang.lua", "C/C++" },
                    u = { open "lua/r/mappings/util.lua", "Misc" },
                    t = { open "lua/r/mappings/telescope.lua", "Telescope" },
                    s = { open "lua/r/mappings/treesitter.lua", "Treesitter" },
                    g = { open "lua/r/mappings/git.lua", "Git" },
                    p = { open "lua/r/mappings/pairs.lua", "Unimpaired" },
                },
                o = {
                    name = "Options",
                    o = { open "lua/r/settings/init.lua", "vim" },
                    t = { open "lua/r/settings/telescope.lua", "Telescope" },
                    s = { open "lua/r/settings/treesitter.lua", "Treesitter" },
                    f = { open "lua/r/settings/folds.lua", "Foldtext" },
                    c = { open "lua/r/settings/completion.lua", "Completion" },
                    p = { open "lua/r/settings/plugin.lua", "Settings for plugins" },
                    a = { open "lua/r/settings/autocmds.lua", "Autocmds" },
                    n = { open "lua/r/settings/notify.lua", "Nvim Notify init settings" },
                    e = { open "lua/r/settings/statusline.lua", "Express statusline and Tabline" },
                    l = { open "lua/r/settings/tabline.lua", "Tabline" },
                    w = { open "lua/r/settings/winbar.lua", "Winbar" },
                },
                l = {
                    name = "Lsp",
                    s = { open "lua/r/lsp/init.lua", "Functions and Inits" },
                    l = { open "lua/r/lsp/sumneko.lua", "Sumneko" },
                    j = { open "lua/r/lsp/signature.lua", "Signature auto Popup" },
                    c = { open "lua/r/lsp/clangd.lua", "Clangd" },
                    r = { open "lua/r/lsp/rename.lua", "Incremental rename" },
                },
                u = {
                    name = "Utilities in lua",
                    u = { open "lua/r/utils/init.lua", "General" },
                    c = { open "lua/r/utils/compiler.lua", "Cpp Workstation" },
                    d = { open "lua/r/utils/diagnostics/init.lua", "Diagnostic extensions" },
                    l = { open "lua/r/utils/ls.lua", "Langauge Server extensions" },
                    q = { open "lua/r/utils/qf.lua", "Quickfix and Loclist" },
                    f = { open "lua/r/utils/extensions.lua", "Function extensions" },
                    s = { open "lua/r/utils/scratchpad.lua", "ScratchPad" },
                    t = { open "lua/r/utils/tables.lua", "Filter tables" },
                    m = { open "lua/r/utils/camel.lua", "CamelCaseMotion" },
                },
                f = {
                    name = "Filetype Plugins",
                    c = { open "after/ftplugin/cpp.lua", "Cpp" },
                    g = { open "after/ftplugin/glsl.lua", "Glsl" },
                    j = { open "after/ftplugin/javascript.lua", "JavaScript" },
                    l = { open "after/ftplugin/lua.lua", "Lua" },
                    o = { open "after/ftplugin/org.lua", "Orgmode" },
                    t = { open "after/ftplugin/tex.lua", "Latex" },
                    f = { open "filetype.lua", "Ftdetect" },
                },
                q = {
                    name = "Treesitter queries",
                    m = { open "after/queries/markdown/highlights.scm", "Markdown" },
                    o = { open "after/queries/org/highlights.scm", "Org" },
                },
                d = { open "lua/r/debugger.lua", "Debug adapter protocol" },
                c = { open "after/plugin/plugin.lua", "User defined commands" },
                r = { open "init.lua", "VimRC" },
                P = { require("packer").sync, "Update packages" },
                R = { require("r.utils").restart, "Reload Vim" },
            },
        },
    }
end

------------------------------------------------------------------------
--                              General mappings                      --
------------------------------------------------------------------------

return function()
    config_files()

    local opts = { nowait = true, silent = true }
    -- Extend C-keys
    map("n", "<C-;>", ";")
    map("n", "<C-,>", ",")
    map("i", "<C-o>", "<C-o>:")
    map("n", "<C-i>", "<C-i>", { desc = "Dont map C-i to Tab" })
    map({ "n", "i", "s" }, "<BS>", "<BS>", { desc = "Dont map C-h to backspace" })

    --line movement
    map("x", "K", ":move '<-2<CR>gv", { desc = "Move line up" })
    map("x", "J", ":move '>+1<CR>gv", { desc = "Move line down" })
    -- visual cut for replase
    map({ "v", "s" }, "P", '"_dP', opts)
    -- Indent
    map("v", "<", "<gv", opts)
    map("v", ">", ">gv", opts)

    -- Toggle folds
    map("n", "<Tab>", "za", { desc = "Toggle fold current" })
    map("n", "<S-Tab>", "zA", { desc = "Toggle fold All" })
    -- open folds when searching
    map("n", "n", "nzzzv", { desc = "jump to next search result" })
    map("n", "N", "Nzzzv", { desc = "jump to previous search result" })
    map("n", "J", "mzJ`z", { desc = "Adjoin next line" })

    --Quickfix
    map("n", "-", function()
        require("r.utils.qf").toggle_qf "q"
    end, { desc = "Toggle quickfix" })
    map("n", "_", function()
        require("r.utils.qf").toggle_qf "l"
    end, { desc = "Toggle loclist" })
    -- ScratchPad
    map("n", "<leader>S", function()
        require "r.utils.scratchpad"(_, "tab")
    end, { desc = "Open ScratchPad" })
    -- Misc
    map("n", "gx", function()
        require("r.utils").open_in_browser(vim.fn.expand "<cWORD>")
    end, { desc = "exec word under cursor" })
    map("n", "gm", function()
        local virt = vim.fn.virtcol "$"
        virt = virt / 2
        vim.fn.cursor { 0, virt }
    end, { desc = "Move cursor to middle of the line" })

    -- Terminals
    map({ "n", "t" }, "<F9>", function()
        vim.cmd "stopinsert"
        require("r.utils.extensions").toggleTerm("zsh", "shell", 1)
    end, {
        desc = "Toggle current/default terminal",
    })
    wk.register {
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { open_term("split", { silent = true }), "Horizontal" },
            v = { open_term("vsplit", { silent = true }), "Vertical" },
            t = { open_term("drop", { silent = true, tab = 2 }), "New tab" },
        },
    }
end
