local mappings = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              General functions                     --
------------------------------------------------------------------------

function mappings.general()
    mappings.configFiles()
    mappings.orgWiki()
    mappings.telescope()
    mappings.treesitter()
    mappings.coauthor()

    local opts = { nowait = true }
    map("n", ",", "<C-,>")
    map("n", ";", "<C-;>")
    --line movement
    map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up" })
    map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down" })
    -- visual cut for replase
    map({ "v", "s" }, "<leader>p", '"_dP', opts)
    -- Indent
    map("v", "<", "<gv", opts)
    map("v", ">", ">gv", opts)
    -- Terminal
    map({ "n", "t" }, "<F9>", function()
        vim.cmd "stopinsert"
        require("utils").toggleTerm("zsh", "shell", 1)
    end, {
        desc = "Toggle current/default terminal",
    })
    --Quickfix
    map("n", "-", function()
        require("utils.qf").toggle_qf "q"
    end, { desc = "Toggle quickfix" })
    map("n", "_", function()
        require("utils.qf").toggle_qf "l"
    end, { desc = "Toggle loclist" })
    -- Toggle folds
    map("n", "<Tab>", "za", { desc = "Toggle fold current" })
    map("n", "<S-Tab>", "zA", { desc = "Toggle fold All" })
    -- open folds when searching
    map("n", "n", "nzzzv", { desc = "jump to next search result" })
    map("n", "N", "Nzzzv", { desc = "jump to previous search result" })
    map("n", "J", "mzJ`z", { desc = "Adjoin next line" })
    map(
        "n",
        "gm",
        "cursor(0,{desc =  virtcol('$')/2 )",
        { desc = "Move cursor to middle of the line", expr = true, buffer = true }
    )
    map("n", "<leader><Tab>", "<cmd>SidebarNvimToggle<CR>", { desc = "Toggle Symbolsbar" })

    -- Terminals
    wk.register {
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { "<cmd>sp term://zsh<cr>", "Horizontal" },
            v = { "<cmd>vspl term://zsh<cr>", "Vertical" },
            t = { "<cmd>tab drop term://zsh<cr>", "New tab" },
        },
    }
end

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

function mappings.ranger()
    wk.register {
        ["<leader>r"] = {
            name = "Ranger file picker",
        },
    }
    map("n", "<leader>rr", function()
        vim.fn["util#ranger"]("%:p:h", "e ")
    end, { desc = "from current file" })
    map("n", "<leader>rR", function()
        vim.fn["util#ranger"](".", "e ")
    end, { desc = "from current directory" })
    map("n", "<leader>rv", function()
        vim.cmd "vnew"
        vim.fn["util#ranger"]("%:p:h", "vs ")
    end, { desc = "in a split from current file" })
    map("n", "<leader>rV", function()
        vim.cmd "vnew"
        vim.fn["util#ranger"](".", "vs ")
    end, { desc = "in a split from current directory" })
    map("n", "<leader>rt", function()
        vim.cmd "tabnew"
        vim.fn["util#ranger"]("%:p:h", "tab drop ")
    end, { desc = "in a new tab from current file" })
    map("n", "<leader>rT", function()
        vim.cmd "tabnew"
        vim.fn["util#ranger"](".", "tab drop ")
    end, { desc = "in a new tab from current directory" })
end

function mappings.wordProcessor()
    map("n", "<leader><Space>", '<cmd>g/^/pu ="\n"<CR>', { desc = "Double space entire file" })
    map("n", ",K", function()
        require("utils").dictionary(vim.fn.expand "<cword>")
    end, { desc = "Lookup Wikitionary" })
    map("n", ",T", function()
        require("utils").thesaurus(vim.fn.expand "<cword>")
    end, { desc = "Lookup Synonyms" })
end

