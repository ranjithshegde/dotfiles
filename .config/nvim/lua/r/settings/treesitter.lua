local parsers = require "nvim-treesitter.parsers"
local ts_utils = require "nvim-treesitter.ts_utils"

local ts = {}
------------------------------------------------------------------------
--                             Treesitter Config                      --
------------------------------------------------------------------------

function ts.init()
    local ft_to_parser = parsers.filetype_to_parsername
    ft_to_parser.opencl = "c"

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.org = {
        install_info = {
            url = "https://github.com/milisims/tree-sitter-org",
            revision = "698bb1a34331e68f83fc24bdd1b6f97016bb30de",
            files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "org",
    }
    require("nvim-treesitter.configs").setup {
        ensure_installed = require("r.utils.tables").ts_parsers,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "latex", "org" },
        },
        indent = { enable = true, disable = { "python", "org" } },
        autopairs = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = ";gn",
                node_incremental = ";gi",
                scope_incremental = ";gs",
                node_decremental = ";gr",
            },
        },
        textobjects = {
            select = { enable = true },
            move = {
                enable = true,
                set_jumps = false,
            },
            swap = {
                enable = true,
            },
            lsp_interop = {
                enable = true,
                border = "double",
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        rainbow = {
            enable = true,
            extended_mode = true,
        },
        playground = { enable = true, updatetime = 25, persist_queries = false },
        nt_cpp_tools = {
            enable = true,
            preview = {
                quit = "Q",
                accept = "<leader><cr>",
            },
            header_extension = "h",
            source_extension = "cxx",
            custom_define_class_function_commands = {
                TSCppImplWrite = {
                    output_handle = pcall(require, '("nvim-treesitter.nt-cpp-tools.output_handlers").get_add_to_cpp()'),
                },
            },
        },
    }
end

function ts.refactoring()
    require("refactoring").setup {
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
                'vim.pretty_print("%s")',
            },
        },
        print_var_statements = {},
    }
    if package.loaded.telescope then
        require("telescope").load_extension "refactoring"
    end
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
        return ""
    end
    local line = transform_fn(vim.trim(vim.treesitter.query.get_node_text(node, bufnr) or ""))

    for index, value in pairs(require("r.utils.tables").tsNodeSymbols) do
        index = index:gsub("%[", "")
        index = index:gsub("%]", "")
        if index == "section" and line:find "*" then
            line = line:gsub("*", "")
        end

        if index == i then
            line = value .. line
        end
        if line:find(index) then
            if line:find(value) then
                line = line:gsub(index, "")
            else
                line = line:gsub(index, value)
            end
        end
    end
    -- Escape % to avoid statusline to evaluate content as expression
    return line:gsub("%%", "%%%%")
end
-- Trim spaces and opening brackets from end
local function transform_line(line)
    line = line:sub(1, line:find "\n")
    return line:gsub("%s*[%[%(%{]*%s*$", "")
end

function ts.statusline(opts)
    if not parsers.has_parser() then
        return
    end
    local options = opts

    local bufnr = options.bufnr
    local indicator_size = options.indicator_size
    local type_patterns = options.type_patterns
    local transform_fn = transform_line
    local separator = " -> "

    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then
        return ""
    end

    local lines = {}
    local expr = current_node

    while expr do
        local line = get_line_for_node(expr, type_patterns, transform_fn, bufnr)
        if line ~= "" and not vim.tbl_contains(lines, line) then
            table.insert(lines, 1, line)
        end
        expr = expr:parent()
    end

    local text = table.concat(lines, separator)
    local text_len = #text
    if text_len > indicator_size then
        text_len = text:find(" ", indicator_size)
        return text:sub(1, text_len) .. "..."
    end

    return text
end

return ts
