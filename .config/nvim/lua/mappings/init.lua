local mappings = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              General mappings                      --
------------------------------------------------------------------------

local function open_term(split, mods)
    return function()
        require("utils").ex_cmd(split, { "term://zsh" }, mods, { file = true, bar = true })
    end
end

function mappings.init()
    mappings.configFiles()

    local opts = { nowait = true, silent = true }
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
    -- Terminal
    map({ "n", "t" }, "<F9>", function()
        vim.cmd "stopinsert"
        require("utils").toggleTerm("zsh", "shell", 1)
    end, {
        desc = "Toggle current/default terminal",
    })
    --Quickfix
    map("n", "-", function()
        require("utils.qf").toggle_qf "q"
    end, { desc = "Toggle quickfix" })
    map("n", "_", function()
        require("utils.qf").toggle_qf "l"
    end, { desc = "Toggle loclist" })
    -- Toggle folds
    map("n", "<Tab>", "za", { desc = "Toggle fold current" })
    map("n", "<S-Tab>", "zA", { desc = "Toggle fold All" })
    -- open folds when searching
    map("n", "n", "nzzzv", { desc = "jump to next search result" })
    map("n", "N", "Nzzzv", { desc = "jump to previous search result" })
    map("n", "J", "mzJ`z", { desc = "Adjoin next line" })
    map("n", "gx", function()
        require("utils").open_in_browser(vim.fn.expand "<cWORD>")
    end, { desc = "exec word under cursor" })
    map("n", "gm", function()
        local virt = vim.fn.virtcol "$"
        virt = virt / 2
        vim.fn.cursor { 0, virt }
    end, { desc = "Move cursor to middle of the line" })
    map("n", "<leader>S", function()
        require "utils.scratchpad"(_, "tab")
    end, { desc = "Open ScratchPad" })

    -- Terminals
    wk.register {
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { open_term("split", { silent = true }), "Horizontal" },
            v = { open_term("vsplit", { silent = true }), "Vertical" },
            t = { open_term("drop", { silent = true, tab = 2 }), "New tab" },
        },
    }
end

------------------------------------------------------------------------
--                              Vim config files                      --
------------------------------------------------------------------------

local open = function(path)
    return function()
        require("utils").ex_cmd(
            "drop",
            { "~/.config/nvim/" .. path },
            { tab = 2, silent = true },
            { file = true, bar = true }
        )
    end
end

function mappings.configFiles()
    wk.register {
        ["<leader>"] = {
            a = {
                name = "vimrc files",
                p = { open "lua/plugins.lua", "Packer config" },
                m = {
                    name = "Mappings",
                    m = { open "lua/mappings/init.lua", "Common" },
                    l = { open "lua/mappings/lsp.lua", "Lsp" },
                    c = { open "lua/mappings/clang.lua", "C/C++" },
                    u = { open "lua/mappings/util.lua", "Misc" },
                    t = { open "lua/mappings/telescope.lua", "Telescope" },
                    s = { open "lua/mappings/treesitter.lua", "Treesitter" },
                    g = { open "lua/mappings/git.lua", "Git" },
                    p = { open "lua/mappings/pairs.lua", "Unimpaired" },
                },
                o = {
                    name = "Options",
                    o = { open "lua/settings/init.lua", "vim" },
                    t = { open "lua/settings/telescope.lua", "Telescope" },
                    s = { open "lua/settings/treesitter.lua", "Treesitter" },
                    f = { open "lua/settings/folds.lua", "Foldtext" },
                    c = { open "lua/settings/completion.lua", "Completion" },
                    p = { open "lua/settings/plugin.lua", "Settings for plugins" },
                    a = { open "lua/settings/autocmds.lua", "Autocmds" },
                    n = { open "lua/settings/notify.lua", "Nvim Notify init settings" },
                },
                l = {
                    name = "Lsp",
                    s = { open "lua/lsp/init.lua", "Functions and Inits" },
                    l = { open "lua/lsp/sumneko.lua", "Sumneko" },
                    j = { open "lua/lsp/signature.lua", "Signature auto Popup" },
                    c = { open "lua/lsp/clangd.lua", "Clangd" },
                    r = { open "lua/lsp/rename.lua", "Incremental rename" },
                },
                u = {
                    name = "Utilities in lua",
                    u = { open "lua/utils/init.lua", "General" },
                    c = { open "lua/utils/compiler.lua", "Cpp Workstation" },
                    d = { open "lua/utils/diagnostics/init.lua", "Diagnostic extensions" },
                    l = { open "lua/utils/langServers.lua", "Langauge Server extensions" },
                    q = { open "lua/utils/qf.lua", "Quickfix and Loclist" },
                    a = { open "lua/utils/autoload.lua", "Autoload functions" },
                    s = { open "lua/utils/scratchpad.lua", "ScratchPad" },
                    t = { open "lua/utils/tables.lua", "Filter tables" },
                    r = { open "lua/utils/repeat.lua", "dot-repeat" },
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
                d = { open "lua/debugger.lua", "Debug adapter protocol" },
                s = { open "lua/statusline.lua", "Statusline and Tabline" },
                c = { open "after/plugin/plugin.lua", "User defined commands" },
                r = { open "init.lua", "VimRC" },
                P = { require("packer").sync, "Update packages" },
                R = { require("utils").Restart, "Reload Vim" },
            },
        },
    }
end

return mappings