-- ******************************** orgWiki -----------------------
function mappings.orgWiki()
    wk.register {
        ["<leader>w"] = {
            name = "orgWiki",
            w = {
                function()
                    require("org").openIndex()
                end,
                "Open Index",
            },
            t = {
                function()
                    require("org").openIndex "tab drop"
                end,
                "Open Index in a new tab",
            },
            d = {
                function()
                    require("org").deleteLink()
                end,
                "Delete link under cursor",
            },
            i = {
                function()
                    require("org.diary").diaryIndexOpen()
                end,
                "Open Diary index",
            },
            ["<leader>"] = {
                name = "Diary entries",
                w = {
                    function()
                        require("org.diary").diaryTodayOpen()
                    end,
                    "Today",
                },
                t = {
                    function()
                        require("org.diary").diaryTodayOpen "tab drop"
                    end,
                    "Today in a new tab",
                },
                i = {
                    function()
                        require("org.diary").diaryGenerateIndex()
                    end,
                    "Reindex",
                },
                y = {
                    function()
                        require("org.diary").diaryYesterdayOpen()
                    end,
                    "Yesterday",
                },
                m = {
                    function()
                        require("org.diary").diaryTomorrowOpen()
                    end,
                    "Tomorrow",
                },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Language servers                      --
------------------------------------------------------------------------

function mappings.nvim_lsp()
    wk.register({
        K = { vim.lsp.buf.hover, "Hover" },
        ["<F7>"] = { require("debugger").init, "Initialize Debugger adapter" },
        [","] = {
            name = "Lsp functions",
            D = { vim.lsp.buf.declaration, "Jump to Declaration" },
            d = { vim.lsp.buf.definition, "Jump to Definition" },
            i = { vim.lsp.buf.implementation, "Jump to Implementation" },
            t = { vim.lsp.buf.type_definition, "Jump to Type definition" },
            s = { vim.lsp.buf.signature_help, "Show signature" },
            R = { vim.lsp.buf.rename, "Rename symbol" },
            f = { vim.lsp.buf.formatting, "Format buffer" },
            a = { vim.lsp.buf.code_action, "Code actions for buffer" },
            r = {
                function()
                    vim.lsp.buf.references { includeDeclaration = false }
                end,
                "References",
            },
            c = {
                name = "Codelens",
                c = { vim.lsp.codelens.display, "Display" },
                r = { vim.lsp.codelens.run, "Run" },
                R = { vim.lsp.codelens.refresh, "Refresh" },
                g = { vim.lsp.codelens.get, "Fetch" },
            },
            l = {
                name = "Toggle diagnostics",
                v = { require("utils.diagnostics").toggle_virtual_text, "Virtual text" },
                s = { require("utils.diagnostics").toggle_signs, "Sings" },
                u = { require("utils.diagnostics").toggle_underline, "Underline" },
            },
            w = {
                name = "Workspace",
                a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
                r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
                l = {
                    function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end,
                    "List workspace folder",
                },
            },
        },
    }, { buffer = 0 })

    wk.register({
        [","] = {
            name = "Lsp visual mode",
            a = { vim.lsp.buf.range_code_action, "Code actions for range" },
            f = { vim.lsp.buf.range_formatting, "Format range" },
        },
    }, { mode = "v", buffer = 0 })
    map("n", "<F11>", "<cmd>SymbolsOutline<CR>", { desc = "Toggle Symbolsbar" })
end

-- ******************************** Diagnostics------------------------

function mappings.diagnostic()
    map("n", ",ld", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "Show previous diagnostics" })
    map("n", "]d", vim.diagnostic.goto_next, { desc = "Show next diagnostics" })
end

------------------------------------------------------------------------
--                              Vim config files                      --
------------------------------------------------------------------------

function mappings.configFiles()
    local open = function(path)
        return string.format("<cmd>tab drop ~/.config/nvim/%s<CR>", path)
    end
    wk.register {
        ["<leader>"] = {
            a = {
                name = "vimrc files",
                p = { open "lua/plugins.lua", "Packer config" },
                m = { open "lua/mappings.lua", "Keymaps" },
                g = {
                    name = "Org plugin",
                    o = { open "lua/org/init.lua", "Index plugin" },
                    d = { open "lua/org/diary.lua", "Diary plugin" },
                },
                o = {
                    name = "Options",
                    o = { open "lua/settings/init.lua", "vim" },
                    t = { open "lua/settings/telescope.lua", "Telescope" },
                    s = { open "lua/settings/treesitter.lua", "Treesitter" },
                    c = { open "lua/settings/completion.lua", "Completion" },
                },
                l = {
                    name = "Lsp",
                    s = { open "lua/lsp/init.lua", "Functions and Inits" },
                    l = { open "lua/lsp/sumneko.lua", "Sumneko" },
                    j = { open "lua/lsp/jdtls.lua", "Jdt LS" },
                    c = { open "lua/lsp/clangd.lua", "Clangd" },
                },
                u = {
                    name = "Utilities in lua",
                    u = { open "lua/utils/init.lua", "General" },
                    c = { open "lua/utils/compiler.lua", "Cpp Workstation" },
                    d = { open "lua/utils/diagnostics.lua", "Diagnostic extensions" },
                    l = { open "lua/utils/langServers.lua", "Langauge Server extensions" },
                    q = { open "lua/utils/qf.lua", "Quickfix and Loclist" },
                },
                f = {
                    name = "Filetype Plugins",
                    c = { open "after/ftplugin/cpp.lua", "Cpp" },
                    g = { open "after/ftplugin/glsl.lua", "Glsl" },
                    j = { open "after/ftplugin/javascript.lua", "JavaScript" },
                    l = { open "after/ftplugin/lua.lua", "Lua" },
                    o = { open "after/ftplugin/org.lua", "Orgmode" },
                    t = { open "after/ftplugin/tex.lua", "Latex" },
                },
                q = {
                    name = "Treesitter queries",
                    m = { open "after/queries/markdown/highlights.scm", "Markdown" },
                    o = { open "after/queries/org/highlights.scm", "Org" },
                },
                d = { open "lua/debugger.lua", "Debug adapter protocol" },
                s = { open "lua/statusline.lua", "Statusline and Tabline" },
                a = { open "autoload/util.vim", "Utilities in autoload" },
                c = { open "after/plugin/plugins.lua", "User defined commands" },
                r = { open "init.lua", "VimRC" },
                P = { require("packer").sync, "Update packages" },
                R = { require("utils").Restart, "Reload Vim" },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Treesitter                            --
------------------------------------------------------------------------

function mappings.treesitter()
    wk.register {
        [";"] = {
            name = "Syntax tree functions",
            -- Plugins
            J = {
                function()
                    require("trevj").format_at_cursor()
                end,
                "Reverse J",
            },
            K = { "<cmd>TSNodeUnderCursor<cr>", "Show treesitter node" },
            P = { "<cmd>TSPlaygroundToggle<cr>", "Toggle playground" },
            --Refactor
            d = "Jump to node definition",
            f = { "gg=G<C-o>zz", "indent" },
            l = {
                name = "List functions/symbols",
                l = "local",
                g = "Global",
            },
            r = "rename",
            ["*"] = "jump to node's next usage",
            ["#"] = "jump to node's previous usage",
            -- TextObjects
            p = {
                name = "Peek function defintion",
                f = "for function",
                c = "for class",
            },
            g = {
                name = "incremental selection",
                n = "Start selection at node",
            },
        },
        cx = {
            name = "Swap forwards",
            a = {
                name = "outer",
                s = "statement",
                o = "comment",
                a = "call",
                f = "function",
                p = "Paramater",
                c = "conditional",
                l = "loop",
                v = "variable",
            },
            i = {
                name = "inner",
                a = "call",
                f = "function",
                p = "Paramater",
                c = "conditional",
                l = "loop",
                v = "variable",
            },
        },
        cX = {
            name = "Swap backwards",
            a = {
                name = "outer",
                s = "statement",
                o = "comment",
                a = "call",
                f = "function",
                p = "Paramater",
                c = "conditional",
                l = "loop",
                v = "variable",
            },
            i = {
                name = "inner",
                a = "call",
                f = "function",
                p = "Paramater",
                c = "conditional",
                l = "loop",
                v = "variable",
            },
        },
        -- Motions
        ["]"] = {
            n = "Move to next outer function start",
            i = "Move to next inner function start",
            ["="] = "Move to next outer class start",
            N = "Move to next function outer end",
            I = "Move to next function inner end",
        },
        ["<Down>"] = "Move to next outer code block start",
        ["<Right>"] = "Move to next inner code block start",
        ["["] = {
            n = "Move to previous outer function start",
            i = "Move to previous inner function start",
            ["="] = "Move to previous outer class start",
            N = "Move to previous function outer end",
            I = "Move to previous function inner end",
        },

        ["<Up>"] = "Move to previous outer code block start",
        ["<Left>"] = "Move to previous inner code block start",
    }
    wk.register({
        [";"] = {
            name = "Syntax tree",
            g = {
                name = "incremental selection",
                i = "Increment nodes",
                s = "Increment Scope",
                r = "Decrememnt nodes",
            },
        },
    }, { mode = "v" })
end

------------------------------------------------------------------------
--                              Telescope                             --
------------------------------------------------------------------------

function mappings.telescope()
    local cd_files = require("settings.telescope").cdFiles
    local cd_browser = require("settings.telescope").cdBrowser

    local tele = function(name)
        return function()
            require("telescope.builtin")[name]()
        end
    end

    local telargs = function(name, args)
        return function()
            require("telescope.builtin")[name](args)
        end
    end

    wk.register {
        ["<Space>"] = {
            name = "Telescope",
            b = { tele "buffers", "Buffers" },
            c = { tele "commands", "Vim commands" },
            C = { tele "command_history", "Command history" },
            l = { tele "loclist", "local quickfix list" },
            m = { tele "symbols", "Unicode characters" },
            o = { cd_files("Org files", "~/Documents/Orgs"), "Org files" },
            q = { tele "quickfix", "Quickfix list" },
            r = { tele "lsp_references", "Lsp References" },
            s = { tele "lsp_document_symbols", "Lsp symbols in buffer" },
            S = { tele "lsp_dynamic_workspace_symbols", "Grep lsp workspace symbols" },
            t = { tele "tagstack", "Lsp Ctags" },
            T = { tele "treesitter", "TreeSitter nodes in buffer" },
            z = { tele "current_buffer_fuzzy_find", "Fuzzy find in buffer" },
            ["'"] = { tele "marks", "Marks" },
            ['"'] = { tele "registers", "Registers" },
            ["/"] = { tele "grep_string", "Grep CWORD in directory" },
            ["]"] = { tele "tags", "Lsp Ctags" },
            ["<Space>"] = { tele "builtin", "Builtin Searchers" },
            k = {
                function()
                    require("telescope.builtin").lsp_workspace_symbols { query = vim.fn.expand "<cword>" }
                end,
                "Search lsp workspace symbol",
            },
            p = {
                function()
                    require("telescope").extensions.project.project { display_type = "full" }
                end,
                "Projects",
            },
            e = {
                function()
                    require("telescope").extensions.file_browser.file_browser { files = false }
                end,
                "Folder browser",
            },
            E = {
                function()
                    require("telescope").extensions.file_browser.file_browser()
                end,
                "File browser",
            },
            d = {
                name = "diagnostics",
                b = { tele "diagnostics", "buffer diagnostics" },
                w = { tele "diagnostics", "Workspace diagnostics" },
            },
            G = {
                name = "git commands",
                b = { tele "git_branches", "Branches" },
                c = { tele "git_commits", "Commit history" },
                s = { tele "git_status", "Status" },
                f = { tele "git_files", "Tracked files" },
            },
            g = {
                name = "Live grep in",
                g = { tele "live_grep", "current directory" },
                s = {
                    telargs(
                        "live_grep",
                        { cwd = "~/Documents/Supercollider/", prompt_title = "SuperCollider Workspace grep" }
                    ),
                    "grep SuperCollider",
                },
                o = {
                    telargs("live_grep", { cwd = "~/Documents/ofWorkspace/", prompt_title = "oF Workspace grep" }),
                    "ofWorkspace",
                },
                d = {
                    telargs("live_grep", { cwd = "~/.config", prompt_title = "Dotfiles grep" }),
                    "grep dotfiles",
                },
                ["?"] = {
                    function()
                        require("telescope.builtin").live_grep {
                            cwd = vim.fn.input { prompt = "Enter directory: ", completion = "dir" },
                        }
                    end,
                    "Choose directory",
                },
            },
            F = { tele "find_files", "Current directory" },
            f = {
                name = "find files in",
                f = { tele "find_files", "Current directory" },
                h = { telargs("find_files", { cwd = "~" }), "Home directory" },
                r = { tele "oldfiles", "Vim recent files" },
                t = { tele "help_tags", "vim help files" },
                C = { cd_files("C++ Practice files/dirs", "$CWORK/Scratch"), "Open C practice" },
                c = { cd_browser("C++ Practice files/dirs", "$CWORK/Scratch"), "Open C practice" },
                s = { cd_files("SuperCollider Directory", "~/Documents/Supercollider/"), "SuperCollider files" },
                b = {
                    telargs("find_files", { cwd = "~/.local/bin/", prompt_title = "Scripts and binaries in local" }),
                    "scripts & binaries",
                },
                d = {
                    telargs(
                        "find_files",
                        { cwd = "~/.config/", find_command = { "fd", "--hidden" }, prompt_title = "Dotfiles" }
                    ),
                    "Dotfiles",
                },
                V = { cd_browser("Vim plugins", "~/.local/share/nvim/site/pack/packer/"), "Vim plugin Directory" },
                v = {
                    telargs(
                        "find_files",
                        { cwd = "~/.local/share/nvim/site/pack/packer", prompt_title = "Plugin files" }
                    ),
                    "Vim plugin Directory",
                },
                o = {
                    telargs("find_files", { cwd = "~/Documents/ofWorkspace/", prompt_title = "oF Workspace files" }),
                    "OfWorkspace",
                },
                ["?"] = {
                    function()
                        require("telescope.builtin").find_files {
                            cwd = vim.fn.input { prompt = "Enter directory: ", completion = "dir" },
                        }
                    end,
                    "Choose directory",
                },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

function mappings.git()
    wk.register {
        ["<leader>g"] = {
            name = "git functions",
            g = { "<cmd>G<cr>", "Git window" },
            c = { "<cmd>G commit<cr>", "commit changes" },
            C = { "<cmd>G commit %<cr>", "commit current buffer" },
            a = { "<cmd>G add %<cr>", "add current buffer" },
            d = { "<cmd>G difftool<cr>", "launch difftool" },
            b = { "<cmd>G blame<cr>", "toggle blame" },
            p = { "<cmd>G push<cr>", "push commits" },
            s = { "<cmd>Gitsigns stage_hunk<cr>", "stage hunk under cursor" },
            P = { "<cmd>G push -f<cr>", "force push commits" },
            l = { "<cmd>G log<cr>", "commit history" },
            L = { "<cmd>Gclog<cr>", "commit CLog" },
            h = { "<cmd>Gitsigns toggle_linehl<cr> <cmd>Gitsigns toggle_word_diff<cr>", "Toggle buffer highlights" },
        },
        ["]h"] = { "<cmd>Gitsigns next_hunk<cr>:Gitsigns preview_hunk<CR>", "Preview previous hunk" },
        ["[h"] = { "<cmd>Gitsigns prev_hunk<cr>:Gitsigns preview_hunk<CR>", "Preview next hunk" },
    }
end

------------------------------------------------------------------------
--                              SuperCollider                         --
------------------------------------------------------------------------

function mappings.scnvim()
    map("n", "<F1>", require("scnvim").start, { buffer = true, desc = "Launch Sclang" })
    map("n", "<F2>", "<cmd>SCNvimStatusLine<cr>", { buffer = true, desc = "Display server status" })
    map(
        "n",
        "<F3>",
        'scnvim#sclang#send_silent("Server.local.boot")',
        { buffer = true, desc = "Boot local server", expr = true }
    )
    map(
        "n",
        "<F4>",
        'scnvim#sclang#send_silent("WFSLib.startup")',
        { buffer = true, desc = "Boot WFS server", expr = true }
    )
    map("n", "<F5>", "<Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("i", "<F5>", "<esc><Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("v", "<F5>", "<Plug>(scnvim-send-selection)", { buffer = true, desc = "Evaluate SC visual block" })
    map("n", "<F6>", "<Plug>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("i", "<F6>", "<Plug><esc>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("n", ",s", function()
        require("scnvim.completion.signature").show { border = "rounded" }
    end, { buffer = true, desc = "SC signature help" })
    map(
        "n",
        "<leader>s",
        "<cmd>tabnew ~/.config/SuperCollider/startup.scd<cr>",
        { buffer = true, desc = "open startup file" }
    )
end

------------------------------------------------------------------------
--                              Arduino                               --
------------------------------------------------------------------------

function mappings.micro()
    map({ "n", "t" }, "<F8>", function()
        vim.cmd "stopinsert"
        require("utils.compiler").monitor()
    end, { desc = "Serial monitor toggle" })
    map("n", "<F2>", require("utils.compiler").pio_clean, { buffer = true, desc = "Regenerate tags" })
    map("n", "<F3>", require("utils.compiler").pio_check, { buffer = true, desc = "Verify code" })
    map("n", "<F5>", "<cmd>w <CR> <cmd>Make<CR>", { buffer = true, desc = "Build" })
    map("n", "<F6>", "<cmd>w <CR> <cmd>Make --target upload<CR>", { buffer = true, desc = "Upload" })
    map("n", ",ka", function()
        require("utils.compiler").ardRef(vim.fn.expand "<cword>")
    end, { buffer = true, desc = "Arduino" })
    map("n", ",kt", require("utils.compiler").teensypins, { buffer = true, desc = "teensy pins" })
    map("n", ",kT", require("utils.compiler").teensyspecs, { buffer = true, desc = "teensy specs" })

    wk.register {
        [","] = { k = { "Arduino documentation", buffer = 0 } },
    }
end

------------------------------------------------------------------------
--                              OpenFrameworks                        --
------------------------------------------------------------------------

function mappings.makeC()
    map("n", "<F4>", "<cmd>w <CR> <cmd>Make Debug -j12<CR>", { buffer = true, desc = "Compile Debug" })
    map("n", "<F5>", function()
        require("utils.compiler").renderOffload("make RunRelease", "Make -j12", true)
    end, { buffer = true, desc = "Compile and Run Release" })
    map("n", "<F6>", function()
        require("utils.compiler").renderOffload "make RunRelease"
    end, { buffer = true, desc = "Run Release" })
end

------------------------------------------------------------------------
--                              General cpp mappings                  --
------------------------------------------------------------------------

-- ******************************** C files ----------------------------
function mappings.ctests()
    map(
        "n",
        "<F3>",
        "<cmd>w <CR> <cmd>Dispatch gcc % -lm -o %<<CR> <cmd>Dispatch ./%<<CR>",
        { buffer = true, desc = "Use gcc" }
    )
    map("n", "<F4>", function()
        vim.cmd "w | redraw"
        require("utils.compiler").with_flags()
    end, { buffer = true, desc = "Make with defined flags" })
    map("n", "<F5>", "<cmd>w <CR> <cmd>Make -g % -o %<<CR>", { buffer = true, desc = "Make" })
    map("n", "<F6>", function()
        require("utils.compiler").renderOffload "./%<"
    end, { buffer = true, desc = "Launch binary" })
end

-- ******************************** Pd externals ------------------------
function mappings.pdc()
    map("n", "<F5>", "<cmd>w<CR><cmd>Make<CR>", { buffer = true, desc = "Build Pd external" })
    map("n", "<F6>", function()
        vim.cmd "w | redraw"
        require("utils.compiler").pdBuild()
    end, { buffer = true, desc = "Copy external to PD directory" })
end

-- ******************************** Clang Lsp----------------------------

function mappings.clang()
    wk.register({
        [";"] = {
            b = { "<cmd>CclsBase<CR>", "Base function" },
            c = { "<cmd>CclsCallers<CR>", "Callers" },
            C = { "<cmd>CclsCallees<CR>", "Callees" },
            d = { "<cmd>CclsDerived<CR>", "Derived functions" },
            m = { "<cmd>CclsMemberHierarchy -float<CR>", "Member variables" },
            f = { "<cmd>CclsMemberFunctionHierarchy -float<CR>", "Member functions" },
            t = { "<cmd>CclsMemberTypeHierarchy -float<CR>", "Member classes" },
            v = { "<cmd>CclsVars<CR>", "Variables in function" },
            h = {
                name = "heirarchy",
                b = { "<cmd>CclsBaseHierarchy -float<CR>", "Base function" },
                c = { "<cmd>CclsCallHierarchy -float<CR>", "Caller" },
                C = { "<cmd>CclsCalleeHierarchy -float<CR>", "Callee" },
                d = { "<cmd>CclsDerivedHierarchy -float<CR>", "Derived functions" },
            },
        },
        [","] = {
            k = {
                name = "Online help",
                c = {
                    function()
                        require("utils.compiler").creference(vim.fn.expand "<cword>")
                    end,
                    "C++ std reference",
                },
                g = {
                    function()
                        require("utils.compiler").glRef(vim.fn.expand "<cword>")
                    end,
                    "OpenGL reference",
                },
            },
        },
        ["<leader>"] = {
            s = { "<cmd>ClangdSwitchSourceHeader<cr>", "Switch to Header/Source" },
            m = {
                function()
                    require("utils.compiler").makefile(vim.g.makeFile)
                end,
                "Open Makefile",
            },
            c = {
                function()
                    require("utils.compiler").ctags(vim.g.cfiles)
                end,
                "generate Ctags with includes",
            },
        },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              Cmake                                 --
------------------------------------------------------------------------

function mappings.cmake()
    map("n", "<F2>", require("utils.compiler").cmake_clean, { buffer = true, desc = "Clean cmake" })
    map("n", "<F3>", function()
        vim.cmd "w | redraw"
        require("utils.compiler").cmake_gen_debug()
    end, { buffer = true, desc = "Generate Cmake Debug" })
    map("n", "<F4>", function()
        vim.cmd "w | redraw"
        require("utils.compiler").cmake_gen()
    end, { buffer = true, desc = "Generate Cmake Release" })
    map("n", "<F5>", "<cmd>w <CR> <cmd>Make -j12 -C build<CR>", { buffer = true, desc = "Make" })
    map("n", "<F6>", function()
        require("utils.compiler").renderOffload(vim.g.cmakeBin)
    end, { buffer = true, desc = "Launch binary" })
end

------------------------------------------------------------------------
--                              Co-Autho                              --
------------------------------------------------------------------------

function mappings.coauthor()
    wk.register {
        ["<leader>"] = {
            i = {
                name = "Co-Authoring",
                i = {
                    function()
                        require("instant.server").StartServer("192.168." .. vim.fn.input "Enter extension: ", "8080")
                    end,
                    "Start Co-authoring Server",
                },
                s = {
                    function()
                        require("instant").StartServer("192.168." .. vim.fn.input "Enter extension: ", "8080")
                    end,
                    "Launch session",
                },
                b = {
                    function()
                        require("instant").Start("192.168." .. vim.fn.input "Enter extension: ", "8080")
                    end,
                    "Launch current buffer",
                },
                j = {
                    function()
                        require("instant").JoinSession("192.168." .. vim.fn.input "Enter extension: ", "8080")
                        require("instant").StartFollow(vim.fn.input "User to follow: ")
                    end,
                    "Join session",
                },
                J = {
                    function()
                        require("instant").Join("192.168." .. vim.fn.input "Enter extension: ", "8080")
                        require("instant").StartFollow(vim.fn.input "User to follow: ")
                    end,
                    "Join single buffer",
                },
                f = {
                    function()
                        require("instant").StartFollow(vim.fn.input "User to follow: ")
                    end,
                    "follow user",
                },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

function mappings.debug()
    wk.register({
        ["<leader>"] = {
            d = {
                name = "debug",
                b = { require("dap").toggle_breakpoint, "set breakpoint" },
                x = { require("dap").set_exception_breakpoints, "set breakpoint" },
                f = {
                    function()
                        require("dapui").float_element("scopes", { enter = true })
                    end,
                    "Floating Scopes",
                },
                F = {
                    function()
                        require("dapui").float_element("stacks", { enter = true })
                    end,
                    "Floating Stacks",
                },
                B = {
                    function()
                        require("dap").toggle_breakpoint(vim.fn.input "Breakpoint condition: ")
                    end,
                    "set breakpoint",
                },
            },
        },
    }, { buffer = 0 })
    wk.register {
        ["<leader>d"] = {
            name = "debug",
            ["."] = { require("dap").close, "End" },
            ["?"] = { require("debugger").frames, "Frames" },
            ["/"] = { require("debugger").scopes, "Scopes" },
            t = { require("debugger").threads, "threads" },
            u = { require("dapui").toggle, "Toggle all UI" },
            c = { require("dap").continue, "continue to next breakpoint" },
            n = { require("dap").step_over, "step over" },
            s = { require("dap").step_into, "step into" },
            S = { require("dap").step_out, "step Out" },
        },
        ["<F10>"] = {
            function()
                require("dap").repl.toggle({ height = 10 }, "split")
            end,
            "Repl Toggle",
        },
    }

    map({ "n", "v", "s" }, "<leader>de", function()
        require("dapui").eval()
        require("dapui").eval()
    end, { buffer = true, desc = "Evaluate Hover " })
    map({ "n", "v" }, "<leader>do", require("dapui").float_element, { buffer = true, desc = "Open floating elements" })
    map({ "n", "v", "s" }, "<leader>dE", require("debugger").exp, { buffer = true, desc = "Expressions" })
end

------------------------------------------------------------------------
--                              Latex                                 --
------------------------------------------------------------------------

function mappings.tex()
    map("n", "<F3>", "<cmd>TexWordCount<CR>", { buffer = true, desc = "Word count" })
    map("n", "<F4>", "<cmd>Make -C<CR>", { buffer = true, desc = "Clean tex files" })
    map("n", "<F5>", "<cmd>TexlabBuild<CR>", { buffer = true, desc = "Compile tex document" })
    map("n", "<F6>", "<cmd>TexlabForward<CR>", { buffer = true, desc = "Launch zathura" })
end

return mappings
