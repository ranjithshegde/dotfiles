local settings = {}
local u = require('utils')
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
    -- Cmd 'colo nvcode'
    Cmd 'colo zephyr'
    -- Cmd 'colo snazzy'
    Cmd 'set nohlsearch'
    Cmd 'hi Normal guibg=none'
    -- Cmd 'hi LineNr ctermbg=none guibg=none'

    u.opt('w', 'number', true)
    u.opt('w', 'relativenumber', true)
    u.opt('w', 'cursorline', true)
    u.opt('o', 'hidden', true)
    u.opt('o', 'splitright', true)
    u.opt('o', 'splitbelow', true)
    u.opt('o', 'shiftround', true)
    u.opt('o', 'termguicolors', true)
    u.opt('o', 'signcolumn', 'true')
    u.opt('o', 'updatetime', 300)
    u.opt('o', 'scrolloff', 10)
    -- u.opt('b', 'shiftwidth', 2)
    u.opt('o', 'clipboard', [[unnamed,unnamedplus]])
    u.opt('o', 'completeopt', [[menuone,noinsert,noselect]])
    u.opt('o', 'fillchars', "stlnc:»,vert:║,fold:·")
    u.opt('o', 'foldmethod', 'expr')
    u.opt('o', 'foldexpr', 'nvim_treesitter#foldexpr()')
    -- u.opt('o', 'timeoutlen', 250)
    -- u.opt('o', 'guicursor', "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25")
    o.shortmess = o.shortmess .. "c"
    G.termdebug_wide = 1

    -- if Op("filetype") == "tex" then
    --     u.opt('o', 'foldexpr', 'vimtex#fold#level(v:lnum)')
    --     u.opt('o', 'foldtext', 'vimtex#fold#text()')
    -- else
    --     u.opt('o', 'foldexpr', 'nvim_treesitter#foldexpr()')
    -- end
end

------------------------------------------------------------------------
--                              VimWiki                               --
------------------------------------------------------------------------

function settings.vimwiki()
    local l = {}
    -- l.path = '$HOME/Documents/vimWiki'
    l.path = '$HOME/Nextcloud/Documents/vimWiki'
    l.syntax = 'markdown'
    l.ext = '.md'
    l.auto_tags = 1
    l.auto_diary_index = 1
    l.auto_generate_tags = 1
    l.autowriteall = 1
    -- Cmd("let g:vimwiki_ext2syntax = {'.md':'markdown', '.markdown':'markdown','.mdown':'markdown'}")
    G.vimwiki_filetypes = {'markdown'}
    G.vimwiki_list = {l}
    G.vimwiki_markdown_link_ext = 1

end
------------------------------------------------------------------------
--                              Snippets                              --
------------------------------------------------------------------------

function settings.ultisnips()
    local snippet_directories = {"UltiSnips", "scnvim-data"}
    Var('UltiSnipsExpandTrigger', "<tab>")
    Var('UltiSnipsJumpForwardTrigger', "<tab>")
    Var('UltiSnipsJumpBackwardTrigger', "<c-tab>")
    Var('UltiSnipsSnippetDirectories', snippet_directories)
end

------------------------------------------------------------------------
--                             Treesitter                             --
------------------------------------------------------------------------

function settings.treesitter()

    require'nvim-treesitter.configs'.setup {
        highlight = {enable = true, use_languagetree = true},
        indent = {enable = true},
        -- autopairs = {enable = true},
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
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                    ['ac'] = '@conditional.outer',
                    ['ic'] = '@conditional.inner',
                    ['ae'] = '@block.outer',
                    ['ie'] = '@block.inner',
                    ['al'] = '@loop.outer',
                    ['il'] = '@loop.inner',
                    ['is'] = '@statement.inner',
                    ['as'] = '@statement.outer',
                    ['ad'] = '@comment.outer',
                    ['am'] = '@call.outer',
                    ['im'] = '@call.inner',
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
                    ["]="] = "@class.outer",
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
                    ["[="] = "@class.outer",
                    ["[I"] = "@function.inner"
                }
            },
            swap = {
                enable = true,
                -- disable = {"cpp"},
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
        rainbow = {enable = true},
        extended_mode = true,
        refactor = {
            highlight_definitions = {enable = false},
            highlight_current_scope = {enable = false},
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = ";d",
                    list_definitions = ";D",
                    list_definitions_toc = ";O",
                    goto_next_usage = ";*",
                    goto_previous_usage = ";#"
                }
            }
        }
    }
