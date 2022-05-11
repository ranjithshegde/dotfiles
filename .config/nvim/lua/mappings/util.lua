local utilmaps = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

function utilmaps.ranger()
    wk.register {
        ["<leader>r"] = {
            name = "Ranger file picker",
            r = {
                function()
                    require("utils").ranger("%:p:h", "e ")
                end,
                "from current file",
            },
            R = {
                function()
                    require("utils").ranger(".", "e ")
                end,
                "from current directory",
            },
            v = {
                function()
                    vim.cmd "vnew"
                    require("utils").ranger("%:p:h", "vs ")
                end,
                "in a split from current file",
            },
            V = {
                function()
                    vim.cmd "vnew"
                    require("utils").ranger(".", "vs ")
                end,
                "in a split from current directory",
            },
            t = {
                function()
                    vim.cmd "tabnew"
                    require("utils").ranger("%:p:h", "tab drop ")
                end,
                "in a new tab from current file",
            },
            T = {
                function()
                    vim.cmd "tabnew"
                    require("utils").ranger(".", "tab drop ")
                end,
                "in a new tab from current directory",
            },
        },
    }
end

function utilmaps.wordProcessor()
    map("n", "<leader><Space>", '<cmd>g/^/pu ="\n"<CR>', { desc = "Double space entire file" })
    map("n", ",K", function()
        require("utils").dictionary(vim.fn.expand "<cword>")
    end, { desc = "Lookup Wikitionary" })
    map("n", ",T", function()
        require("utils").thesaurus(vim.fn.expand "<cword>")
    end, { desc = "Lookup Synonyms" })
end

-- ******************************** orgWiki -----------------------
function utilmaps.orgWiki()
    wk.register {
        ["<leader>w"] = {
            name = "orgWiki",
            w = {
                function()
                    require("orgWiki.wiki").openIndex()
                end,
                "Open Index",
            },
            n = {
                function()
                    require("orgWiki.wiki").nextWiki "tabnew"
                end,
                "Open next wiki Index",
            },
            c = {
                function()
                    require("orgWiki.wiki").select "tabnew"
                end,
                "Open next wiki Index",
            },
            t = {
                function()
                    require("orgWiki.wiki").openIndex "tab drop"
                end,
                "Open Index in a new tab",
            },
            d = {
                function()
                    require("orgWiki.wiki").deleteLink()
                end,
                "Delete link under cursor",
            },
            i = {
                function()
                    require("orgWiki.diary").diaryIndexOpen()
                end,
                "Open Diary index",
            },
            ["<leader>"] = {
                name = "Diary entries",
                w = {
                    function()
                        require("orgWiki.diary").diaryTodayOpen()
                    end,
                    "Today",
                },
                t = {
                    function()
                        require("orgWiki.diary").diaryTodayOpen "tab drop"
                    end,
                    "Today in a new tab",
                },
                i = {
                    function()
                        require("orgWiki.diary").diaryGenerateIndex()
                    end,
                    "Reindex",
                },
                y = {
                    function()
                        require("orgWiki.diary").diaryYesterdayOpen()
                    end,
                    "Yesterday",
                },
                m = {
                    function()
                        require("orgWiki.diary").diaryTomorrowOpen()
                    end,
                    "Tomorrow",
                },
            },
        },
    }
end

-- ******************************* Misc -------------------------------
function utilmaps.misc()
    vim.keymap.set("n", "<leader>e", "<cmd>Lex<CR>", { desc = "Toggle Netrw" })

    vim.g.fold_preview = true
    vim.keymap.set("n", "l", function()
        require("utils.preview").keymap_open_close "l"
    end)
    vim.keymap.set("n", "h", function()
        require("utils.preview").keymap_close "h"
    end)
end

return utilmaps
