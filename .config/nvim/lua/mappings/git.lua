------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

local function git_command(args)
    return function()
        vim.api.nvim_cmd({ cmd = "G", args = args and args }, {})
    end
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
            g = { git_command(), "Git window" },
            c = { git_command { "commit" }, "commit changes" },
            C = { git_command { "commit %" }, "commit current buffer" },
            a = { git_command { "add %" }, "add current buffer" },
            d = { git_command { "difftool" }, "launch difftool" },
            b = { git_command { "blame" }, "toggle blame" },
            p = { git_command { "push" }, "push commits" },
            P = { git_command { "push -f" }, "force push commits" },
            l = { git_command { "log" }, "commit history" },
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
