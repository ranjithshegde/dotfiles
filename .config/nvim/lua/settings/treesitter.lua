local ts = {}

------------------------------------------------------------------------
--                             Treesitter                             --
------------------------------------------------------------------------

function ts.init()
    local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
    ft_to_parser.opencl = "c"
    ft_to_parser.vimwiki = "markdown"
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

return ts
