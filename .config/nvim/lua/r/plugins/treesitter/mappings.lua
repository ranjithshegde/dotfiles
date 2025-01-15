------------------------------------------------------------------------
--                              Treesitter                            --
------------------------------------------------------------------------

local treesitter = {}

local wk = require 'which-key'
local mapper = require 'r.utils.expand_maps'

local to = { swap = {} }

function to.repeat_last(query)
    return function()
        require('nvim-treesitter.textobjects.repeatable_move')[query]()
    end
end

function to.select(query, mode)
    return function()
        require('nvim-treesitter.textobjects.select').select_textobject(query, 'textobjects', mode)
    end
end

function to.swap.next(query)
    return function()
        require('nvim-treesitter.textobjects.swap').swap_next(query)
    end
end

function to.swap.previous(query)
    return function()
        require('nvim-treesitter.textobjects.swap').swap_previous(query)
    end
end

function to.move(direction, query)
    return function()
        require('nvim-treesitter.textobjects.move')[direction](query)
    end
end

function to.peek(query)
    return function()
        require('nvim-treesitter.textobjects.lsp_interop').peek_definition_code(query)
    end
end

function to.goto_next()
    require('nvim-treesitter-refactor.navigation').goto_next_usage()
end

function to.goto_prev()
    require('nvim-treesitter-refactor.navigation').goto_previous_usage()
end

local refac = {}

function refac.refac(args)
    return function()
        require('refactoring').refactor(args)
    end
end

function refac.debug(func, args)
    return function()
        require('refactoring').debug[func](args)
    end
end

function treesitter.navigate_tex(buf)
    wk.add(mapper({
        -- Motions
        [']'] = {
            m = { to.move('goto_next_start', '@block.outer'), 'Move to next outer TeX environment start' },
            i = { to.move('goto_next_start', '@block.inner'), 'Move to next inner TeX environment start' },
            M = { to.move('goto_next_end', '@block.outer'), 'Move to next TeX environment outer end' },
            I = { to.move('goto_next_end', '@block.inner'), 'Move to next TeX environment inner end' },
        },
        ['<Down>'] = {
            to.move('goto_next_start', '@class.outer'),
            'Move to next chapter or section start',
        },
        ['<Right>'] = {
            [[<Cmd>execute "keepjumps norm! " . v:count1 . ")"<CR>]],
            'Move to next sentence start',
        },
        ['['] = {
            m = {
                to.move('goto_previous_start', '@block.outer'),
                'Move to previous outer TeX environment start',
            },
            M = {
                to.move('goto_previous_end', '@block.outer'),
                'Move to previous TeX environment outer end',
            },
            i = {
                to.move('goto_previous_start', '@block.inner'),
                'Move to previous inner TeX environment start',
            },
            I = {
                to.move('goto_previous_end', '@block.inner'),
                'Move to previous TeX environment inner end',
            },
        },
        ['<Up>'] = {
            to.move('goto_previous_start', '@class.outer'),
            'Move to previous chapter/section start',
        },
        ['<Left>'] = {
            [[<Cmd>execute "keepjumps norm! " . v:count1 . "("<CR>]],
            'Move to previous sentence start',
        },
    }, { buffer = buf }))
end

function treesitter.cpp(buf)
    wk.add(mapper({
        [';r'] = {
            name = 'Refactor Cpp',
            f = { vim.cmd.TSCppDefineClassFunc, 'function definition from declaration', mode = { 'n', 'v' } },
            c = { vim.cmd.TSCppMakeConcreteClass, 'Convert virtual class to concrete class', mode = { 'n', 'v' } },
            C = { vim.cmd.TSCppRuleOf3, 'Add Constructor, destructor and copy', mode = { 'n', 'v' } },
            m = { vim.cmd.TSCppRuleOf5, 'Add move Constructor', mode = { 'n', 'v' } },
        },
    }, { buffer = buf }))
end

