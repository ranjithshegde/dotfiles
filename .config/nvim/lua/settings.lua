local settings = {}
local u = require "utils"
local o = vim.opt
local bo = vim.bo
require("impatient").enable_profile()

function settings.settings()
    settings.options()
    settings.vimwiki()
    settings.treesitter()
    settings.lsp_settings()
    settings.langServers()
    settings.lsp_lintFormat()
end

------------------------------------------------------------------------
--                              Vim basics                            --
------------------------------------------------------------------------
function settings.options()
    vim.cmd "colo tokyonight"
    local tab = 4
    o.number = true
    o.expandtab = true
    o.cursorline = true
    o.shiftround = true
    o.splitbelow = true
    o.splitright = true
    o.termguicolors = true
    o.relativenumber = true
    o.hlsearch = false
    o.tabstop = tab
    o.shiftwidth = tab
    o.softtabstop = tab
    o.scrolloff = 10
    o.updatetime = 300
    o.timeoutlen = 100
    o.conceallevel = 1
    o.foldmethod = "expr"
    o.inccommand = "split"
    o.spelloptions = "camel"
    o.grepprg = "rg --vimgrep"
    o.fillchars = "stlnc:»,vert:║,fold:."
    -- o.listchars = "tab:<->,eol:↲,space:→"
    o.completeopt = "menuone,noinsert,noselect"
    o.dictionary = os.getenv "XDG_DATA_HOME" .. "/dict/words"
    o.sessionoptions:append "terminal,tabpages"
    o.clipboard:append "unnamedplus"
    o.shortmess:append "c"
    G.termdebug_wide = 1
    G.do_filetype_lua = 1
    G.markdown_folding = 1
    G.tex_conceal = "abdmgs"
    G.did_load_filetypes = 0
    G.loaded_ruby_provider = 0
    G.loaded_perl_provider = 0
    G.loaded_python_provider = 0
    G.symbols_outline = { auto_preview = false, width = 40 }

    -- Folds for filetype
    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "markdown" and Op "filetype" ~= "vim" then
        o.foldexpr = "nvim_treesitter#foldexpr()"
    end

    -- ************** Disable builtin plugins ---------------------------------------------------------
    local disabled_built_ins = {
        "fzf",
        "tar",
        "zip",
        "gzip",
        "zipPlugin",
        "tarPlugin",
        "vimball",
        "vimballPlugin",
        "getscript",
        "getscriptPlugin",
        "2html_plugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "shada",
        "matchit",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
    }

    for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
    end

    -- ************** HighlightOnYank ---------------------------------------------------------
    function _G.HighlightOnYank()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
    end
    vim.cmd "au TextYankPost * silent! lua HighlightOnYank()"
end

------------------------------------------------------------------------
--                              VimWiki                               --
------------------------------------------------------------------------

function settings.vimwiki()
    local l = {}
    l.path = "$HOME/Documents/vimWiki"
    l.syntax = "markdown"
    l.ext = ".md"
    l.auto_diary_index = 1
    l.auto_toc = 1
    l.auto_generte_links = 1
    l.nested_syntaxes = { cpp = "cpp" }
    l.autowriteall = 1
    G.vimwiki_list = { l }
    G.vimwiki_markdown_link_ext = 1
    G.vimwiki_auto_chdir = 1
    G.vimwiki_folding = "expr"
end

------------------------------------------------------------------------
--                             Treesitter                             --
------------------------------------------------------------------------

