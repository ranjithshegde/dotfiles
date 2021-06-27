local settings = {}
local u = require("utils")
local o = vim.o

function settings.settings()
    settings.vimwiki()
    settings.options()
    settings.treesitter()
    settings.ultisnips()
    settings.lsp_settings()
    settings.langServers()
    settings.lsp_lintFormat()
    settings.telescope()
    settings.completion()
end

------------------------------------------------------------------------
--                              Vim basics                            --
------------------------------------------------------------------------
function settings.options()
    Cmd "set nohlsearch"
    -- Cmd "colo zephyr"
    Cmd "colo lvim"
    -- o.background="light"
    -- Cmd "colo vscode"
    o.number = true
    o.relativenumber = true
    o.cursorline = true
    o.timeoutlen = 500
    o.signcolumn = "yes"
    o.hidden = true
    o.splitright = true
    o.splitbelow = true
    o.termguicolors = true
    o.updatetime = 300
    o.scrolloff = 10
    o.shiftwidth = 0
    o.tabstop = 4
    o.conceallevel = 1
    o.foldmethod = "expr"
    -- o.foldexpr = "nvim_treesitter#foldexpr()"
    o.fillchars = "stlnc:»,vert:║,fold:-"
    o.completeopt = "menuone,noinsert,noselect"
    o.clipboard = "unnamed,unnamedplus"
    o.shortmess = o.shortmess .. "c"
    G.termdebug_wide = 1
    G.markdown_folding = 1
end

------------------------------------------------------------------------
--                              VimWiki                               --
------------------------------------------------------------------------

function settings.vimwiki()
    local l = {}
    l.path = "$HOME/Documents/vimWiki"
    l.syntax = "markdown"
    l.ext = ".md"
    l.auto_toc = 0
    -- l.auto_diary_index = 1
    l.autowriteall = 1
    G.vimwiki_list = {l}
    G.vimwiki_markdown_link_ext = 1
    G.vimwiki_global_ext = 0
    G.vimwiki_auto_chdir = 1
    G.vimwiki_folding = "expr"
end
------------------------------------------------------------------------
--                              Snippets                              --
------------------------------------------------------------------------

function settings.ultisnips()
    local snippet_directories = {"UltiSnips", "scnvim-data"}
    Var("UltiSnipsExpandTrigger", "<tab>")
    Var("UltiSnipsJumpForwardTrigger", "<tab>")
    Var("UltiSnipsJumpBackwardTrigger", "<c-tab>")
    Var("UltiSnipsSnippetDirectories", snippet_directories)
end

------------------------------------------------------------------------
--                             Treesitter                             --
------------------------------------------------------------------------

function settings.treesitter()
    require "nvim-treesitter.configs".setup {
        highlight = {enable = true, languagetree = true, additional_vim_regex_highlighting = true},
        indent = {enable = true, disable = {"python"}},
        autopairs = {enable = true},
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = ";nn",
                node_incremental = ";rn",
                scope_incremental = ";rc",
                node_decremental = ";rm"
            }
        },
        textobjects = {
            select = {
                enable = true,
                disable = {"latex"},
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["ae"] = "@block.outer",
                    ["ie"] = "@block.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["is"] = "@statement.inner",
                    ["as"] = "@statement.outer",
                    ["ad"] = "@comment.outer",
                    ["am"] = "@call.outer",
                    ["im"] = "@call.inner",
                    ["iF"] = {
                        supercollider = "(function_definition) @function",
                        cpp = "(function_definition) @function",
                        c = "(function_definition) @function"
                    }
                }
            },
            move = {
                enable = true,
                set_jumps = false,
                goto_next_start = {
                    ["]n"] = "@function.outer",
                    ["]="] = "@class.outer",
                    ["]i"] = "@function.inner",
                    ["<Down>"] = "@block.outer",
                    ["<Right>"] = "@block.inner"
                },
                goto_next_end = {
                    ["]N"] = "@function.outer",
                    -- ["]="] = "@class.outer",
                    ["]I"] = "@function.inner"
                },
                goto_previous_start = {
                    ["[n"] = "@function.outer",
                    ["[="] = "@class.outer",
                    ["[i"] = "@function.inner",
                    ["<Up>"] = "@block.outer",
                    ["<Left>"] = "@block.inner"
                },
                goto_previous_end = {
                    ["[N"] = "@function.outer",
                    -- ["[="] = "@class.outer",
                    ["[I"] = "@function.inner"
                }
            },
            swap = {
                enable = true,
                swap_next = {
                    [";ss"] = "@statement.outer",
                    [";sp"] = "@parameter.inner",
                    [";sF"] = "@function.inner",
                    [";sf"] = "@function.outer",
                    [";sc"] = "@conditional.outer",
                    [";sl"] = "@loop.outer",
                    [";so"] = "@comment.outer",
                    [";sa"] = "@call.outer"
                },
                swap_previous = {
                    [";Ss"] = "@statement.outer",
                    [";Sp"] = "@parameter.inner",
                    [";SF"] = "@function.inner",
                    [";Sf"] = "@function.outer",
                    [";Sc"] = "@conditional.outer",
                    [";Sl"] = "@loop.outer",
                    [";So"] = "@comment.outer",
                    [";Sa"] = "@call.outer"
                }
            },
            lsp_interop = {
                enable = true,
                peek_definition_code = {[";pf"] = "@function.outer", [";pF"] = "@class.outer"}
            }
        },
        playground = {enable = true, disable = {}, updatetime = 25, persist_queries = false},
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"}
        },
        refactor = {
            highlight_definitions = {enable = true},
            highlight_current_scope = {enable = true},
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = ";d",
                    list_definitions = ";D",
                    list_definitions_toc = ";O",
                    goto_next_usage = ";*",
                    goto_previous_usage = ";#"
                }
            },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = ";r"
                }
            }
        },
        rainbow = {
            enable = true,
            extended_mode = true
        }
    }
