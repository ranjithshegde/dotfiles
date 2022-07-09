------------------------------------------------------------------------
--                              Treesitter                            --
------------------------------------------------------------------------

local to = { swap = {} }

function to.select(query, mode)
    return function()
        require("nvim-treesitter.textobjects.select").select_textobject(query, mode)
    end
end

function to.swap.next(query)
    return function()
        require("nvim-treesitter.textobjects.swap").swap_next(query)
    end
end

function to.swap.previous(query)
    return function()
        require("nvim-treesitter.textobjects.swap").swap_previous(query)
    end
end

function to.move(direction, query)
    return function()
        require("nvim-treesitter.textobjects.move")[direction](query)
    end
end

function to.peek(query)
    return function()
        require("nvim-treesitter.textobjects.lsp_interop").peek_definition_code(query)
    end
end

return function()
    require("which-key").register {
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
                f = { to.peek "@function.outer", "function" },
                c = { to.peek "@class.outer", "class" },
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
                s = { to.swap.next "@statement.outer", "statement" },
                o = { to.swap.next "@comment.outer", "comment" },
                a = { to.swap.next "@call.outer", "call" },
                f = { to.swap.next "@function.outer", "function" },
                p = { to.swap.next "@parameter.outer", "Paramater" },
                c = { to.swap.next "@conditional.outer", "conditional" },
                l = { to.swap.next "@loop.outer", "loop" },
                v = { to.swap.next "@variable.outer", "variable" },
            },
            i = {
                name = "inner",
                a = { to.swap.next "@call.inner", "call" },
                f = { to.swap.next "@function.inner", "function" },
                p = { to.swap.next "@parameter.inner", "Paramater" },
                c = { to.swap.next "@conditional.inner", "conditional" },
                l = { to.swap.next "@loop.inner", "loop" },
                v = { to.swap.next "@variable.inner", "variable" },
            },
        },
        cX = {
            name = "Swap backwards",
            a = {
                name = "outer",
                s = { to.swap.previous "@statement.outer", "statement" },
                o = { to.swap.previous "@comment.outer", "comment" },
                a = { to.swap.previous "@call.outer", "call" },
                f = { to.swap.previous "@function.outer", "function" },
                p = { to.swap.previous "@parameter.outer", "Paramater" },
                c = { to.swap.previous "@conditional.outer", "conditional" },
                l = { to.swap.previous "@loop.outer", "loop" },
                v = { to.swap.previous "@variable.outer", "variable" },
            },
            i = {
                name = "inner",
                a = { to.swap.previous "@call.inner", "call" },
                f = { to.swap.previous "@function.inner", "function" },
                p = { to.swap.previous "@parameter.inner", "Paramater" },
                c = { to.swap.previous "@conditional.inner", "conditional" },
                l = { to.swap.previous "@loop.inner", "loop" },
                v = { to.swap.previous "@variable.inner", "variable" },
            },
        },
        -- Motions
        ["]"] = {
            n = { to.move("goto_next_start", "@function.outer"), "Move to next outer function start" },
            i = { to.move("goto_next_start", "@function.inner"), "Move to next inner function start" },
            ["="] = { to.move("goto_next_start", "@class.outer"), "Move to next outer class start" },
            N = { to.move("goto_next_end", "@function.outer"), "Move to next function outer end" },
            I = { to.move("goto_next_end", "@function.inner"), "Move to next function inner end" },
        },
        ["<Down>"] = { to.move("goto_next_start", "@block.outer"), "Move to next outer code block start" },
        ["<Right>"] = { to.move("goto_next_start", "@block.inner"), "Move to next inner code block start" },
        ["["] = {
            n = { to.move("goto_previous_start", "@function.outer"), "Move to previous outer function start" },
            i = { to.move("goto_previous_start", "@function.inner"), "Move to previous inner function start" },
            ["="] = { to.move("goto_previous_start", "@class.outer"), "Move to previous outer class start" },
            N = { to.move("goto_previous_end", "@function.outer"), "Move to previous function outer end" },
            I = { to.move("goto_previous_end", "@function.inner"), "Move to previous function inner end" },
        },

        ["<Up>"] = { to.move("goto_previous_start", "@block.outer"), "Move to previous outer code block start" },
        ["<Left>"] = { to.move("goto_previous_start", "@block.inner"), "Move to previous inner code block start" },
    }

    require("which-key").register({
        a = {
            name = "around",
            f = { to.select("@function.outer", "x"), "function" },
            F = { to.select("@frame.outer", "x"), "frame" },
            c = { to.select("@conditional.outer", "x"), "conditional" },
            C = { to.select("@call.outer", "x"), "call" },
            o = { to.select("@class.outer", "x"), "class" },
            e = { to.select("@block.outer", "x"), "block" },
            d = { to.select("@comment.outer", "x"), "comment" },
            s = { to.select("@statement.outer", "x"), "statement" },
            v = { to.select("@variable.outer", "x"), "variable" },
            l = { to.select("@loop.outer", "x"), "loop" },
        },
        i = {
            name = "around",
            f = { to.select("@function.inner", "x"), "function" },
            c = { to.select("@conditional.inner", "x"), "conditional" },
            C = { to.select("@call.inner", "x"), "call" },
            o = { to.select("@class.inner", "x"), "class" },
            e = { to.select("@block.inner", "x"), "block" },
            v = { to.select("@variable.inner", "x"), "variable" },
            l = { to.select("@loop.inner", "x"), "loop" },
        },
    }, { mode = "x" })

    require("which-key").register({
        a = {
            name = "around",
            f = { to.select("@function.outer", "o"), "function" },
            F = { to.select("@frame.outer", "o"), "frame" },
            c = { to.select("@conditional.outer", "o"), "conditional" },
            C = { to.select("@call.outer", "o"), "call" },
            o = { to.select("@class.outer", "o"), "class" },
            e = { to.select("@block.outer", "o"), "block" },
            d = { to.select("@comment.outer", "o"), "comment" },
            s = { to.select("@statement.outer", "o"), "statement" },
            v = { to.select("@variable.outer", "o"), "variable" },
            l = { to.select("@loop.outer", "o"), "loop" },
        },
        i = {
            name = "inside",
            f = { to.select("@function.inner", "o"), "function" },
            c = { to.select("@conditional.inner", "o"), "conditional" },
            C = { to.select("@call.inner", "o"), "call" },
            o = { to.select("@class.inner", "o"), "class" },
            e = { to.select("@block.inner", "o"), "block" },
            v = { to.select("@variable.inner", "o"), "variable" },
            l = { to.select("@loop.inner", "o"), "loop" },
        },
    }, { mode = "o" })
end
