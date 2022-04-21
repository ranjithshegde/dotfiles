local mappings = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              General functions                     --
------------------------------------------------------------------------

function mappings.init()
    mappings.configFiles()

    local opts = { nowait = true }
    --line movement
    map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up" })
    map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down" })
    -- visual cut for replase
    map({ "v", "s" }, "<leader>p", '"_dP', opts)
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
    map(
        "n",
        "gm",
        "cursor(0,{desc =  virtcol('$')/2 )",
        { desc = "Move cursor to middle of the line", expr = true, buffer = true }
    )

    -- Terminals
    wk.register {
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { "<cmd>sp term://zsh<cr>", "Horizontal" },
            v = { "<cmd>vspl term://zsh<cr>", "Vertical" },
            t = { "<cmd>tab drop term://zsh<cr>", "New tab" },
        },
    }
end

------------------------------------------------------------------------
--                              Vim config files                      --
------------------------------------------------------------------------

local open = function(path)
    return string.format("<cmd>tab drop ~/.config/nvim/%s<CR>", path)
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
                    f = { open "lua/mappings/filetypes.lua", "FT specific" },
                    c = { open "lua/mappings/clang.lua", "C/C++" },
                    u = { open "lua/mappings/util.lua", "Misc" },
                    t = { open "lua/mappings/telescope.lua", "Telescope" },
                    s = { open "lua/mappings/treesitter.lua", "Treesitter" },
                    g = { open "lua/mappings/git.lua", "Git" },
                },
                g = {
                    name = "Org plugin",
                    o = { open "lua/org/init.lua", "Index plugin" },
                    d = { open "lua/org/diary.lua", "Diary plugin" },
                },
                o = {
                    name = "Options",
                    o = { open "lua/settings/init.lua", "vim" },
                    t = { open "lua/settings/telescope.lua", "Telescope" },
                    s = { open "lua/settings/treesitter.lua", "Treesitter" },
                    c = { open "lua/settings/completion.lua", "Completion" },
                },
                l = {
                    name = "Lsp",
                    s = { open "lua/lsp/init.lua", "Functions and Inits" },
                    l = { open "lua/lsp/sumneko.lua", "Sumneko" },
                    j = { open "lua/lsp/jdtls.lua", "Jdt LS" },
                    c = { open "lua/lsp/clangd.lua", "Clangd" },
                },
                u = {
                    name = "Utilities in lua",
                    u = { open "lua/utils/init.lua", "General" },
                    c = { open "lua/utils/compiler.lua", "Cpp Workstation" },
                    d = { open "lua/utils/diagnostics.lua", "Diagnostic extensions" },
                    l = { open "lua/utils/langServers.lua", "Langauge Server extensions" },
                    q = { open "lua/utils/qf.lua", "Quickfix and Loclist" },
                    p = { open "lua/utils/preview.lua", "Fold preview" },
                    t = { open "lua/utils/tables.lua", "Filter tables" },
                },
                f = {
                    name = "Filetype Plugins",
                    c = { open "after/ftplugin/cpp.lua", "Cpp" },
                    g = { open "after/ftplugin/glsl.lua", "Glsl" },
                    j = { open "after/ftplugin/javascript.lua", "JavaScript" },
                    l = { open "after/ftplugin/lua.lua", "Lua" },
                    o = { open "after/ftplugin/org.lua", "Orgmode" },
                    t = { open "after/ftplugin/tex.lua", "Latex" },
                },
                q = {
                    name = "Treesitter queries",
                    m = { open "after/queries/markdown/highlights.scm", "Markdown" },
                    o = { open "after/queries/org/highlights.scm", "Org" },
                },
                d = { open "lua/debugger.lua", "Debug adapter protocol" },
                s = { open "lua/statusline.lua", "Statusline and Tabline" },
                a = { open "autoload/util.vim", "Utilities in autoload" },
                c = { open "after/plugin/plugin.lua", "User defined commands" },
                r = { open "init.lua", "VimRC" },
                P = { require("packer").sync, "Update packages" },
                R = { require("utils").Restart, "Reload Vim" },
            },
        },
    }
end

return mappings
