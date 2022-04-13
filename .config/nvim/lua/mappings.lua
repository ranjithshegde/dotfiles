local mappings = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              General functions                     --
------------------------------------------------------------------------

function mappings.general()
    mappings.configFiles()
    mappings.telescope()
    mappings.treesitter()
    mappings.coauthor()

    local opts = { nowait = true }
    --line movement
    map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up" })
    map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down" })
    -- visual cut for replase
    map({ "v", "s" }, "<leader>p", '"_dP', opts)
    -- Indent
    map("v", "<", "<gv", opts)
    map("v", ">", ">gv", opts)
    -- Terminal
    map("t", "<Esc>", "<C-\\><C-n>", opts)
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

    wk.register {
        ["<Tab>"] = { "za", "Toggle fold current" },
        ["<S-Tab>"] = { "zA", "Toggle fold All" },
        -- open folds when searching
        n = { "nzzzv", "jump to next search result" },
        N = { "Nzzzv", "jump to previous search result" },
        J = { "mzJ`z", "Adjoin next line" },
        gm = { "cursor(0, virtcol('$')/2 )", "Move cursor to middle of the line", expr = true, buffer = 0 },
        gf = { "<cmd>e <cfile><CR>", "open file under cursor" },
        -- Terminals
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { "<cmd>sp term://zsh<cr>", "Horizontal" },
            v = { "<cmd>vspl term://zsh<cr>", "Vertical" },
            t = { "<cmd>tab drop term://zsh<cr>", "New tab" },
        },
        ["<leader><Tab>"] = { "<cmd>SidebarNvimToggle<CR>", "Toggle Symbolsbar" },
    }

    -- ******************************** vimWiki-----------------------
    wk.register {
        ["<leader>w"] = {
            name = "vimWiki",
            w = "Index",
            d = "Delete file",
            r = "Rename file",
            n = "New file",
            i = "Diary index",
            t = "Index in a new tab",
            c = "Add color to header/link",
            ["<leader>"] = {
                name = "Diary entries",
                w = "Today",
                t = "Today in new tab",
                i = "Reindex",
                y = "Yesterday",
                m = "Tomorrow",
            },
        },
    }

    wk.register {
        ["<leader>ow"] = {
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
--                              Utilities                             --
------------------------------------------------------------------------

function mappings.ranger()
    wk.register {
        ["<leader>r"] = {
            name = "Ranger file picker",
            r = {
                function()
                    vim.fn["util#ranger"]("%:p:h", "e ")
                end,
                "from current file",
            },
            R = {
                function()
                    vim.fn["util#ranger"](".", "e ")
                end,
                "from current directory",
            },
            v = {
                function()
                    vim.cmd "vnew"
                    vim.fn["util#ranger"]("%:p:h", "vs ")
                end,
                "in a split from current file",
            },
            V = {
                function()
                    vim.cmd "vnew"
                    vim.fn["util#ranger"](".", "vs ")
                end,
                "in a split from current directory",
            },
            t = {
                function()
                    vim.cmd "tabnew"
                    vim.fn["util#ranger"]("%:p:h", "tab drop ")
                end,
                "in a new tab from current file",
            },
            T = {
                function()
                    vim.cmd "tabnew"
                    vim.fn["util#ranger"](".", "tab drop ")
                end,
                "in a new tab from current directory",
            },
        },
    }
end

function mappings.wordProcessor()
    wk.register({
        zG = {
            'writefile([expand("<cword>")], "/usr/share/words.txt", "a")',
            "Add word to LanguageTool dictionary",
            expr = true,
        },
        ["<leader><Space>"] = { '<cmd>g/^/pu ="\n"<CR>', "Double space entire file" },
        [","] = {
            K = { "<cmd>lua require('utils').dictionary(vim.fn.expand('<cword>'))<CR>", "Lookup Wikitionary" },
            T = { "<cmd>lua require('utils').thesaurus(vim.fn.expand('<cword>'))<CR>", "Lookup Synonyms" },
        },
    }, { nowait = true, noremap = true, silent = true })
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

    wk.register {
        ["<F11>"] = { "<cmd>SymbolsOutline<CR>", "Toggle Symbolsbar" },
    }
end

-- ******************************** Diagnostics------------------------

function mappings.diagnostic()
    wk.register {
        [",ld"] = { vim.diagnostic.open_float, "Show line diagnostics" },
        ["[d"] = { vim.diagnostic.goto_prev, "Show previous diagnostics" },
        ["]d"] = { vim.diagnostic.goto_next, "Show next diagnostics" },
    }
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
                    v = { open "after/ftplugin/vimwiki.lua", "Vimwiki" },
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

    local cd_browser = function(prompt, cwd)
        return function()
            require("telescope").extensions.file_browser.file_browser {
                prompt_title = prompt,
                cwd = cwd,
                attach_mappings = function(prompt_bufnr, maps)
                    local change_dir = function(window)
                        local wd = require("telescope.actions.state").get_selected_entry().value
                        require("telescope.actions.set").select(prompt_bufnr, window)
                        if not require("plenary.path"):new(wd):is_dir() then
                            local dir = vim.fn.fnamemodify(wd, ":p:h")
                            vim.fn.execute("tcd " .. dir)
                        end
                    end
                    maps("n", "<CR>", function()
                        change_dir "default"
                    end)
                    maps("i", "<CR>", function()
                        change_dir "default"
                    end)
                    maps("n", "<C-v>", function()
                        change_dir "vertical"
                    end)
                    maps("i", "<C-v>", function()
                        change_dir "vertical"
                    end)
                    maps("n", "<C-t>", function()
                        change_dir "tab"
                    end)
                    maps("i", "<C-t>", function()
                        change_dir "tab"
                    end)
                    return true
                end,
            }
        end
    end

    local cd_files = function(prompt, cwd)
        return function()
            require("telescope.builtin").find_files {
                prompt_title = prompt,
                cwd = cwd,
                attach_mappings = function(prompt_bufnr, maps)
                    local change_dir = function(window)
                        local wd = require("telescope.actions.state").get_selected_entry().value
                        require("telescope.actions.set").select(prompt_bufnr, window)
                        vim.fn.execute("tcd " .. cwd)
                        local dir = vim.fn.fnamemodify(wd, ":p:h")
                        vim.fn.execute("tcd " .. dir)
                    end
                    maps("n", "<CR>", function()
                        change_dir "default"
                    end)
                    maps("i", "<CR>", function()
                        change_dir "default"
                    end)
                    maps("n", "<C-v>", function()
                        change_dir "vertical"
                    end)
                    maps("i", "<C-v>", function()
                        change_dir "vertical"
                    end)
                    maps("n", "<C-t>", function()
                        change_dir "tab"
                    end)
                    maps("i", "<C-t>", function()
                        change_dir "tab"
                    end)
                    return true
                end,
            }
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
                w = {
                    name = "vimWiki",
                    w = {
                        telargs("live_grep", { cwd = "~/Documents/vimWiki", prompt_title = "wiki directory" }),
                        "whole wiki",
                    },
                    d = {
                        telargs("live_grep", { cwd = "~/Documents/vimWiki/diary", prompt_title = "Diary entires" }),
                        "Inside diary",
                    },
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
                w = { telargs("find_files", { cwd = "~/Documents/vimWiki", prompt_title = "vimWiki" }), "wiki" },
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
            p = { "<cmd>Gitsigns preview_hunk<cr>", "preview hunk under cursor" },
            s = { "<cmd>Gitsigns stage_hunk<cr>", "stage hunk under cursor" },
            P = { "<cmd>G push<cr>", "push commits" },
            l = { "<cmd>G log<cr>", "commit history" },
            L = { "<cmd>Gclog<cr>", "commit CLog" },
        },
        ["]h"] = { "<cmd>Gitsigns next_hunk<cr>:Gitsigns preview_hunk<CR>", "Preview previous hunk" },
        ["[h"] = { "<cmd>Gitsigns prev_hunk<cr>:Gitsigns preview_hunk<CR>", "Preview next hunk" },
    }
end

------------------------------------------------------------------------
--                              SuperCollider                         --
------------------------------------------------------------------------

function mappings.scnvim()
    map("n", "<F5>", "<Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("i", "<F5>", "<esc><Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("v", "<F5>", "<Plug>(scnvim-send-selection)", { buffer = true, desc = "Evaluate SC visual block" })
    map("n", "<F6>", "<Plug>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("i", "<F6>", "<Plug><esc>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("n", ",s", function()
        require("scnvim.completion.signature").show { border = "rounded" }
    end, { buffer = true, desc = "SC signature help" })

    wk.register({
        ["<F1>"] = { require("scnvim").start, "Launch Sclang" },
        ["<F2>"] = { "<cmd>SCNvimStatusLine<cr>", "Display server status" },
        ["<F3>"] = { 'scnvim#sclang#send_silent("Server.local.boot")', "Boot local server", expr = true },
        ["<F4>"] = { 'scnvim#sclang#send_silent("WFSLib.startup")', "Boot WFS server", expr = true },
        ["<leader>s"] = { "<cmd>tabnew ~/.config/SuperCollider/startup.scd<cr>", "open startup file" },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              Arduino                               --
------------------------------------------------------------------------

function mappings.micro()
    map({ "n", "t" }, "<F8>", function()
        vim.cmd "stopinsert"
        require("utils.compiler").monitor()
    end, { desc = "Serial monitor toggle" })

    wk.register({
        ["<F2>"] = { require("utils.compiler").pio_clean, "Regenerate tags" },
        ["<F3>"] = { require("utils.compiler").pio_check, "Verify code" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make<CR>", "Build" },
        ["<F6>"] = { "<cmd>w <CR> <cmd>Make --target upload<CR>", "Upload" },
        [","] = {
            k = {
                a = {
                    function()
                        require("utils.compiler").ardRef(vim.fn.expand "<cword>")
                    end,
                    "Arduino",
                },
                t = { require("utils.compiler").teensypins, "teensy pins" },
                T = { require("utils.compiler").teensyspecs, "teensy specs" },
            },
        },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              OpenFrameworks                        --
------------------------------------------------------------------------

function mappings.makeC()
    wk.register({
        ["<F4>"] = { "<cmd>w <CR> <cmd>Make Debug -j12<CR>", "Compile Debug" },
        ["<F5>"] = {
            function()
                require("utils.compiler").renderOffload("make RunRelease", "Make -j12", true)
            end,
            "Compile and Run Release",
        },
        ["<F6>"] = {
            function()
                require("utils.compiler").renderOffload "make RunRelease"
            end,
            "Run Release",
        },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              General cpp mappings                  --
------------------------------------------------------------------------

-- ******************************** C files ----------------------------
function mappings.ctests()
    wk.register({
        ["<F3>"] = { "<cmd>w <CR> <cmd>Dispatch gcc % -lm -o %<<CR> <cmd>Dispatch ./%<<CR>", "Use gcc" },
        ["<F4>"] = {
            function()
                vim.cmd "w | redraw"
                require("utils.compiler").with_flags()
            end,
            "Make with defined flags",
        },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -g % -o %<<CR>", "Make" },
        ["<F6>"] = {
            function()
                require("utils.compiler").renderOffload "./%<"
            end,
            "Launch binary",
        },
    }, { buffer = 0 })
end

-- ******************************** Pd externals ------------------------
function mappings.pdc()
    wk.register({
        ["<F5>"] = { "<cmd>w<CR><cmd>Make<CR>", "Build Pd external" },
        ["<F6>"] = {
            function()
                vim.cmd "w | redraw"
                require("utils.compiler").pdBuild()
            end,
            "Copy external to PD directory",
        },
    }, { buffer = 0 })
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
    wk.register({
        ["<F2>"] = { require("utils.compiler").cmake_clean, "Clean cmake" },
        ["<F3>"] = {
            function()
                vim.cmd "w | redraw"
                require("utils.compiler").cmake_gen_debug()
            end,
            "Generate Cmake Debug",
        },
        ["<F4>"] = {
            function()
                vim.cmd "w | redraw"
                require("utils.compiler").cmake_gen()
            end,
            "Generate Cmake Release",
        },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -j12 -C build<CR>", "Make" },
        ["<F6>"] = {
            function()
                require("utils.compiler").renderOffload(vim.g.cmakeBin)
            end,
            "Launch binary",
        },
    }, { buffer = 0 })
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
    wk.register({
        ["<F3>"] = { "<cmd>TexWordCount<CR>", "Word count" },
        ["<F4>"] = { "<cmd>Make -C<CR>", "Clean tex files" },
        ["<F5>"] = { "<cmd>TexlabBuild<CR>", "Compile tex document" },
        ["<F6>"] = { "<cmd>TexlabForward<CR>", "Launch zathura" },
    }, { buffer = 0 })
end

return mappings
