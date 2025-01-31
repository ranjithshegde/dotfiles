------------------------------------------------------------------------
--                              Treesitter                            --
------------------------------------------------------------------------

local treesitter = {}

local wk = require 'which-key'
local mapper = require 'r.utils.expand_maps'

local to = { swap = {} }

function to.repeat_last(query)
    return function()
        require('nvim-treesitter-textobjects.repeatable_move')[query]()
    end
end

function to.select(query)
    return function()
        require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
    end
end

function to.swap.next(query)
    return function()
        require('nvim-treesitter-textobjects.swap').swap_next(query)
    end
end

function to.swap.previous(query)
    return function()
        require('nvim-treesitter-textobjects.swap').swap_previous(query)
    end
end

function to.move(direction, query)
    return function()
        require('nvim-treesitter-textobjects.move')[direction](query)
    end
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

function treesitter.cpp(buf)
    wk.add(mapper({
        ['cr'] = {
            name = 'Refactor Cpp',
            m = { vim.cmd.TSCppDefineClassFunc, 'function definition from declaration', mode = { 'n', 'x' } },
            c = { vim.cmd.TSCppMakeConcreteClass, 'Convert virtual class to concrete class', mode = { 'n', 'x' } },
            o = { vim.cmd.TSCppRuleOf3, 'Add Constructor, destructor and copy', mode = { 'n', 'x' } },
            O = { vim.cmd.TSCppRuleOf5, 'Add move Constructor', mode = { 'n', 'x' } },
        },
    }, { buffer = buf }))
end

function treesitter.navigate_tex(buf)
    wk.add(mapper({
        -- Motions
        [']'] = {
            m = { to.move('goto_next_start', '@block.outer'), 'Move to next outer TeX environment start' },
            f = { to.move('goto_next_start', '@block.inner'), 'Move to next inner TeX environment start' },
            M = { to.move('goto_next_end', '@block.outer'), 'Move to next TeX environment outer end' },
            F = { to.move('goto_next_end', '@block.inner'), 'Move to next TeX environment inner end' },
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
            f = {
                to.move('goto_previous_start', '@block.inner'),
                'Move to previous inner TeX environment start',
            },
            F = {
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

function treesitter.navigate(buf)
    wk.add(mapper({
        -- Motions
        [']'] = {
            m = { to.move('goto_next_start', '@function.outer'), 'Move to next outer function start' },
            M = { to.move('goto_next_end', '@function.outer'), 'Move to next outer function end' },
            f = { to.move('goto_next_start', '@function.inner'), 'Move to next inner function start' },
            F = { to.move('goto_next_end', '@function.inner'), 'Move to next function inner end' },
            ['}'] = { to.move('goto_next_start', '@class.outer'), 'Move to next outer class start' },
            ['{'] = { to.move('goto_next_end', '@class.outer'), 'Move to next outer class end' },
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
            f = {
                to.move('goto_previous_start', '@function.inner'),
                'Move to previous inner function start',
            },
            F = { to.move('goto_previous_end', '@function.inner'), 'Move to previous function inner end' },
            ['{'] = {
                to.move('goto_previous_start', '@class.outer'),
                'Move to previous outer class start',
            },
            ['}'] = {
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
        mapper {
            ['cr'] = {
                name = 'Refactoring tools',
                i = { refac.refac 'Inline Variable', 'Inline Variable', mode = { 'n', 'x' } },
                b = { refac.refac 'Extract Block', 'extract block' },
                B = { refac.refac 'Extract Block To File', 'extract block to file' },
                v = { refac.refac 'Extract Variable', 'Extract Variable', mode = { 'n', 'x' } },
                f = { refac.refac 'Extract Function', 'Extract Function', mode = { 'n', 'x' } },
                F = { refac.refac 'Extract Function to File', 'Extract Function to File', mode = { 'n', 'x' } },
            },
            ['ga'] = {
                name = 'Add or apply',
                p = { refac.debug('printf', { below = true }), 'Printf below' },
                P = { refac.debug('printf', { below = false }), 'Printf above' },
                v = { refac.debug('print_var', { normal = true }), 'Printf variable', mode = { 'n', 'v' } },
                c = { refac.debug('cleanup', {}), 'Cleanup prints' },
            },
            ['sK'] = { vim.show_pos, 'Show treesitter node' },
            ['sI'] = { vim.treesitter.inspect_tree, 'Toggle playground' },
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
            f = { to.select '@function.outer', 'function' },
            F = { to.select '@frame.outer', 'frame' },
            c = { to.select '@conditional.outer', 'conditional' },
            C = { to.select '@call.outer', 'call' },
            o = { to.select '@class.outer', 'class' },
            e = { to.select '@block.outer', 'block' },
            d = { to.select '@comment.outer', 'comment' },
            s = { to.select '@statement.outer', 'statement' },
            v = { to.select '@variable.outer', 'variable' },
            l = { to.select '@loop.outer', 'loop' },
        },
        i = {
            name = 'inside',
            f = { to.select '@function.inner', 'function' },
            c = { to.select '@conditional.inner', 'conditional' },
            C = { to.select '@call.inner', 'call' },
            o = { to.select '@class.inner', 'class' },
            e = { to.select '@block.inner', 'block' },
            v = { to.select '@variable.inner', 'variable' },
            l = { to.select '@loop.inner', 'loop' },
        },
    }, { mode = 'x' }))

    wk.add(mapper({
        a = {
            name = 'around',
            f = { to.select '@function.outer', 'function' },
            F = { to.select '@frame.outer', 'frame' },
            c = { to.select '@conditional.outer', 'conditional' },
            C = { to.select '@call.outer', 'call' },
            o = { to.select '@class.outer', 'class' },
            e = { to.select '@block.outer', 'block' },
            d = { to.select '@comment.outer', 'comment' },
            s = { to.select '@statement.outer', 'statement' },
            v = { to.select '@variable.outer', 'variable' },
            l = { to.select '@loop.outer', 'loop' },
        },
        i = {
            name = 'inside',
            f = { to.select '@function.inner', 'function' },
            c = { to.select '@conditional.inner', 'conditional' },
            C = { to.select '@call.inner', 'call' },
            o = { to.select '@class.inner', 'class' },
            e = { to.select '@block.inner', 'block' },
            v = { to.select '@variable.inner', 'variable' },
            l = { to.select '@loop.inner', 'loop' },
        },
    }, { mode = 'o' }))
end

return treesitter