function treesitter.navigate(buf)
    wk.add(mapper({
        -- Motions
        [']'] = {
            m = { to.move('goto_next_start', '@function.outer'), 'Move to next outer function start' },
            M = { to.move('goto_next_end', '@function.outer'), 'Move to next outer function end' },
            i = { to.move('goto_next_start', '@function.inner'), 'Move to next inner function start' },
            I = { to.move('goto_next_end', '@function.inner'), 'Move to next function inner end' },
            [']'] = { to.move('goto_next_start', '@class.outer'), 'Move to next outer class start' },
            ['['] = { to.move('goto_next_end', '@class.outer'), 'Move to next outer class end' },
        },
        ['<Down>'] = { to.move('goto_next_start', '@block.outer'), 'Move to next outer code block start' },
        ['<Right>'] = {
            to.move('goto_next_start', '@block.inner'),
            'Move to next inner code block start',
        },
        ['['] = {
            m = {
                to.move('goto_previous_start', '@function.outer'),
                'Move to previous outer function start',
            },
            M = { to.move('goto_previous_end', '@function.outer'), 'Move to previous function outer end' },
            i = {
                to.move('goto_previous_start', '@function.inner'),
                'Move to previous inner function start',
            },
            I = { to.move('goto_previous_end', '@function.inner'), 'Move to previous function inner end' },
            ['['] = {
                to.move('goto_previous_start', '@class.outer'),
                'Move to previous outer class start',
            },
            [']'] = {
                to.move('goto_previous_end', '@class.outer'),
                'Move to previous outer class end',
            },
        },

        ['<Up>'] = {
            to.move('goto_previous_start', '@block.outer'),
            'Move to previous outer code block start',
        },
        ['<Left>'] = {
            to.move('goto_previous_start', '@block.inner'),
            'Move to previous inner code block start',
        },
    }, { buffer = buf }))
end

