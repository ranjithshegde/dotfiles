local settings = {}
local o = vim.opt
local bo = vim.bo
require("impatient").enable_profile()

function settings.general()
    settings.options()
    settings.vimwiki()
    settings.treesitter()
end

------------------------------------------------------------------------
--                              Vim basics                            --
------------------------------------------------------------------------
function settings.options()
    require("nightfox").load()
    local tab = 4
    -- o.list = true
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
    o.grepprg = "rg --vimgrep --smart-case --hidden"
    o.grepformat = "%f:%l:%c:%m"
    o.fillchars = "stlnc:»,vert:║,fold:."
    o.listchars:append "eol:↲"
    -- o.listchars = "tab:<->,eol:↲,space:→"
    o.completeopt = "menuone,noinsert,noselect"
    o.dictionary = os.getenv "XDG_DATA_HOME" .. "/dict/words"
    o.tabline = [[%!luaeval('require("statusline").tabs()')]]
    o.sessionoptions:append "terminal,tabpages"
    o.clipboard:append "unnamedplus"
    o.shortmess:append "c"
    G.termdebug_wide = 1
    G.markdown_folding = 1
    G.tex_conceal = "abdmgs"
    G.loaded_ruby_provider = 0
    G.loaded_perl_provider = 0
    G.netrw_browsex_viewer = "xdg-open"
    G.symbols_outline = { auto_preview = false, width = 40 }

    -- Folds for filetype
    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "markdown" then
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
    AuCmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
        end,
    })
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
    G.completion_disable_filetypes = { "TelescopePrompt", "markdown", "text", "vimwiki" }
    require("luasnip.loaders.from_vscode").lazy_load()
    G.completion_enable_snippet = "luasnip"

    AuGroup("CompletionAttach", {})
    AuCmd("FileType", {
        group = "CompletionAttach",
        callback = function()
            require("completion").on_attach()
        end,
    })
    AuCmd("FileType", {
        group = "CompletionAttach",
        pattern = "supercollider,glsl,conf,org,cmake",
        command = "let g:completion_auto_change_source = 1",
    })
    AuCmd("FileType", {
        group = "CompletionAttach",
        pattern = "cpp,c,hpp,lua,python,java,javascript,typescript",
        command = "let g:completion_auto_change_source = 0",
    })
end

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

