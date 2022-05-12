------------------------------------------------------------------------
--                              Treesitter                            --
------------------------------------------------------------------------

return require("which-key").register {
    [";"] = {
        name = "Syntax tree functions",
        -- Plugins
        K = {
            function()
                require("nvim-treesitter-playground.hl-info").show_ts_node()
            end,
            "Show treesitter node",
        },
        P = {
            function()
                require("nvim-treesitter-playground.internal").toggle()
            end,
            "Toggle playground",
        },
        --Refactor
        d = "Jump to node definition",
        f = { "gg=G<C-o>zz", "indent" },
        l = {
            name = "List functions/symbols",
            l = "local",
            g = "Global",
        },
        R = "rename",
        ["*"] = "jump to node's next usage",
        ["#"] = "jump to node's previous usage",
        -- TextObjects
        p = {
            name = "Peek function defintion",
            f = "for function",
            c = "for class",
        },
        g = {
            name = "incremental selection",
            n = "Start selection at node",
            i = { "Increment nodes", mode = "v" },
            s = { "Increment Scope", mode = "v" },
            r = { "Decrememnt nodes", mode = "v" },
        },
    },
    -- Refactor
    ["<leader><CR>"] = "Accept refactor edits",
    Q = "Reject refactor edits",
    -- Swap
    cx = {
        name = "Swap forwards",
        a = {
            name = "outer",
            s = "statement",
            o = "comment",
            a = "call",
            f = "function",
            p = "Paramater",
            c = "conditional",
            l = "loop",
            v = "variable",
        },
        i = {
            name = "inner",
            a = "call",
            f = "function",
            p = "Paramater",
            c = "conditional",
            l = "loop",
            v = "variable",
        },
    },
    cX = {
        name = "Swap backwards",
        a = {
            name = "outer",
            s = "statement",
            o = "comment",
            a = "call",
            f = "function",
            p = "Paramater",
            c = "conditional",
            l = "loop",
            v = "variable",
        },
        i = {
            name = "inner",
            a = "call",
            f = "function",
            p = "Paramater",
            c = "conditional",
            l = "loop",
            v = "variable",
        },
    },
    -- Motions
    ["]"] = {
        n = "Move to next outer function start",
        i = "Move to next inner function start",
        ["="] = "Move to next outer class start",
        N = "Move to next function outer end",
        I = "Move to next function inner end",
    },
    ["<Down>"] = "Move to next outer code block start",
    ["<Right>"] = "Move to next inner code block start",
    ["["] = {
        n = "Move to previous outer function start",
        i = "Move to previous inner function start",
        ["="] = "Move to previous outer class start",
        N = "Move to previous function outer end",
        I = "Move to previous function inner end",
    },

    ["<Up>"] = "Move to previous outer code block start",
    ["<Left>"] = "Move to previous inner code block start",
}
