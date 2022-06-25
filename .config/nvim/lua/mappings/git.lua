------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

local function git_command(args)
    vim.api.nvim_cmd({ cmd = "G", args = args and args }, {})
end

local g = {}

function g.fugitive()
    require("which-key").register {
        ["<leader>g"] = {
            name = "git functions",
            L = {
                function()
                    require("utils").ex_cmd("Gclog", {}, { silent = true })
                end,
                "commit CLog",
            },
            g = { git_command, "Git window" },
            c = {
                function()
                    git_command { "commit" }
                end,
                "commit changes",
            },
            C = {
                function()
                    git_command { "commit %" }
                end,
                "commit current buffer",
            },
            a = {
                function()
                    git_command { "add %" }
                end,
                "add current buffer",
            },
            d = {
                function()
                    git_command { "difftool" }
                end,
                "launch difftool",
            },
            b = {
                function()
                    git_command { "blame" }
                end,
                "toggle blame",
            },
            p = {
                function()
                    git_command { "push" }
                end,
                "push commits",
            },
            P = {
                function()
                    git_command { "push -f" }
                end,
                "force push commits",
            },
            l = {
                function()
                    git_command { "log" }
                end,
                "commit history",
            },
        },
    }
end

function g.signs(bufnr, gs)
    require("which-key").register({
        ["<leader>g"] = {
            name = "git functions",
            s = {
                gs.stage_hunk,
                "stage hunk under cursor",
            },
            h = {
                function()
                    gs.toggle_linehl()
                    gs.toggle_word_diff()
                end,
                "Toggle buffer highlights",
            },
        },
        ["]h"] = {
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                    vim.wait(10, gs.preview_hunk)
                end)
                return "<Ignore>"
            end,
            "Preview previous hunk",
            expr = true,
        },
        ["[h"] = {
            function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                    vim.wait(10, gs.preview_hunk)
                end)
                return "<Ignore>"
            end,
            "Preview next hunk",
            expr = true,
        },
    }, { buffer = bufnr })
end

return g
