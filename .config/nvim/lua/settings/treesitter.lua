local parsers = require "nvim-treesitter.parsers"
local ts_utils = require "nvim-treesitter.ts_utils"
local ls = require "utils.langServers"

local ts = {}
------------------------------------------------------------------------
--                             Treesitter Config                      --
------------------------------------------------------------------------

function ts.init()
    local ft_to_parser = parsers.filetype_to_parsername
    ft_to_parser.opencl = "c"
    require("nvim-treesitter.configs").setup {
        ensure_installed = {
            "bash",
            "bibtex",
            "cmake",
            "cpp",
            "comment",
            "css",
            "dart",
            "glsl",
            "help",
            "html",
            "java",
            "javascript",
            "json",
            "latex",
            "lua",
            "make",
            "markdown",
            "python",
            "query",
            "regex",
            "scheme",
            "supercollider",
            "toml",
            "vim",
            "yaml",
            "org",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "latex", "org" },
        },
        indent = { enable = true, disable = { "python", "org", "vim" } },
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
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aF"] = "@frame.outer",
                    ["ao"] = "@class.outer",
                    ["io"] = "@class.inner",
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["ae"] = "@block.outer",
                    ["ie"] = "@block.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["as"] = "@statement.outer",
                    ["ad"] = "@comment.outer",
                    ["aC"] = "@call.outer",
                    ["iC"] = "@call.inner",
                    ["av"] = "@variable.outer",
                    ["iv"] = "@variable.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = false,
                goto_next_start = {
                    ["]n"] = "@function.outer",
                    ["]="] = "@class.outer",
                    ["]i"] = "@function.inner",
                    ["<Down>"] = "@block.outer",
                    ["<Right>"] = "@block.inner",
                },
                goto_next_end = {
                    ["]N"] = "@function.outer",
                    ["]I"] = "@function.inner",
                },
                goto_previous_start = {
                    ["[n"] = "@function.outer",
                    ["[="] = "@class.outer",
                    ["[i"] = "@function.inner",
                    ["<Up>"] = "@block.outer",
                    ["<Left>"] = "@block.inner",
                },
                goto_previous_end = {
                    ["[N"] = "@function.outer",
                    ["[I"] = "@function.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["cxas"] = "@statement.outer",
                    ["cxip"] = "@parameter.inner",
                    ["cxap"] = "@parameter.outer",
                    ["cxif"] = "@function.inner",
                    ["cxaf"] = "@function.outer",
                    ["cxac"] = "@conditional.outer",
                    ["cxic"] = "@conditional.inner",
                    ["cxal"] = "@loop.outer",
                    ["cxil"] = "@loop.inner",
                    ["cxao"] = "@comment.outer",
                    ["cxia"] = "@call.outer",
                    ["cxaa"] = "@call.inner",
                    ["cxav"] = "@variable.outer",
                    ["cxiv"] = "@variable.inner",
                },
                swap_previous = {
                    ["cXas"] = "@statement.outer",
                    ["cXip"] = "@parameter.inner",
                    ["cXaP"] = "@parameter.outer",
                    ["cXif"] = "@function.inner",
                    ["cXaf"] = "@function.outer",
                    ["cXac"] = "@conditional.outer",
                    ["cXic"] = "@conditional.inner",
                    ["cXal"] = "@loop.outer",
                    ["cXil"] = "@loop.inner",
                    ["cXao"] = "@comment.outer",
                    ["cXaa"] = "@call.outer",
                    ["cXia"] = "@call.inner",
                    ["cXav"] = "@variable.outer",
                    ["cXiv"] = "@variable.inner",
                },
            },
            lsp_interop = {
                enable = true,
                border = "double",
                peek_definition_code = { [";pf"] = "@function.outer", [";pc"] = "@class.outer" },
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        refactor = {
            highlight_definitions = { enable = true },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = ";d",
                    list_definitions = ";lg",
                    list_definitions_toc = ";ll",
                    goto_next_usage = ";*",
                    goto_previous_usage = ";#",
                },
            },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = ";r",
                },
            },
        },
        rainbow = {
            enable = true,
            extended_mode = true,
        },
        playground = { enable = true, updatetime = 25, persist_queries = false },
    }
end

------------------------------------------------------------------------
--                             Treesitter Statusline                  --
------------------------------------------------------------------------

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
        local line = ls.get_line_for_node(expr, type_patterns, transform_fn, bufnr)
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