function settings.lsp_settings()
    Lsp = require "lspconfig"

    AuGroup("SetDiagnosticFuncs", {})
    AuCmd({ "DiagnosticChanged" }, {
        group = "SetDiagnosticFuncs",
        callback = function()
            vim.diagnostic.setloclist { open = false }
            require("utils").commands()
        end,
    })

    Capabilities = vim.lsp.protocol.make_client_capabilities()
    Capabilities.textDocument.completion.completionItem.snippetSupport = true

    Attach_props = function(client)
        require("mappings").nvim_lsp()
        require("utils.langServers").kind()

        vim.cmd "PackerLoad lsp-status.nvim"
        local lsp_status = require "lsp-status"

        if client.name ~= "ltex" and client.name ~= "efm" then
            lsp_status.register_progress()
        end
        lsp_status.on_attach(client)
        require("utils.diagnostics").attach({ all = false, underline = false, update_in_insert = false }, client)

        local rc = client.resolved_capabilities
        if rc.document_highlight then
            Api.nvim_set_hl(0, "LspReferenceRead", { cterm = { bold = true }, ctermbg = "red", bg = Colors.green })
            Api.nvim_set_hl(0, "LspReferenceText", { cterm = { bold = true }, ctermbg = "red", bg = "grey" })
            Api.nvim_set_hl(0, "LspReferenceWrite", { cterm = { bold = true }, ctermbg = "red", bg = Colors.white })

            AuGroup("LspHighlightSymbols", {})
            AuCmd("CursorHold", {
                group = "LspHighlightSymbols",
                buffer = 0,
                callback = vim.lsp.buf.document_highlight,
            })
            AuCmd("CursorMoved, CursorMovedI", {
                group = "LspHighlightSymbols",
                buffer = 0,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if rc.document_formatting then
            AuGroup("LspAutoFormat", {})
            AuCmd("BufWrite", {
                group = "LspAutoFormat",
                pattern = "*.html,*.css,*.js,*.hpp,*.h,*.sh,*.lua,*.cpp,*.json,*.py,*.yaml,*.toml,*.vs,*.fs,*.gs,*.vert,*.frag,*.geom,*.glsl",
                callback = function()
                    vim.lsp.buf.formatting_sync(nil, 500)
                end,
            })
        end
        Api.nvim_add_user_command("LspCapabilities", require("utils.langServers").lsp_capabilities, {})
        local ok, status = pcall(require, "lsp-status")
        if ok then
            Capabilities = vim.tbl_extend("keep", Capabilities, status.capabilities)
        end
    end

    All_attach = function(client, bufnr)
        Attach_props(client)
        if Op "filetype" ~= "vimwiki" then
            bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
        end
    end

    Cinit = function(client, bufnr)
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
        jsonls = { on_attach = EfmAttach },
        yamlls = { on_attach = All_attach },
        html = { on_attach = All_attach, capabilities = Capabilities },
        cssls = { on_attach = All_attach, capabilities = Capabilities },
        cmake = { on_attach = All_attach, capabilities = Capabilities },
        vimls = { on_attach = All_attach, capabilities = Capabilities },
        pyright = { on_attach = All_attach, capabilities = Capabilities },
        tsserver = { on_attach = All_attach, capabilities = Capabilities },
        bashls = { on_attach = All_attach, capabilities = Capabilities, filetypes = { "sh", "zsh" } },
        ccls = {
            on_init = Cinit,
            filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
            handlers = {
                ["textDocument/publishDiagnostics"] = function(...)
                    return nil
                end,
                ["textDocument/signatureHelp"] = function(...)
                    return nil
                end,
            },
            single_file_support = true,
            root_dir = Lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
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
                    language = "en-GB",
                    dictionary = { ["en-GB"] = require("utils").concat_fileLines(dict) },
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
    local clang_format = { formatCommand = "clang-format -", formatStdin = true }
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

    local languages = {
        vim = { vint },
        yaml = { yamllint },
        json = { prettier },
        html = { prettier },
        css = { prettier },
        toml = { prettier },
        lua = { stylua },
        glsl = { clang_format },
        make = { checkmake },
        vimwiki = { markdownlint },
        markdown = { prettier },
        sh = { shellcheck, shfmt },
        zsh = { shellcheck, shfmt },
        python = { flake8, isort, black, mypy },
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
            file_ignore_patterns = {
                "%.MOV",
                "%.mov",
                "%.mp4",
                "%.wav",
                "%.WAV",
                "%.mkv",
                "%.gif",
                "%.mp3",
                "%.m4a",
                "%.au",
            },
        },
    }
end

-----------------------------------------------------------------------
--                       Sumneko lua development 	                  --
------------------------------------------------------------------------

function settings.luadev()
    if not package.loaded["settings.lsp_settings"] then
        require("settings").lsp_settings()
    end
    local luadev = require("lua-dev").setup {
        library = { plugins = { "plenary.nvim", "telescope.nvim", "express_line.nvim", "nvim-lspconfig" } },
        lspconfig = {
            on_attach = EfmAttach,
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
    if not package.loaded["settings.lsp_settings"] then
        require("settings").lsp_settings()
    end
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
--                       Clangd  Lsp         	                      --
------------------------------------------------------------------------
--
function settings.clangd()
    if not package.loaded["settings.lsp_settings"] then
        require("settings").lsp_settings()
    end
    local ok, status = pcall(require, "lsp-status")
    local handlers = nil
    if ok then
        handlers = status.extensions.clangd.setup()
    end
    require("clangd_extensions").setup {
        server = {
            on_attach = All_attach,
            capabilities = Capabilities,
            filetypes = { "c", "cpp", "opencl" },
            init_options = {
                clangdFileStatus = true,
            },
            handlers = handlers,
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
        extensions = {
            autoSetHints = false,
            memory_usage = {
                border = "rounded",
            },
            symbol_info = {
                border = "rounded",
            },
        },
    }
end

------------------------------------------------------------------------
--                       Custom Folds            	                  --
------------------------------------------------------------------------

function settings.folds()
    require("pretty-fold").setup {
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
        border = "double",
    }
end

return settings