end

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function settings.completion()
    require "completion".addCompletionSource("vimtex", u.complete_item)
    G.completion_chain_complete_list = {
        tex = {
            {complete_items = {"lsp", "snippet"}},
            {complete_items = {"vimtex", "snippet"}},
            {mode = "<c-p>"},
            {mode = "<c-n>"}
        },
        default = {
            {complete_items = {"UltiSnips", "lsp", "snippet", "path"}},
            {mode = "<c-p>"},
            {mode = "<c-n>"}
        }
    }
    G.completion_auto_change_source = 0

    if Op("filetype") == "supercollider" then
        G.completion_enable_snippet = "UltiSnips"
    else
        G.completion_enable_snippet = "vim-vsnip"
    end

    -- if Op("filetype") == "tex" then
    --     G.aerial = {
    --         filter_kind = false
    --     }
    -- end
    u.create_augroup(
        {
            {"FileType", "supercollider,text,conf", 'lua require"completion".on_attach()'},
            {"FileType", "tex,bib,supercollider,text,markdown", "let g:completion_auto_change_source=1"}
        },
        "completion_attach"
    )
end

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

function settings.lsp_settings()
    -- autopairs
    local npairs = require("nvim-autopairs")
    npairs.setup()

    local Rule = require("nvim-autopairs.rule")
    npairs.add_rules({Rule("|", "|", "supercollider")})

    require("icons").init()
    Lsp = require "lspconfig"

    -- Status bar for LSP
    Lsp_status = require("lsp-status")
    Lsp_status.register_progress()

    local buffCmd = "* <buffer>"
    local codeLens = {
        {
            "CursorHold, CursorHoldI, InsertLeave",
            "<buffer>",
            [[lua vim.lsp.codelens.refresh()]]
        }
    }
    local docHigh = {
        {"CursorHold", "<buffer>", [[lua vim.lsp.buf.document_highlight()]]},
        {"CursorMoved", "<buffer>", [[lua vim.lsp.buf.clear_references()]]},
        {"CursorMovedI", "<buffer>", [[lua vim.lsp.buf.clear_references()]]}
    }

	-- Set diagnostics to local list automatically
    u.create_augroup(
        {{"User LspDiagnosticsChanged", "lua vim.lsp.diagnostic.set_loclist({open_loclist = false})"}},
        "LspLocList"
    )

    All_attach = function(client, bufnr)
        require "completion".on_attach(client)
        Lsp_status.on_attach(client)
        local rc = client.resolved_capabilities
        vim.fn["vsnip#get_complete_items"](vim.fn["bufnr"]())

        if rc.document_highlight then
            Cmd("hi LspReferenceRead cterm=bold ctermbg=red guibg=#98971a")
            Cmd("hi LspReferenceText cterm=bold ctermbg=red guibg=grey")
            Cmd("hi LspReferenceWrite cterm=bold ctermbg=red guibg= #fbf1c7")
            u.create_cmdGroup(docHigh, buffCmd, "bufgroup")
        end

        if rc.document_formatting then
            u.create_augroup(
                {
                    {
                        "BufWritePre",
                        "*.js,*.jsx,*.hpp,*.sh",
                        "lua vim.lsp.buf.formatting_sync(nil, 1000)"
                    }
                },
                "lsp_auto_format"
            )
        end

        if client.resolved_capabilities.code_lens then
            u.create_cmdGroup(codeLens, buffCmd, "lensGroup")
        end
    end

    Capabilities = vim.lsp.protocol.make_client_capabilities()
    Capabilities.textDocument.completion.completionItem.snippetSupport = true
    Capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {"documentation", "detail", "additionalTextEdits"}
    }
    -- Capabilities = vim.tbl_extend('keep', Capabilities, Lsp_status.capabilities);

    Cinit = function(client)
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
        u.create_cmdGroup(codeLens, buffCmd, "lensGroup")
    end

    EfmInit = function(client)
        local rc = client.resolved_capabilities
        rc.document_formatting = false
    end

    -- borders for floating windows
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function settings.langServers()
    local configs = {
        cssls = {on_attach = All_attach},
        yamlls = {on_attach = All_attach},
        jsonls = {on_attach = All_attach},
        bashls = {on_attach = All_attach, filetypes = {"sh", "zsh"}},
        cmake = {on_attach = All_attach, capabilities = Capabilities},
        vimls = {on_attach = All_attach, capabilities = Capabilities},
        tsserver = {on_attach = All_attach, capabilities = Capabilities},
        pyright = {
            on_attach = All_attach,
            capabilities = Capabilities,
            root_dir = function()
                return vim.loop.cwd()
            end
        },
        texlab = {
            on_attach = All_attach,
            capabilities = Capabilities,
            settings = {texlab = {chktex = {onOpenAndSave = true}}}
        },
        ccls = {
            on_init = Cinit,
            handlers = {
                ["textDocument/publishDiagnostics"] = function(...)
                    return nil
                end,
                ["textDocument/signatureHelp"] = function(...)
                    return nil
                end
            },
            init_options = {cache = {directory = "/tmp/ccls"}}
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
                "--completion-style=detailed",
                "--cross-file-rename"
            }
        },
        sumneko_lua = {
            on_attach = All_attach,
            cmd = {"lua-language-server", "-E", "lua-language-server" .. "/main.lua"},
            settings = {
                Lua = {
                    runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
                    diagnostics = {globals = {"vim"}},
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                        }
                    }
                }
            }
        }
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
        cmd = {"diagnostic-languageserver", "--stdio"},
        filetypes = {"markdown", "tex", "text", "vimwiki"},
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {virtual_text = false}
            )
        },
        init_options = {
            linters = {
                ["write-good"] = {
                    command = "write-good",
                    debounce = 100,
                    args = {"--text=%text"},
                    offsetLine = 0,
                    offsetColumn = 1,
                    sourceName = "write-good",
                    formatLines = 1,
                    formatPattern = {
                        "(.*)\\s+on\\s+line\\s+(\\d+)\\s+at\\s+column\\s+(\\d+)\\s*$",
                        {line = 2, column = 3, message = 1}
                    }
                },
                languagetool = {
                    command = "languagetool",
                    debounce = 200,
                    args = {"--languagemodel", "/usr/share/Ngram", "%file"},
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "languagetool",
                    formatLines = 2,
                    formatPattern = {
                        "^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$",
                        {line = 1, column = 2, message = {4, 3}}
                    }
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
                        "--no-color"
                    },
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "textidote",
                    formatLines = 1,
                    formatPattern = {
                        '\\(L(\\d+)C(\\d+)-L(\\d+)C(\\d+)\\):(.+)".+"$',
                        {line = 1, column = 2, endLine = 3, endColumn = 4, message = 5}
                    }
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
                        "--no-color"
                    },
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "textidote",
                    formatLines = 1,
                    formatPattern = {
                        '\\(L(\\d+)C(\\d+)-L(\\d+)C(\\d+)\\):(.+)".+"$',
                        {line = 1, column = 2, endLine = 3, endColumn = 4, message = 5}
                    }
                }
            },
            formatters = {},
            filetypes = {
                markdown = "mdidote",
                vimwiki = "mdidote",
                tex = "textidote",
                text = {"languagetool", "write-good"}
            },
            formatFiletypes = {}
        }
    }

    local rootDir = function()
        return vim.fn.getcwd() or Lsp.util.root_pattern(".git/")
    end
    local rootMarker = {vim.fn.getcwd() or {".git/"}}

    -- local rootDir = vim.loop.cwd
    -- local rootMarker = {".git/"}

    local checkmake = {lintCommand = "checkmake", lintStdin = true}
    local yamllint = {lintCommand = "yamllint -f parsable -", lintStdin = true}
    local shfmt = {formatCommand = "shfmt -ci -s -bn", formatStdin = true}
    local rustywind = {formatCommand = "rustywind --stdin", formatStdin = true}
    local prettier = {formatCommand = "prettier --stdin --stdin-filepath ${INPUT}", formatStdin = true}
    local isort = {formatCommand = "isort --stdout --profile black -", formatStdin = true}
    local black = {formatCommand = "black --fast -", formatStdin = true}
    local mypy = {
        lintCommand = "mypy --show-column-numbers",
        -- lintCommand = "mypy --show-column-numbers --config-file=~/.config/mypy/config",
        lintFormats = {"%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"},
        lintSource = "mypy"
    }
    local flake8 = {
        lintCommand = "flake8 --max-line-length 160 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintIgnoreExitCode = true,
        lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
        lintSource = "flake8"
    }
    local shellcheck = {
        lintCommand = "shellcheck -f gcc -x -",
        lintStdin = true,
        lintFormats = {"%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"}
    }
    local markdownlint = {
        lintCommand = "markdownlint -s -c",
        lintStdin = true,
        lintFormats = {"%f:%l %m", "%f:%l:%c %m", "%f: %l: %m"}
    }
    local luaformat = {
        -- formatCommand = "lua-format -i ${--tab-width:tabSize} ${--indent-width:tabSize} --spaces-inside-table-braces --single-quote-to-double-quote",
        -- formatCommand = "lua-format -i --keep-simple-function-one-line --break-after-operator --no-keep-simple-control-block-one-line --column-limit=100",
        formatCommand = "luafmt ${-i:tabWidth} --stdin",
        formatStdin = true
    }
    local vint = {
        lintCommand = "vint --enable-neovim",
        lintStdin = false,
        lintFormats = {"%f:%l:%c: %m"}
    }

    local languages = {
        vim = {vint},
        yaml = {yamllint},
        json = {prettier},
        toml = {prettier},
        lua = {luaformat},
        make = {checkmake},
        rust = {rustywind},
        vimwiki = {markdownlint, prettier},
        markdown = {markdownlint, prettier},
        sh = {shellcheck, shfmt},
        zsh = {shellcheck, shfmt},
        python = {flake8, isort, black, mypy}
    }
    Lsp.efm.setup(
        {
            filetypes = vim.tbl_keys(languages),
            root_dir = rootDir,
            on_attach = All_attach,
            handlers = {
                ["textDocument/publishDiagnostics"] = vim.lsp.with(
                    vim.lsp.diagnostic.on_publish_diagnostics,
                    {virtual_text = false}
                )
            },
            init_options = {documentFormatting = true, codeAction = true},
            settings = {rootMarkers = rootMarker, languages = languages}
        }
    )
end

------------------------------------------------------------------------
--                         Telescope	                              --
------------------------------------------------------------------------

function settings.telescope()
    require("telescope").setup {}
    require "telescope".load_extension("project")
end

------------------------------------------------------------------------
--                         uncalled 	                              --
------------------------------------------------------------------------

function settings.jdtls()
    require("jdtls").start_or_attach(
        {
            on_attach = All_attach,
            capabilities = Capabilities,
            cmd = {"jdlsp"}
        }
    )
    require("jdtls.setup").add_commands()
end

function settings.smbc()
    local commands = {
        "PioCompiledb lua require('compiler').compiletags()",
        "PioMonitor lua require('compiler').monitor()",
        "PioCheck lua require('compiler').pio_check()",
        "PioEnv lua require('compiler').print_env()",
        "PioClean lua require('compiler').pio_clean()",
        "TeensyPinout lua require('compiler').teensypins()",
        "TeensySpecs lua require('compiler').teensyspecs()",
        "ArduinoRef lua require('compiler').arduinoref()"
    }
    for index = 1, #commands do
        vim.cmd("command! " .. commands[index])
    end
end

return settings
