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
        },
    }
    map("n", "<leader>rr", function()
        vim.fn["util#ranger"]("%:p:h", "e ")
    end, { desc = "from current file" })
    map("n", "<leader>rR", function()
        vim.fn["util#ranger"](".", "e ")
    end, { desc = "from current directory" })
    map("n", "<leader>rv", function()
        vim.cmd "vnew"
        vim.fn["util#ranger"]("%:p:h", "vs ")
    end, { desc = "in a split from current file" })
    map("n", "<leader>rV", function()
        vim.cmd "vnew"
        vim.fn["util#ranger"](".", "vs ")
    end, { desc = "in a split from current directory" })
    map("n", "<leader>rt", function()
        vim.cmd "tabnew"
        vim.fn["util#ranger"]("%:p:h", "tab drop ")
    end, { desc = "in a new tab from current file" })
    map("n", "<leader>rT", function()
        vim.cmd "tabnew"
        vim.fn["util#ranger"](".", "tab drop ")
    end, { desc = "in a new tab from current directory" })
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
                    require("org").openIndex()
                end,
                "Open Index",
            },
            t = {
                function()
                    require("org").openIndex "tab drop"
                end,
                "Open Index in a new tab",
            },
            d = {
                function()
                    require("org").deleteLink()
                end,
                "Delete link under cursor",
            },
            i = {
                function()
                    require("org.diary").diaryIndexOpen()
                end,
                "Open Diary index",
            },
            ["<leader>"] = {
                name = "Diary entries",
                w = {
                    function()
                        require("org.diary").diaryTodayOpen()
                    end,
                    "Today",
                },
                t = {
                    function()
                        require("org.diary").diaryTodayOpen "tab drop"
                    end,
                    "Today in a new tab",
                },
                i = {
                    function()
                        require("org.diary").diaryGenerateIndex()
                    end,
                    "Reindex",
                },
                y = {
                    function()
                        require("org.diary").diaryYesterdayOpen()
                    end,
                    "Yesterday",
                },
                m = {
                    function()
                        require("org.diary").diaryTomorrowOpen()
                    end,
                    "Tomorrow",
                },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Co-Author                              --
------------------------------------------------------------------------

function utilmaps.coauthor()
    wk.register {
        ["<leader>"] = {
            i = {
                name = "Co-Authoring",
                i = {
                    function()
                        require("instant.server").StartServer("192.168." .. vim.fn.input "Enter extension: ", "8080")
                    end,
                    "Start Co-authoring Server",
                },
                s = {
                    function()
                        require("instant").StartServer("192.168." .. vim.fn.input "Enter extension: ", "8080")
                    end,
                    "Launch session",
                },
                b = {
                    function()
                        require("instant").Start("192.168." .. vim.fn.input "Enter extension: ", "8080")
                    end,
                    "Launch current buffer",
                },
                j = {
                    function()
                        require("instant").JoinSession("192.168." .. vim.fn.input "Enter extension: ", "8080")
                        require("instant").StartFollow(vim.fn.input "User to follow: ")
                    end,
                    "Join session",
                },
                J = {
                    function()
                        require("instant").Join("192.168." .. vim.fn.input "Enter extension: ", "8080")
                        require("instant").StartFollow(vim.fn.input "User to follow: ")
                    end,
                    "Join single buffer",
                },
                f = {
                    function()
                        require("instant").StartFollow(vim.fn.input "User to follow: ")
                    end,
                    "follow user",
                },
            },
        },
    }
end

return utilmaps