function treesitter.common()
    wk.add {
        {
            '<leader><CR>',
            desc = 'Accept refactor edits',
        },
        { 'Q', desc = 'Reject refactor edits' },
        { ']r', to.goto_next, desc = 'Go to next node usage' },
        { '[r', to.goto_prev, desc = 'Go to previous node usage' },
        mapper {
            [';'] = {
                name = 'Syntax tree functions',
                K = { vim.show_pos, 'Show treesitter node' },
                P = { vim.treesitter.inspect_tree, 'Toggle playground' },
                i = { 'gg=G<C-o>zz', 'indent' },
                -- TextObjects
                p = {
                    name = 'Peek function defintion',
                    f = { to.peek '@function.outer', 'function' },
                    c = { to.peek '@class.outer', 'class' },
                },
                g = {
                    name = 'incremental selection',
                    n = 'Start selection at node',
                    i = { 'Increment nodes', mode = 'v' },
                    s = { 'Increment Scope', mode = 'v' },
                    d = { 'Decrememnt nodes', mode = 'v' },
                },
                f = {
                    name = 'Refactoring tools',
                    i = { refac.refac 'Inline Variable', 'Inline Variable', mode = { 'n', 'v' } },
                    e = {
                        name = 'Extract',
                        b = { refac.refac 'Extract Block', 'extract block' },
                        B = { refac.refac 'Extract Block To File', 'extract block to file' },
                        v = { refac.refac 'Extract Variable', 'Extract Variable', mode = { 'n', 'v' } },
                        f = { refac.refac 'Extract Function', 'Extract Function', mode = { 'n', 'v' } },
                        F = { refac.refac 'Extract Function to File', 'Extract Function to File', mode = { 'n', 'v' } },
                    },
                    d = {
                        name = 'print debug information',
                        p = { refac.debug('printf', { below = true }), 'Printf below' },
                        P = { refac.debug('printf', { below = false }), 'Printf above' },
                        v = { refac.debug('print_var', { normal = true }), 'Printf variable', mode = { 'n', 'v' } },
                        c = { refac.debug('cleanup', {}), 'Cleanup prints' },
                    },
                },
            },
        },
        mapper {
            -- Swap
            cx = {
                name = 'Swap forwards',
                a = {
                    -- name = 'outer',
                    s = { to.swap.next '@statement.outer', 'statement' },
                    o = { to.swap.next '@comment.outer', 'comment' },
                    a = { to.swap.next '@call.outer', 'call' },
                    f = { to.swap.next '@function.outer', 'function' },
                    p = { to.swap.next '@parameter.outer', 'Paramater' },
                    c = { to.swap.next '@conditional.outer', 'conditional' },
                    l = { to.swap.next '@loop.outer', 'loop' },
                    v = { to.swap.next '@variable.outer', 'variable' },
                },
                i = {
                    -- name = 'inner',
                    a = { to.swap.next '@call.inner', 'call' },
                    f = { to.swap.next '@function.inner', 'function' },
                    p = { to.swap.next '@parameter.inner', 'Paramater' },
                    c = { to.swap.next '@conditional.inner', 'conditional' },
                    l = { to.swap.next '@loop.inner', 'loop' },
                    v = { to.swap.next '@variable.inner', 'variable' },
                },
            },
            cX = {
                name = 'Swap backwards',
                a = {
                    -- name = 'outer',
                    s = { to.swap.previous '@statement.outer', 'statement' },
                    o = { to.swap.previous '@comment.outer', 'comment' },
                    a = { to.swap.previous '@call.outer', 'call' },
                    f = { to.swap.previous '@function.outer', 'function' },
                    p = { to.swap.previous '@parameter.outer', 'Paramater' },
                    c = { to.swap.previous '@conditional.outer', 'conditional' },
                    l = { to.swap.previous '@loop.outer', 'loop' },
                    v = { to.swap.previous '@variable.outer', 'variable' },
                },
                i = {
                    -- name = 'inner',
                    a = { to.swap.previous '@call.inner', 'call' },
                    f = { to.swap.previous '@function.inner', 'function' },
                    p = { to.swap.previous '@parameter.inner', 'Paramater' },
                    c = { to.swap.previous '@conditional.inner', 'conditional' },
                    l = { to.swap.previous '@loop.inner', 'loop' },
                    v = { to.swap.previous '@variable.inner', 'variable' },
                },
            },
        },
        mapper({
            ['<C-;>'] = { to.repeat_last 'repeat_last_move_next', 'Repeat last move' },
            ['<C-,>'] = { to.repeat_last 'repeat_last_move_previous', 'Repeat last move' },
        }, { mode = { 'n', 'x', 'o' } }),
    }

    wk.add(mapper({
        a = {
            name = 'around',
            f = { to.select('@function.outer', 'x'), 'function' },
            F = { to.select('@frame.outer', 'x'), 'frame' },
            c = { to.select('@conditional.outer', 'x'), 'conditional' },
            C = { to.select('@call.outer', 'x'), 'call' },
            o = { to.select('@class.outer', 'x'), 'class' },
            e = { to.select('@block.outer', 'x'), 'block' },
            d = { to.select('@comment.outer', 'x'), 'comment' },
            s = { to.select('@statement.outer', 'x'), 'statement' },
            v = { to.select('@variable.outer', 'x'), 'variable' },
            l = { to.select('@loop.outer', 'x'), 'loop' },
        },
        i = {
            name = 'inside',
            f = { to.select('@function.inner', 'x'), 'function' },
            c = { to.select('@conditional.inner', 'x'), 'conditional' },
            C = { to.select('@call.inner', 'x'), 'call' },
            o = { to.select('@class.inner', 'x'), 'class' },
            e = { to.select('@block.inner', 'x'), 'block' },
            v = { to.select('@variable.inner', 'x'), 'variable' },
            l = { to.select('@loop.inner', 'x'), 'loop' },
        },
    }, { mode = 'x' }))

    wk.add(mapper({
        a = {
            name = 'around',
            f = { to.select('@function.outer', 'o'), 'function' },
            F = { to.select('@frame.outer', 'o'), 'frame' },
            c = { to.select('@conditional.outer', 'o'), 'conditional' },
            C = { to.select('@call.outer', 'o'), 'call' },
            o = { to.select('@class.outer', 'o'), 'class' },
            e = { to.select('@block.outer', 'o'), 'block' },
            d = { to.select('@comment.outer', 'o'), 'comment' },
            s = { to.select('@statement.outer', 'o'), 'statement' },
            v = { to.select('@variable.outer', 'o'), 'variable' },
            l = { to.select('@loop.outer', 'o'), 'loop' },
        },
        i = {
            name = 'inside',
            f = { to.select('@function.inner', 'o'), 'function' },
            c = { to.select('@conditional.inner', 'o'), 'conditional' },
            C = { to.select('@call.inner', 'o'), 'call' },
            o = { to.select('@class.inner', 'o'), 'class' },
            e = { to.select('@block.inner', 'o'), 'block' },
            v = { to.select('@variable.inner', 'o'), 'variable' },
            l = { to.select('@loop.inner', 'o'), 'loop' },
        },
    }, { mode = 'o' }))
end

return treesitter
