local ts = {}
local aucmd = vim.api.nvim_create_autocmd
------------------------------------------------------------------------
--                             Treesitter Config                      --
------------------------------------------------------------------------

function ts.autocmds()
    local id = {}
    id.Treesitter = vim.api.nvim_create_augroup('Treesitter', { clear = true })
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
            if args.match == 'tex' then
                require('r.plugins.treesitter.mappings').navigate_tex(args.buf)
            else
                require('r.plugins.treesitter.mappings').navigate(args.buf)
            end
        end,
        desc = 'Loading treesitter navigation mappings',
    })

    aucmd('FileType', {
        group = id.Treesitter,
        pattern = { 'c', 'cpp', 'hpp' },
        callback = function(args)
            require('r.plugins.treesitter.mappings').cpp(args.buf)
        end,
        desc = 'Treesitter C++ refactoring mappings',
    })

    require('r.utils').register_au_id(id)
end

function ts.setup()
    vim.treesitter.language.register('c', 'opencl')
    vim.treesitter.language.register('bash', 'zsh')

    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.org = {
        install_info = {
            url = 'https://github.com/milisims/tree-sitter-org',
            revision = '081179c52b3e8175af62b9b91dc099d010c38770',
            files = { 'src/parser.c', 'src/scanner.cc' },
        },
        filetype = 'org',
    }
    require('nvim-treesitter.configs').setup {
        ensure_installed = require('r.utils.tables').ts_parsers,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { 'latex', 'org' },
            disable = function(_, buf)
                local max_filesize = 1000 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        indent = { enable = true, disable = { 'python', 'org' } },
        autopairs = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = ';gn',
                node_incremental = ';gi',
                scope_incremental = ';gs',
                node_decremental = ';gr',
            },
        },
        textobjects = {
            select = { enable = true, lookahead = true },
            move = {
                enable = true,
                set_jumps = false,
            },
            swap = {
                enable = true,
            },
            lsp_interop = {
                enable = true,
                border = 'double',
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { 'BufWrite', 'CursorHold' },
        },
        -- rainbow = {
        --     enable = true,
        --     extended_mode = true,
        -- },
    }
end

function ts.cpp_tools()
    require('nt-cpp-tools').setup {
        preview = {
            quit = 'Q',
            accept = '<leader><cr>',
        },
        header_extension = 'h',
        source_extension = 'cxx',
        custom_define_class_function_commands = {
            TSCppImplWrite = {
                output_handle = require('nt-cpp-tools.output_handlers').get_add_to_cpp(),
            },
        },
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
    if package.loaded.telescope then
        require('telescope').load_extension 'refactoring'
    end
end

function ts.node_action()
    require('ts-node-action').setup {
        cpp = {
            ['field_identifier'] = require('ts-node-action.actions').cycle_case(),
            ['type_identifier'] = require('ts-node-action.actions').cycle_case(),
        },
        supercollider = {
            ['method_call'] = require('ts-node-action.actions').toggle_multiline(),
            ['parameter_call_list'] = require('ts-node-action.actions').toggle_multiline(),
            ['parameter_list'] = require('ts-node-action.actions').toggle_multiline(),
        },
    }
end

function ts.indent_guide()
    local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
    }
    local hooks = require 'ibl.hooks'
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require('ibl').setup { scope = { highlight = highlight } }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

function ts.trevj()
    require('trevj').setup()
    vim.keymap.set('n', ';J', function()
        require('trevj').format_at_cursor()
    end)
end

------------------------------------------------------------------------
--                             Treesitter Statusline                  --
------------------------------------------------------------------------

-- get current node
local function get_line_for_node(node, type_patterns, transform_fn, bufnr)
    local node_type = node:type()
    local is_valid = false
    local i
    for _, rgx in ipairs(type_patterns) do
        if node_type:find(rgx) then
            is_valid = true
            i = rgx
            break
        end
    end
    if not is_valid then
        return ''
    end
    local line = transform_fn(vim.trim(vim.treesitter.get_node_text(node, bufnr) or ''))

    for index, value in pairs(require('r.utils.tables').tsNodeSymbols) do
        index = index:gsub('%[', ''):gsub('%]', '')
        if index == 'section' and line:find '*' then
            line = line:gsub('*', '')
        end

        if index == i then
            line = value .. line
        end
        if line:find(index) then
            if line:find(value) then
                line = line:gsub(index, '')
            else
                line = line:gsub(index, value)
            end
        end
    end
    -- Escape % to avoid statusline to evaluate content as expression
    return line:gsub('%%', '%%%%')
end

-- Trim spaces and opening brackets from end
local function transform_line(line)
    line = line:sub(1, line:find '\n')
    return line:gsub('%s*[%[%(%{]*%s*$', '')
end

function ts.statusline(opts)
    if not vim.treesitter.language.get_lang(vim.bo.filetype) then
        return
    end

    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ''
    end

    local lines = {}
    local separator = ' -> '

    while current_node do
        local line = get_line_for_node(current_node, opts.type_patterns, transform_line, opts.bufnr)
        if line ~= '' and not vim.tbl_contains(lines, line) then
            table.insert(lines, 1, line)
        end
        current_node = current_node:parent()
    end

    local text = table.concat(lines, separator)
    local text_len = #text
    if text_len > opts.indicator_size then
        text_len = text:find(' ', opts.indicator_size)
        return text:sub(1, text_len) .. '...'
    end

    return text
end

return ts
