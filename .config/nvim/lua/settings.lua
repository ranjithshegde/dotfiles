local settings = {}
local u = require "utils"
local o = vim.opt
require("impatient").enable_profile()

function settings.settings()
    settings.options()
    settings.vimwiki()
    settings.completion()
    settings.treesitter()
    settings.lsp_settings()
    settings.langServers()
    settings.lsp_lintFormat()
end

------------------------------------------------------------------------
--                              Vim basics                            --
------------------------------------------------------------------------
function settings.options()
    -- G.tokyonight_style = "light"
    Exec "packadd tokyonight.nvim"
    Exec "colo tokyonight"
    local tab = 4
    o.cursorline = true
    o.expandtab = true
    o.hidden = true
    o.number = true
    o.relativenumber = true
    o.shiftround = true
    o.splitbelow = true
    o.splitright = true
    o.termguicolors = true
    o.hlsearch = false
    o.shiftwidth = tab
    o.softtabstop = tab
    o.tabstop = tab
    o.conceallevel = 1
    o.scrolloff = 10
    o.updatetime = 300
    o.timeoutlen = 500
    o.foldminlines = 1
    o.signcolumn = "yes"
    o.foldmethod = "expr"
    o.spelloptions = "camel"
    o.grepprg = "rg --vimgrep"
    o.fillchars = "stlnc:»,vert:║,fold:."
    -- o.listchars = "tab:<->,eol:↲,space:→"
    o.completeopt = "menuone,noinsert,noselect"
    o.dictionary = os.getenv "XDG_DATA_HOME" .. "/dict/words"
    o.clipboard:append "unnamedplus"
    o.shortmess:append "c"
    G.termdebug_wide = 1
    G.markdown_folding = 1
    G.loaded_ruby_provider = 0
    G.loaded_perl_provider = 0
    G.loaded_python_provider = 0
    G.tex_conceal = "abdmgs"
    o.formatoptions = {
        a = false, -- Dont format pasted code
        t = false, -- Delegate to linter prgs/LSP
        o = false, -- O and o don't continue comments
        r = false, -- Return does not continue comments
        c = true, -- comments respect textwidth
        q = true, -- Allow formatting comments w/ gq
        n = true, -- Recognize numbered lists
        j = true, -- Auto-remove comments if possible.
        ["2"] = true, -- Indent according to 2nd line
    }
    -- Folds for filetype
    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "markdown" and Op "filetype" ~= "vim" then
        o.foldexpr = "nvim_treesitter#foldexpr()"
    end

    -- ************** Disable builtin plugins ---------------------------------------------------------
    local disabled_built_ins = {
        "gzip",
        "zip",
        "zipPlugin",
        "tar",
        "fzf",
        "shada",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "matchit",
    }

    for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
    end

    -- ************** HighlightOnYank ---------------------------------------------------------
    function _G.HighlightOnYank()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
    end
    u.create_augroup({ { "TextYankPost", "*", "silent! lua HighlightOnYank()" } }, "YankHighlight")
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
            revision = "main",
            files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "org",
    }
    require("nvim-treesitter.configs").setup {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "latex", "markdown", "org" },
        },
        indent = { enable = true, disable = { "python", "org" } },
        autopairs = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = ";nn",
                node_incremental = ";rn",
                scope_incremental = ";rc",
                node_decremental = ";rm",
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
                    ["iF"] = {
                        supercollider = "(function_definition) @function",
                        cpp = "(function_definition) @function",
                        c = "(function_definition) @function",
                    },
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
                border = "double",
                enable = true,
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
            { complete_items = { "UltiSnips", "path" } },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        org = {
            { complete_items = { "snippet" } },
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

    if Op "filetype" == "supercollider" then
        G.completion_enable_snippet = "UltiSnips"
    else
        G.completion_enable_snippet = "vim-vsnip"
    end

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

    -- Status bar for LSP
    Lsp_status = require "lsp-status"
    Lsp_status.register_progress()
    require("icons").init()

    local buffExec = "* <buffer>"
    local docHigh = {
        { "CursorHold", "<buffer>", [[lua vim.lsp.buf.document_highlight()]] },
        { "CursorMoved", "<buffer>", [[lua vim.lsp.buf.clear_references()]] },
        { "CursorMovedI", "<buffer>", [[lua vim.lsp.buf.clear_references()]] },
    }

    -- Set diagnostics to local list automatically
    u.create_augroup(
        { { "User LspDiagnosticsChanged", "lua vim.diagnostic.setloclist({open = false})" } },
        "LspLocList"
    )

    All_attach = function(client, bufnr)
        require("mappings").nvim_lsp()
        Lsp_status.on_attach(client)
        local rc = client.resolved_capabilities
        Exec "PackerLoad vim-vsnip-integ"
        vim.fn["vsnip#get_complete_items"](vim.fn["bufnr"]())

        if rc.document_highlight then
            Exec "hi LspReferenceRead cterm=bold ctermbg=red guibg=#98971a"
            Exec "hi LspReferenceText cterm=bold ctermbg=red guibg=grey"
            Exec "hi LspReferenceWrite cterm=bold ctermbg=red guibg= #fbf1c7"
            u.create_cmdGroup(docHigh, buffExec, "bufgroup")
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

    Capabilities = vim.lsp.protocol.make_client_capabilities()
    Capabilities.textDocument.completion.completionItem.snippetSupport = true

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

    EfmAttach = function(client)
        require("mappings").nvim_lsp()
        local rc = client.resolved_capabilities
        rc.document_formatting = false
        Lsp_status.on_attach(client)
        Exec "PackerLoad vim-vsnip-integ"
        vim.fn["vsnip#get_complete_items"](vim.fn["bufnr"]())

        if rc.document_highlight then
            Exec "hi LspReferenceRead cterm=bold ctermbg=red guibg=#98971a"
            Exec "hi LspReferenceText cterm=bold ctermbg=red guibg=grey"
            Exec "hi LspReferenceWrite cterm=bold ctermbg=red guibg= #fbf1c7"
            u.create_cmdGroup(docHigh, buffExec, "bufgroup")
        end
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
            init_options = { cache = { directory = "/tmp/ccls" } },
        },
        clangd = {
            handlers = Lsp_status.extensions.clangd.setup(),
            on_attach = All_attach,
            capabilities = Capabilities,
            cmd = {
                "clangd",
                "--clang-tidy",
                "--background-index",
                "--all-scopes-completion",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--cross-file-rename",
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
    Lsp.diagnosticls.setup {
        cmd = { "diagnostic-languageserver", "--stdio" },
        filetypes = { "markdown", "tex", "text", "vimwiki" },
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                { virtual_text = false }
            ),
        },
        on_attach = EfmAttach,
        init_options = {
            linters = {
                ["write-good"] = {
                    command = "write-good",
                    debounce = 100,
                    args = { "--text=%text" },
                    offsetLine = 0,
                    offsetColumn = 1,
                    sourceName = "write-good",
                    formatLines = 1,
                    formatPattern = {
                        "(.*)\\s+on\\s+line\\s+(\\d+)\\s+at\\s+column\\s+(\\d+)\\s*$",
                        { line = 2, column = 3, message = 1 },
                    },
                },
                languagetool = {
                    command = "languagetool",
                    debounce = 200,
                    args = { "--languagemodel", "/usr/share/Ngram", "%file" },
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "languagetool",
                    formatLines = 2,
                    formatPattern = {
                        "^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$",
                        { line = 1, column = 2, message = { 4, 3 } },
                    },
                },
                textidote = {
                    command = "textidote",
                    debounce = 500,
                    args = {
                        "--type",
                        "tex",
                        "--read-all",
                        "--check",
                        "en",
                        "--languagemodel",
                        "/usr/share/Ngram",
                        "--dict",
                        "/usr/share/words.txt",
                        "--output",
                        "singleline",
                        "--no-color",
                    },
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "textidote",
                    formatLines = 1,
                    formatPattern = {
                        '\\(L(\\d+)C(\\d+)-L(\\d+)C(\\d+)\\):(.+)".+"$',
                        { line = 1, column = 2, endLine = 3, endColumn = 4, message = 5 },
                    },
                },
                mdidote = {
                    command = "textidote",
                    debounce = 500,
                    args = {
                        "--type",
                        "md",
                        "--check",
                        "en",
                        "--languagemodel",
                        "/usr/share/Ngram",
                        "--dict",
                        "/usr/share/words.txt",
                        "--output",
                        "singleline",
                        "--no-color",
                    },
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "textidote",
                    formatLines = 1,
                    formatPattern = {
                        '\\(L(\\d+)C(\\d+)-L(\\d+)C(\\d+)\\):(.+)".+"$',
                        { line = 1, column = 2, endLine = 3, endColumn = 4, message = 5 },
                    },
                },
            },
            formatters = {},
            filetypes = {
                markdown = "mdidote",
                vimwiki = "mdidote",
                tex = "textidote",
                text = { "languagetool", "write-good" },
            },
            formatFiletypes = {},
        },
    }

    local rootDir = function()
        return vim.fn.getcwd() or Lsp.util.root_pattern ".git/"
    end
    local rootMarker = { vim.fn.getcwd() or { ".git/" } }

    local checkmake = { lintCommand = "checkmake", lintStdin = true }
    local glslang = { lintCommand = "glslangValidator --stdin -S %:e", lintStdin = true }
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
        lintCommand = "markdownlint -s -c",
        lintStdin = true,
        lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
    }
    local stylua = { formatCommand = "stylua --search-parent-directories -", formatStdin = true }
    local vint = {
        lintCommand = "vint -f '{file_path}:{line_number}:{column_number}: {severity}: {description} (see: {reference})' --enable-neovim",
        lintStdin = false,
        -- lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m" },
        lintFormats = { "%f:%l:%c: %m" },
    }

    local languages = {
        vim = { vint },
        yaml = { yamllint },
        json = { prettier },
        html = { prettier },
        css = { prettier },
        toml = { prettier },
        lua = { stylua },
        glsl = { glslang },
        make = { checkmake },
        vimwiki = { prettier },
        markdown = { prettier },
        sh = { shellcheck, shfmt },
        zsh = { shellcheck, shfmt },
        python = { flake8, isort, black, mypy },
    }
    Lsp.efm.setup {
        filetypes = vim.tbl_keys(languages),
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                { virtual_text = false }
            ),
        },
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
        pickers = { find_files = { follow = true } },
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
    Cmd "PackerLoad telescope-project.nvim"
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
            cmd = {
                "lua-language-server",
                "-E",
                "lua-language-server" .. "/main.lua",
            },
            settings = { Lua = { diagnostics = { globals = { "vim", "pd" } } } },
        },
    }
    luadev.settings.Lua.workspace.library["/usr/lib/pd/extra/pdlua"] = true
    Lsp.sumneko_lua.setup(luadev)
end

------------------------------------------------------------------------
--                       Custom Java Lsp         	                  --
------------------------------------------------------------------------

function settings.jdtls()
    require("jdtls").start_or_attach {
        on_attach = All_attach,
        capabilities = Capabilities,
        cmd = { "jdtls" },
    }
    require("jdtls.setup").add_commands()
end

--------------------------------------------------------------------------
----                              Snippets                              --
--------------------------------------------------------------------------

function settings.ultisnips()
    local snippet_directories = { "UltiSnips", "scnvim-data" }
    Var("UltiSnipsExpandTrigger", "<tab>")
    Var("UltiSnipsJumpForwardTrigger", "<tab>")
    Var("UltiSnipsJumpBackwardTrigger", "<c-tab>")
    Var("UltiSnipsSnippetDirectories", snippet_directories)
end

return settings