function settings.treesitter()
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.org = {
        install_info = {
            url = "https://github.com/milisims/tree-sitter-org",
            revision = "f110024d539e676f25b72b7c80b0fd43c34264ef",
            -- revision = "main",
            files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "org",
    }
    parser_config.c.used_by = "opencl"
    require("nvim-treesitter.configs").setup {
        ensure_installed = {
            "bash",
            "bibtex",
            "cmake",
            "cpp",
            "comment",
            "css",
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
            select = {
                -- disable = { "lua", "vim" },
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
        playground = { enable = true, updatetime = 25, persist_queries = false },
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

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function settings.completion()
    require("mappings").autoComplete()
    G.completion_chain_complete_list = {
        supercollider = {
            { complete_items = { "snippet", "path" } },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        org = {
            { complete_items = { "snippet", "path" } },
            { mode = "omni" },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        glsl = {
            { complete_items = { "snippet" } },
            { mode = "user" },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        default = {
            { complete_items = { "lsp", "snippet", "path" } },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
    }
    G.completion_auto_change_source = 0
    G.completion_popup_border = "double"
    G.completion_disable_filetypes = { "TelescopePrompt", "text", "markdown", "vimwiki" }
    require("luasnip.loaders.from_vscode").lazy_load()
    G.completion_enable_snippet = "luasnip"

    u.create_augroup({
        { "FileType", "*", 'lua require"completion".on_attach()' },
        {
            "FileType",
            "supercollider,glsl,conf,org,cmake",
            "let g:completion_auto_change_source=1",
        },
        {
            "FileType",
            "cpp,c,hpp,lua,python,java,javascript,typescript",
            "let g:completion_auto_change_source=0",
        },
    }, "completion_attach")
end

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

function settings.lsp_settings()
    Lsp = require "lspconfig"
    require("utils.langServers").kind()

    local buffExec = "* <buffer>"
    local docHigh = {
        { "CursorHold", "<buffer>", [[lua vim.lsp.buf.document_highlight()]] },
        { "CursorMoved", "<buffer>", [[lua vim.lsp.buf.clear_references()]] },
        { "CursorMovedI", "<buffer>", [[lua vim.lsp.buf.clear_references()]] },
    }
    -- Set diagnostics to local list automatically
    u.create_augroup({ { "DiagnosticChanged", "*", "lua vim.diagnostic.setloclist({open = false})" } }, "LspLocList")

    Attach_props = function(client)
        require("mappings").nvim_lsp()

        vim.cmd "PackerLoad lsp-status.nvim"
        local lsp_status = require "lsp-status"

        if client.name ~= "ltex" and client.name ~= "efm" then
            lsp_status.register_progress()
        end

        lsp_status.on_attach(client)

        require("utils.diagnostics").attach({ all = false, underline = false, update_in_insert = false }, client)
        local rc = client.resolved_capabilities
        if rc.document_highlight then
            Exec "hi LspReferenceRead cterm=bold ctermbg=red guibg=#98971a"
            Exec "hi LspReferenceText cterm=bold ctermbg=red guibg=grey"
            Exec "hi LspReferenceWrite cterm=bold ctermbg=red guibg= #fbf1c7"
            u.create_cmdGroup(docHigh, buffExec, "lsp_highlightSymbol")
        end

        if rc.document_formatting then
            u.create_augroup({
                {
                    "BufWritePre",
                    "*.html,*.css,*.js,*.hpp,*.h,*.sh,*.lua,*.cpp,*.json,*.py,*.yaml,*.toml",
                    "lua vim.lsp.buf.formatting_sync(nil, 500)",
                },
            }, "lsp_auto_format")
        end
    end

    All_attach = function(client, bufnr)
        Attach_props(client)
        if Op "filetype" ~= "vimwiki" then
            bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
        end
    end

    Capabilities = vim.lsp.protocol.make_client_capabilities()
    Capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- Capabilities.offsetEncoding = { "utf-16" }

    Cinit = function(client)
        require("mappings").nvim_lsp()
        local rc = client.resolved_capabilities
        rc.document_formatting = false
        rc.document_range_formatting = false
        rc.document_highlight = false
        rc.document_symbol = false
        rc.workspace_symbol = false
        rc.rename = false
        rc.hover = false
        rc.completion = false
        rc.code_action = false
    end

    EfmAttach = function(client, bufnr)
        Attach_props(client)
        local rc = client.resolved_capabilities
        rc.document_formatting = false
    end

    -- borders for floating windows
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "double" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
    )
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function settings.langServers()
    local dict = os.getenv "XDG_CONFIG_HOME" .. "/nvim/spell/en.utf-8.add"
    local configs = {
        yamlls = { on_attach = All_attach },
        jsonls = { on_attach = EfmAttach },
        cssls = { on_attach = All_attach, capabilities = Capabilities },
        bashls = { on_attach = All_attach, filetypes = { "sh", "zsh" } },
        html = { on_attach = All_attach, capabilities = Capabilities },
        cmake = { on_attach = All_attach, capabilities = Capabilities },
        vimls = { on_attach = All_attach, capabilities = Capabilities },
        tsserver = { on_attach = All_attach, capabilities = Capabilities },
        pyright = { on_attach = All_attach, capabilities = Capabilities },
        ccls = {
            on_init = Cinit,
            handlers = {
                ["textDocument/publishDiagnostics"] = function(...)
                    return nil
                end,
                ["textDocument/signatureHelp"] = function(...)
                    return nil
                end,
            },
            -- init_options = { cache = { directory = "/tmp/ccls" } },
            single_file_support = true,
            root_dir = Lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        },
        clangd = {
            on_attach = All_attach,
            capabilities = Capabilities,
            filetypes = { "c", "cpp", "opencl" },
            cmd = {
                "clangd",
                "--clang-tidy",
                "--background-index",
                "--all-scopes-completion",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--suggest-missing-includes",
                "--fallback-style=webkit",
                "--cross-file-rename",
                "--offset-encoding=utf-32",
            },
        },
        ltex = {
            filetypes = { "bib", "markdown", "org", "tex" },
            on_attach = All_attach,
            capabilities = Capabilities,
            settings = {
                ltex = {
                    additionalRules = {
                        enablePickyRules = true,
                        motherTongue = "en",
                        languageModel = "/usr/share/Ngrams/",
                    },
                    dictionary = { ["en-US"] = u.concat_fileLines(dict) },
                },
            },
        },
        texlab = {
            on_attach = All_attach,
            capabilities = Capabilities,
            settings = {
                texlab = {
                    build = {
                        args = {
                            "-xelatex",
                            "-verbose",
                            "-file-line-error",
                            "-synctex=1",
                            "-interaction=nonstopmode",
                            "-shell-escape",
                            "%f",
                        },
                        executable = "latexmk",
                        forwardSearchAfter = true,
                    },
                    lint = { onSave = true, onChange = true },
                    chktex = { onOpenAndSave = true },
                    forwardSearch = {
                        args = {
                            "--synctex-forward",
                            "%l:1:%f",
                            "%p",
                        },
                        executable = "zathura",
                    },
                },
            },
        },
    }

    for ls, cfg in pairs(configs) do
        Lsp[ls].setup(cfg)
    end
end

------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

function settings.lsp_lintFormat()
    local rootDir = function()
        return vim.fn.getcwd() or Lsp.util.root_pattern ".git/"
    end
    local rootMarker = { vim.fn.getcwd() or { ".git/" } }

    local checkmake = { lintCommand = "checkmake", lintStdin = true }
    local yamllint = { lintCommand = "yamllint -f parsable -", lintStdin = true }
    local shfmt = { formatCommand = "shfmt -ci -s -bn", formatStdin = true }
    local prettier = { formatCommand = "prettier --stdin --stdin-filepath ${INPUT}", formatStdin = true }
    local isort = { formatCommand = "isort --stdout --profile black -", formatStdin = true }
    local black = { formatCommand = "black --fast -", formatStdin = true }
    local mypy = {
        lintCommand = "mypy --show-column-numbers",
        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
        lintSource = "mypy",
    }
    local flake8 = {
        lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintIgnoreExitCode = true,
        lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
        lintSource = "flake8",
    }
    local shellcheck = {
        lintCommand = "shellcheck -f gcc -x -",
        lintStdin = true,
        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
    }
    local markdownlint = {
        lintCommand = "markdownlint -f ${INPUT}",
        lintStdin = true,
        lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
    }
    local stylua = { formatCommand = "stylua --search-parent-directories -", formatStdin = true }
    local vint = {
        lintCommand = "vint -f '{file_path}:{line_number}:{column_number}: {severity}: {description} (see: {reference})' --enable-neovim",
        lintStdin = false,
        lintFormats = { "%f:%l:%c: %m" },
    }
    local clcc = {
        lintCommand = "clcc",
        lintStdin = true,
        lintFormats = {
            "%e:%l:%c: error: %m,%-z%p^[ ~]%#",
            "%w:%l:%c: warning: %m,%-z%p^[ ~]%#",
            "%i:%l:%c: note: %m,%-z%p^[ ~]%#",
        },
    }

    local languages = {
        vim = { vint },
        yaml = { yamllint },
        json = { prettier },
        html = { prettier },
        css = { prettier },
        toml = { prettier },
        lua = { stylua },
        make = { checkmake },
        vimwiki = { markdownlint },
        markdown = { prettier },
        sh = { shellcheck, shfmt },
        zsh = { shellcheck, shfmt },
        python = { flake8, isort, black, mypy },
        -- opencl = { clcc },
    }
    Lsp.efm.setup {
        filetypes = vim.tbl_keys(languages),
        root_dir = rootDir,
        on_attach = All_attach,
        init_options = { documentFormatting = true, codeAction = true },
        settings = { rootMarkers = rootMarker, languages = languages },
    }
end

------------------------------------------------------------------------
--                       Telescope 									  --
------------------------------------------------------------------------

function settings.telescope()
    require("telescope").setup {
        pickers = {
            find_files = { follow = true },
            buffers = {
                sort_mru = true,
                sort_lastused = true,
                mappings = {
                    i = {
                        ["<C-x>"] = function(prompt_bufnr)
                            local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                            local selected_bufnr = require("telescope.actions.state").get_selected_entry().bufnr

                            local replacement_buffers = {}
                            for entry in current_picker.manager:iter() do
                                if entry.bufnr < selected_bufnr then
                                    table.insert(replacement_buffers, 1, entry.bufnr)
                                end
                            end

                            current_picker:delete_selection(function(selection)
                                local bufnr = selection.bufnr
                                local winids = vim.fn.win_findbuf(bufnr)
                                local tabwins = vim.api.nvim_tabpage_list_wins(0)
                                for _, winid in ipairs(winids) do
                                    if vim.tbl_contains(tabwins, winid) then
                                        local new_buf = vim.F.if_nil(
                                            table.remove(replacement_buffers),
                                            vim.api.nvim_create_buf(false, true)
                                        )
                                        vim.api.nvim_win_set_buf(winid, new_buf)
                                    end
                                end
                                vim.api.nvim_buf_delete(bufnr, { force = true })
                            end)
                        end,
                    },
                },
            },
        },
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "-L",
            },
            prompt_prefix = "❯ ",
            selection_caret = "❯ ",
            file_ignore_patterns = { "%.MOV", "%.mov", "%.mp4", "%.wav", "%.mkv", "%.gif", "%.mp3" },
        },
    }
    vim.cmd "PackerLoad telescope-project.nvim"
    vim.cmd "PackerLoad telescope-file-browser.nvim"
end

-----------------------------------------------------------------------
--                       Sumneko lua development 	                  --
------------------------------------------------------------------------

function settings.luadev()
    local luadev = require("lua-dev").setup {
        library = { plugins = { "plenary.nvim", "telescope.nvim", "express_line.nvim", "nvim-lspconfig" } },
        lspconfig = {
            on_attach = All_attach,
            capabilities = Capabilities,
            settings = { Lua = { diagnostics = { globals = { "vim", "pd" } } } },
        },
    }
    luadev.settings.Lua.workspace.library[vim.fn.expand "~/.config/nvim"] = true
    luadev.settings.Lua.workspace.library["/usr/lib/pd/extra/pdlua"] = true
    Lsp.sumneko_lua.setup(luadev)
end

------------------------------------------------------------------------
--                       Custom Java Lsp         	                  --
------------------------------------------------------------------------

function settings.jdtls()
    require("debugger").init()
    local home = os.getenv "XDG_DATA_HOME"
    local debug_path =
        "/debug-adapters/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"

    require("jdtls").start_or_attach {
        cmd = { "jdtls" },
        on_attach = function(client, bufnr)
            Attach_props(client)
            bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("jdtls.setup").add_commands()
        end,
        capabilities = Capabilities,
        init_options = {
            bundles = {
                vim.fn.glob(home .. debug_path),
            },
        },
    }
end

------------------------------------------------------------------------
--                       Custom Folds            	                  --
------------------------------------------------------------------------

function settings.folds()
    require("pretty-fold").setup {
        matchup_patterns = {
            { "{", "}" },
            { "%(", ")" }, -- % to escape lua pattern char
            { "%[", "]" }, -- % to escape lua pattern char
            { "if%s", "end" },
            { "do%s", "end" },
            { "for%s", "end" },
            { "function%s", "end" },
        },
        fill_char = "━",
        sections = {
            left = {
                "━ ",
                function()
                    return string.rep("*", vim.v.foldlevel)
                end,
                " ━┫",
                "content",
                "     ",
                "number_of_folded_lines",
                " ┣",
            },
            right = {
                "┫ ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ┣━━",
            },
        },
    }
    require("pretty-fold.preview").setup {
        key = "l",
    }
end

return settings
