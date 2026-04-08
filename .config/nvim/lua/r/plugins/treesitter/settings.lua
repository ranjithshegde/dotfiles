local ts = {}
local aucmd = vim.api.nvim_create_autocmd
------------------------------------------------------------------------
--                             Treesitter Config                      --
------------------------------------------------------------------------

function ts.autocmds()
    local id = { Treesitter = vim.api.nvim_create_augroup('Treesitter', { clear = true }) }
    aucmd('BufReadPost', {
        group = id.Treesitter,
        callback = function()
            require('r.plugins.treesitter.mappings').common()
        end,
        once = true,
        desc = 'Load mappings treesiiter after reading buffer',
    })

    aucmd('FileType', {
        group = id.Treesitter,
        callback = function(args)
            if vim.tbl_contains(require('r.utils.tables').ignoreFiles, args.match) then
                return
            end

            if pcall(vim.treesitter.get_parser, args.buf) then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
            if args.match == 'tex' then
                require('r.plugins.treesitter.mappings').navigate_tex(args.buf)
            else
                require('r.plugins.treesitter.mappings').navigate(args.buf)
            end
        end,
        desc = 'Loading treesitter navigation mappings',
    })

    require('r.utils').register_au_id(id)
end

function ts.text_objects()
    require('nvim-treesitter-textobjects').setup {
        select = { enable = true, lookahead = true },
        move = {
            enable = true,
            set_jumps = false,
        },
        swap = { enable = true },
    }
end

function ts.refactoring()
    require('refactoring').setup {
        prompt_func_return_type = {
            cpp = true,
            c = true,
            h = true,
            hpp = true,
            cxx = true,
        },
        prompt_func_param_type = {
            cpp = true,
            c = true,
            h = true,
            hpp = true,
            cxx = true,
        },
        printf_statements = {
            cpp = {
                'std::cout << "%s" << std::endl;',
            },
            lua = {
                'vim.print("%s")',
            },
        },
        print_var_statements = {},
    }
end

function ts.node_action()
    require('ts-node-action').setup {
        ['*'] = {
            ['parameter_list'] = require('ts-node-action.actions').toggle_multiline(),
        },
        cpp = {
            ['field_identifier'] = require('ts-node-action.actions').cycle_case(),
            ['type_identifier'] = require('ts-node-action.actions').cycle_case(),
            ['initializer_list'] = require('ts-node-action.actions').toggle_multiline(),
            ['field_initializer_list'] = require('ts-node-action.actions').toggle_multiline(),
        },
    }
end

return ts