end

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function settings.completion()

    require'completion'.addCompletionSource('vimtex', u.complete_item)

    G.completion_chain_complete_list = {
        tex = {
            {complete_items = {'lsp', 'snippet'}}, {complete_items = {'vimtex', 'snippet'}},
            {mode = '<c-p>'}, {mode = '<c-n>'}, {mode = 'thes'}
        },
        default = {
            {complete_items = {'UltiSnips', 'lsp', 'snippet', 'path'}}, {mode = '<c-p>'},
            {mode = '<c-n>'}, {mode = 'thes'}
        }
    }
    G.completion_enable_auto_signature = 1
    G.completion_auto_change_source = 0

    if Op("filetype") == "supercollider" then
        G.completion_enable_snippet = 'UltiSnips'
    else
        G.completion_enable_snippet = 'vim-vsnip'
    end
    u.create_augroup({
        {'BufEnter', '*', 'lua require"completion".on_attach()'},
        {'BufEnter', '*.txt,*.md,*.scd', ':let g:completion_auto_change_source=1'}
    }, 'completion_attach')
end

------------------------------------------------------------------------
--                             Lsp settings                           --
------------------------------------------------------------------------

function settings.lsp_settings()

    -- autopairs
    local npairs = require('nvim-autopairs')
    npairs.setup()
    -- npairs.setup({check_ts = true})
    -- local ts_conds = require('nvim-autopairs.ts-conds')

    local Rule = require('nvim-autopairs.rule')
    npairs.add_rules({
        Rule("|", "|", "supercollider")
        -- :with_pair(ts_conds)
    })

    -- OnEnter = function() return require("nvim-autopairs").check_break_line_char() end
    -- vim.api.nvim_set_keymap("i", "<CR>", "v:lua.OnEnter()", {expr = true})

    require('icons').init()
    Lsp = require 'lspconfig'

    -- Status bar for LSP
    Lsp_status = require('lsp-status')
    Lsp_status.register_progress()

    local signHover = {
        {"CursorHoldI", "<buffer>", [[lua vim.lsp.buf.signature_help()]]},
        {"CursorMoved", "<buffer>", [[lua vim.lsp.buf.clear_references()]]}
    }

    local docHigh = {
        {"CursorHold", "<buffer>", [[lua vim.lsp.buf.document_highlight()]]},
        {"CursorMoved", "<buffer>", [[lua vim.lsp.buf.clear_references()]]},
        {"CursorMovedI", "<buffer>", [[lua vim.lsp.buf.clear_references()]]}
    }
    All_attach = function(client, bufnr)
        require'completion'.on_attach(client)
        Lsp_status.on_attach(client)
        -- require('folding').on_attach()
        local rc = client.resolved_capabilities

        if rc.document_highlight then
            Cmd('hi LspReferenceRead cterm=bold ctermbg=red guibg=#98971a')
            Cmd('hi LspReferenceText cterm=bold ctermbg=red guibg=grey')
            Cmd('hi LspReferenceWrite cterm=bold ctermbg=red guibg= #fbf1c7')
            u.create_bufgroup(docHigh, 'bufgroup')
        end

        if rc.document_formatting then
            u.create_augroup({
                {
                    'BufWritePre', '*.js,*.jsx,*.py,*.c,*.h,*.hpp,*.sh',
                    'lua vim.lsp.buf.formatting_sync(nil, 1000)'
                }
            }, 'lsp_auto_format')
        end

        if rc.signatureHelpProvider then
            u.create_bufgroup(signHover, 'bufgroup')
        end

    end

    Capabilities = vim.lsp.protocol.make_client_capabilities()
    Capabilities.textDocument.completion.completionItem.snippetSupport = true;
    -- Capabilities = vim.tbl_extend('keep', Capabilities, Lsp_status.capabilities);

    Cinit = function(client)
        local rc = client.resolved_capabilities
        rc.document_formatting = false
        rc.document_highlight = false
        rc.rename = false
        rc.hover = false
        rc.signature_help = false
        rc.completion = false
    end
    EfmInit = function(client)
        local rc = client.resolved_capabilities
        rc.document_formatting = false
    end

    -- local myBorder = {"╔", "═", "╗", "║", "╝", "═", "╚", "║"}

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- border = "{ '╔', '═' ,'╗', '║','╝', '═', '╚', '║' }"
        border = "double"
    })

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {border = "double"})
end

------------------------------------------------------------------------
--                         Language servers                           --
------------------------------------------------------------------------

