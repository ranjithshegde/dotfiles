------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

return require("which-key").register {
    ["<leader>g"] = {
        name = "git functions",
        g = { "<cmd>G<cr>", "Git window" },
        c = { "<cmd>G commit<cr>", "commit changes" },
        C = { "<cmd>G commit %<cr>", "commit current buffer" },
        a = { "<cmd>G add %<cr>", "add current buffer" },
        d = { "<cmd>G difftool<cr>", "launch difftool" },
        b = { "<cmd>G blame<cr>", "toggle blame" },
        p = { "<cmd>G push<cr>", "push commits" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "stage hunk under cursor" },
        P = { "<cmd>G push -f<cr>", "force push commits" },
        l = { "<cmd>G log<cr>", "commit history" },
        L = { "<cmd>Gclog<cr>", "commit CLog" },
        h = { "<cmd>Gitsigns toggle_linehl<cr> <cmd>Gitsigns toggle_word_diff<cr>", "Toggle buffer highlights" },
    },
    ["]h"] = { "<cmd>Gitsigns next_hunk<cr>:Gitsigns preview_hunk<CR>", "Preview previous hunk" },
    ["[h"] = { "<cmd>Gitsigns prev_hunk<cr>:Gitsigns preview_hunk<CR>", "Preview next hunk" },
}
