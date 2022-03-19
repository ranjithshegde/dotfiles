local ts = {}

------------------------------------------------------------------------
--                             Treesitter                             --
------------------------------------------------------------------------

function ts.init()
    local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
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
            "html",
            "java",
            "javascript",
            "json",
            "latex",
            "lua",
            "make",
            "markdown",
            "org",
            "python",
            "query",
            "regex",
            "supercollider",
            "toml",
            "vim",
            "yaml",
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
                    [";ss"] = "@statement.outer",
                    [";sp"] = "@parameter.inner",
                    [";sP"] = "@parameter.outer",
                    [";sF"] = "@function.inner",
                    [";sf"] = "@function.outer",
                    [";sc"] = "@conditional.outer",
                    [";sC"] = "@conditional.inner",
                    [";sl"] = "@loop.outer",
                    [";sL"] = "@loop.inner",
                    [";so"] = "@comment.outer",
                    [";sa"] = "@call.outer",
                    [";sA"] = "@call.inner",
                },
                swap_previous = {
                    [";Ss"] = "@statement.outer",
                    [";Sp"] = "@parameter.inner",
                    [";SP"] = "@parameter.outer",
                    [";SF"] = "@function.inner",
                    [";Sf"] = "@function.outer",
                    [";Sc"] = "@conditional.outer",
                    [";SC"] = "@conditional.inner",
                    [";Sl"] = "@loop.outer",
                    [";SL"] = "@loop.inner",
                    [";So"] = "@comment.outer",
                    [";Sa"] = "@call.outer",
                    [";SA"] = "@call.inner",
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
            highlight_current_scope = { enable = true },
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
    }
end

return ts