function settings.langServers()

    local configs = {
        vimls = {on_attach = All_attach},
        bashls = {on_attach = All_attach, filetypes = {"sh", "zsh"}},
        texlab = {on_attach = All_attach},
        cssls = {on_attach = All_attach},
        yamlls = {on_attach = All_attach},
        jsonls = {on_attach = All_attach},
        pyright = {on_attach = All_attach},
        cmake = {on_attach = All_attach},
        tsserver = {on_attach = All_attach},
        clangd = {
            -- init_options = {clangdFileStatus = true},
            handlers = Lsp_status.extensions.clangd.setup(),
            on_attach = All_attach,
            capabilities = Capabilities,
            cmd = {
                "clangd", "--clang-tidy", "--background-index", "--all-scopes-completion",
                "--completion-style=detailed", "--cross-file-rename"
            },
            commands = {CHover = {function() u.clang_hover() end}}
        },
        ccls = {
            on_init = Cinit,
            handlers = {["textDocument/publishDiagnostics"] = function(...) return nil end},
            init_options = {
                cache = {directory = "/tmp/ccls"}
                -- cache = {directory = "/home/ranjith/.cache/ccls"}
                -- client = {snippetSupport = true}
            }
        },
        sumneko_lua = {
            on_attach = All_attach,
            capabilities = Capabilities,
            cmd = {
                -- "/usr/bin/lua-language-server", "-E", "/usr/bin/lua-language-server" .. "/main.lua"},
                "lua-language-server", "-E", "lua-language-server" .. "/main.lua"
            },
            settings = {
                Lua = {
                    runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
                    diagnostics = {globals = {'vim'}},
                    workspace = {
                        library = {
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
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
        filetypes = {"markdown", "tex", "text"},
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
                    args = {"%file"},
                    -- args = {"-"},
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "languagetool",
                    formatLines = 2,
                    formatPattern = {
                        "^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$",
                        {line = 1, column = 2, message = {4, 3}}
                    }
                }
            },
            formatters = {},
            filetypes = {
                markdown = {"langugetool", "write-good"},
                vimwiki = {"write-good", "languagetool"},
                tex = {"langugetool", "write-good"},
                text = {"languagetool", "write-good"}
            },
            formatFiletypes = {}
        }
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

    local shfmt = {formatCommand = "shfmt -ci -s -bn", formatStdin = true}

    local luaformat = {
        -- formatCommand = "lua-format -i ${--tab-width:tabSize} ${--indent-width:tabSize} --spaces-inside-table-braces --single-quote-to-double-quote",
        formatCommand = "lua-format -i --keep-simple-function-one-line --break-after-operator --no-keep-simple-control-block-one-line --column-limit=100",
        formatStdin = true
    }
    local prettier = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}
    local vint = {
        lintCommand = "vint --enable-neovim",
        lintStdin = false,
        lintFormats = {"%f:%l:%c: %m"}
    }

    local checkmake = {lintCommand = "checkmake", lintStdin = true}
    local yamllint = {lintCommand = "yamllint -f parsable -", lintStdin = true}
    local flake8 = {
        lintCommand = "flake8 --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintFormats = {"%f:%l:%c: %m"}
    }
    local phpstan = {lintCommand = "./vendor/bin/phpstan analyze --error-format raw --no-progress"}
    local rustywind = {formatCommand = "rustywind --stdin", formatStdin = true}

    local rootDir = function() return vim.fn.getcwd() or Lsp.util.root_pattern('.git/') end
    local rootMarker = {vim.fn.getcwd() or {".git/"}}

    local languages = {
        lua = {luaformat},
        sh = {shellcheck, shfmt},
        zsh = {shellcheck, shfmt},
        vim = {vint},
        php = {phpstan},
        python = {flake8},
        yaml = {yamllint},
        make = {checkmake},
        rust = {rustywind},
        json = {prettier},
        toml = {prettier},
        markdown = {markdownlint},
        vimwiki = {markdownlint}
    }

    Lsp.efm.setup({
        filetypes = vim.tbl_keys(languages),
        root_dir = rootDir,
        on_attach = All_attach,
        init_options = {
            documentFormatting = true,
            codeAction = true,
            documentSymbol = true,
            hover = true
        },
        settings = {rootMarkers = rootMarker, languages = languages}
    })

end

------------------------------------------------------------------------
--                         Telescope	                              --
------------------------------------------------------------------------

function settings.telescope()
    require('telescope').setup {}
    require'telescope'.load_extension('project')

    local borders = {
        {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
        prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
        results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
        preview = {'─', '│', '─', '│', '┌', '┐', '┘', '└'}
    }
    No_preview = function()
        return require('telescope.themes').get_dropdown(
                   {borderchars = borders, width = 0.5, previewer = false, prompt_title = false})
    end
end
return settings
