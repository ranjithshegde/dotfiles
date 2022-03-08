local M = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              General functions                     --
------------------------------------------------------------------------

function M.general()
    M.configFiles()
    M.telescope()
    M.coauthor()
    M.treesitter()

    local opts = { nowait = true, noremap = true, silent = true }
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
    map("t", "<F9>", function()
        vim.cmd "stopinsert"
        require("utils").toggleTerm("zsh", "shell", 1)
    end, {
        desc = "Toggle current/default terminal",
    })

    wk.register {
        -- open folds when searching
        n = { "nzzzv", "jump to next search result" },
        N = { "Nzzzv", "jump to previous search result" },
        J = { "mzJ`z", "Adjoin next line" },
        gm = { "cursor(0, virtcol('$')/2 )", "Move cursor to middle of the line", expr = true },
        gf = { "<cmd>e <cfile><CR>", "open file under cursor" },
        --Quickfix
        ["-"] = { "<cmd>lua require('utils.qf').toggle_qf('q')<CR>", "Toggle quickfix" },
        ["_"] = { "<cmd>lua require('utils.qf').toggle_qf('l')<CR>", "Toggle loclist" },
        -- Terminals
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { "<cmd>sp term://zsh<cr>", "Horizontal" },
            v = { "<cmd>vspl term://zsh<cr>", "Vertical" },
            t = { "<cmd>tabnew term://zsh<cr>", "New tab" },
        },
        ["<F9>"] = { "<cmd>lua require('utils').toggleTerm('zsh','shell',1)<cr>", "Toggle zsh terminal" },
        ["<F10>"] = "Toggle repl for available filetypes",
        ["<leader><Tab>"] = { "<cmd>SidebarNvimToggle<CR>", "Toggle Symbolsbar" },
    }

    -- **************************** conditional mappings -------------

    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "org" then
        wk.register {
            ["<Tab>"] = { "za", "Toggle fold current" },
            ["<S-Tab>"] = { "zA", "Toggle fold All" },
        }
    end

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
end

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

function M.ranger()
    wk.register {
        ["<leader>r"] = {
            name = "Ranger file picker",
            r = {
                function()
                    require("utils").ranger("%:p:h", "e ")
                end,
                "from current file",
            },
            R = {
                function()
                    require("utils").ranger(".", "e ")
                end,
                "from current directory",
            },
            v = {
                function()
                    vim.cmd "vnew"
                    require("utils").ranger("%:p:h", "vs ")
                end,
                "in a split from current file",
            },
            V = {
                function()
                    vim.cmd "vnew"
                    require("utils").ranger(".", "vs ")
                end,
                "in a split from current directory",
            },
            t = {
                function()
                    vim.cmd "tabnew"
                    require("utils").ranger("%:p:h", "tab drop ")
                end,
                "in a new tab from current file",
            },
            T = {
                function()
                    vim.cmd "tabnew"
                    require("utils").ranger(".", "tab drop ")
                end,
                "in a new tab from current directory",
            },
        },
    }
end

function M.wordProcessor()
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

function M.nvim_lsp()
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
        --     ["<F1>"] = { "<cmd>TlistToggle<CR>", "Toggle Taglist" },
    }
end

-- ******************************** Diagnostics------------------------

function M.diagnostic()
    local function fmt(diagnostic)
        if diagnostic.code then
            return ("[%s] %s"):format(diagnostic.code, diagnostic.message)
        end
        return diagnostic.message
    end
    local opts = { border = "double", source = "always", format = fmt }
    wk.register {
        [",ld"] = {
            function()
                vim.diagnostic.open_float(opts)
            end,
            "Show line diagnostics",
        },
        ["[d"] = {
            function()
                vim.diagnostic.goto_prev { float = opts }
            end,
            "Show previous diagnostics",
        },
        ["]d"] = {
            function()
                vim.diagnostic.goto_next { float = opts }
            end,
            "Show next diagnostics",
        },
    }
end

------------------------------------------------------------------------
--                              Vim config files                      --
------------------------------------------------------------------------

function M.configFiles()
    wk.register {
        ["<leader>"] = {
            a = {
                name = "vimrc files",
                p = { "<cmd>tabnew ~/.config/nvim/lua/plugins.lua<CR>", "Packer config" },
                m = { "<cmd>tabnew ~/.config/nvim/lua/mappings.lua<CR>", "Keymaps" },
                o = { "<cmd>tabnew ~/.config/nvim/lua/settings.lua<CR>", "Options and settings" },
                d = { "<cmd>tabnew ~/.config/nvim/lua/debugger.lua<CR>", "Debug adapter protocol" },
                s = { "<cmd>tabnew ~/.config/nvim/lua/statusline.lua<CR>", "Statusline and Tabline" },
                c = { "<cmd>tabnew ~/.config/nvim/lua/utils/compiler.lua<CR>", "Cpp Workstation" },
                u = { "<cmd>tabnew ~/.config/nvim/lua/utils/init.lua<CR>", "Utilities in lua" },
                e = { "<cmd>tabnew ~/.config/nvim/lua/utils/diagnostics.lua<CR>", "Diagnostic extensions" },
                l = { "<cmd>tabnew ~/.config/nvim/lua/utils/langServers.lua<CR>", "Langauge Server extensions" },
                a = { "<cmd>tabnew ~/.config/nvim/autoload/util.vim<CR>", "Utilities in autoload" },
                f = { "<cmd>tabnew ~/.config/nvim/after/plugin/plugins.lua<CR>", "User defined commands" },
                r = { "<cmd>tabnew $MYVIMRC<CR>", "VimRC" },
                P = { "<cmd>PackerSync<CR>", "Update packages" },
                R = { require("utils").Restart, "Reload Vim" },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Treesitter                            --
------------------------------------------------------------------------

function M.treesitter()
    wk.register {
        [";"] = {
            name = "Syntax tree functions",
            -- Plugins
            K = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Show treesitter node" },
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
            s = {
                name = "Swap forwards",
                s = "statement",
                o = "comment",
                p = "Paramater outer",
                P = "Parameter inner",
                f = "function outer",
                F = "function inner",
                c = "conditional outer",
                C = "conditional inner",
                l = "loop outer",
                L = "loop inner",
                a = "call outer",
                A = "call inner",
            },
            S = {
                name = "Swap backwards",
                s = "statement",
                o = "comment",
                p = "Paramater outer",
                P = "Parameter inner",
                f = "function outer",
                F = "function inner",
                c = "conditional outer",
                C = "conditional inner",
                l = "loop outer",
                L = "loop inner",
                a = "call outer",
                A = "call inner",
            },
            g = {
                name = "incremental selection",
                n = "Start selection at node",
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

function M.telescope()
    local tele = function(name)
        return string.format("<cmd>lua require('telescope.builtin').%s()<cr>", name)
    end
    local telF = function(name)
        return string.format("<cmd>lua require('telescope.builtin').%s<cr>", name)
    end
    local telE = function(name)
        return string.format("<cmd>lua require'telescope'.extensions.%s<cr>", name)
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
                            -- vim.fn.execute("tcd " .. wd)
                            -- else
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
            e = { telE "file_browser.file_browser({files=false})", "Folder browser" },
            E = { telE "file_browser.file_browser()", "File browser" },
            k = { telF "lsp_workspace_symbols({query = vim.fn.expand('<cword>')})", "Search lsp workspace symbol" },
            l = { tele "loclist", "local quickfix list" },
            m = { tele "symbols", "Unicode characters" },
            o = { cd_files("Org files", "~/Documents/Orgs"), "Org files" },
            p = { telE "project.project{display_type = 'full'}", "Projects" },
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
                    telF "live_grep({cwd ='~/Documents/Supercollider/',prompt_title = 'SuperCollider Workspace grep'})",
                    "grep SuperCollider",
                },
                o = {
                    telF "live_grep({cwd ='~/Documents/ofWorkspace/',prompt_title = 'oF Workspace grep'})",
                    "ofWorkspace",
                },
                d = {
                    telF "live_grep({cwd ='~/.config', prompt_title = 'Dotfiles grep'})",
                    "grep dotfiles",
                },
                ["?"] = {
                    telF 'live_grep({cwd = vim.fn.input({prompt = "Enter directory: ", completion = "dir"})})',
                    "Choose directory",
                },
                w = {
                    name = "vimWiki",
                    w = {
                        telF "live_grep({cwd = '~/Documents/vimWiki', prompt_title = 'wiki directory'})",
                        "whole wiki",
                    },
                    d = {
                        telF "live_grep({cwd = '~/Documents/vimWiki/diary', prompt_title = 'Diary entires'})",
                        "Inside diary",
                    },
                },
            },
            F = { tele "find_files", "Current directory" },
            f = {
                name = "find files in",
                f = { tele "find_files", "Current directory" },
                h = { telF "find_files({cwd='~'})", "Home directory" },
                r = { tele "oldfiles", "Vim recent files" },
                t = { tele "help_tags", "vim help files" },
                c = { cd_browser("C++ Practice files/dirs", "$CWORK/Practice"), "Open C practice" },
                C = { cd_files("C++ Practice files/dirs", "$CWORK/Practice"), "Open C practice" },
                b = {
                    telF "find_files({cwd='~/.local/bin/', prompt_title = 'Scripts and binaries in local'})",
                    "scripts & binaries",
                },
                d = {
                    telF "find_files({cwd='~/.config/', find_command = {'fd', '--hidden'},prompt_title = 'Dotfiles'})",
                    "Dotfiles",
                },
                v = {
                    telF "find_files({cwd='~/.local/share/nvim/', prompt_title = 'Plugin files'})",
                    "Vim plugin Directory",
                },
                o = {
                    telF "find_files({cwd ='~/Documents/ofWorkspace/',prompt_title = 'oF Workspace files'})",
                    "OfWorkspace",
                },
                s = { cd_files("SuperCollider Directory", "~/Documents/Supercollider/"), "SuperCollider files" },
                w = { telF "find_files({cwd = '~/Documents/vimWiki', prompt_title = 'vimWiki'})", "wiki" },
                ["?"] = {
                    telF 'find_files({cwd = vim.fn.input({prompt = "Enter directory: ", completion = "dir"})})',
                    "Choose directory",
                },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Git                                   --
------------------------------------------------------------------------

function M.git()
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
--                              Completion & Snippets                 --
------------------------------------------------------------------------

function M.autoComplete()
    -- change completion mode
    map("i", "<C-j>", "<Plug>(completion_next_source)")
    map("i", "<C-k>", "<Plug>(completion_prev_source)")

    local ls = require "luasnip"
    map({ "i", "s" }, "<C-l>", function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, { silent = true, desc = "jump to next placeholder" })

    map({ "i", "s" }, "<C-h>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true, desc = "jump to prev placeholder" })
end

------------------------------------------------------------------------
--                              SuperCollider                         --
------------------------------------------------------------------------

function M.scnvim()
    map("n", "<F5>", "<Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("i", "<F5>", "<esc><Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("v", "<F5>", "<Plug>(scnvim-send-selection)", { buffer = true, desc = "Evaluate SC visual block" })
    map("n", "<F6>", "<Plug>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("i", "<F6>", "<Plug><esc>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("n", ",s", "<Plug>(scnvim-show-signature)", { buffer = true, desc = "SC signature help" })

    wk.register({
        ["<F1>"] = { "<cmd>SCNvimStart<cr>", "Launch Sclang" },
        ["<F2>"] = { "<cmd>SCNvimStatusLine<cr>", "Display server status" },
        ["<F3>"] = { 'scnvim#sclang#send_silent("Server.local.boot")', "Boot local server", expr = true },
        ["<F4>"] = { 'scnvim#sclang#send_silent("WFSLib.startup")', "Boot WFS server", expr = true },
        ["<leader>s"] = { "<cmd>tabnew ~/.config/SuperCollider/startup.scd<cr>", "open startup file" },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              Arduino                               --
------------------------------------------------------------------------

function M.micro()
    wk.register(
        { ["<F8>"] = { "<esc><cmd>lua require('utils.compiler').monitor()<CR>", "Serial monitor toggle" } },
        { mode = "t" }
    )
    wk.register({
        ["<F2>"] = { require("utils.compiler").pio_clean, "Regenerate tags" },
        ["<F3>"] = { require("utils.compiler").pio_check, "Verify code" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make<CR>", "Build" },
        ["<F6>"] = { "<cmd>w <CR> <cmd>Make --target upload<CR>", "Upload" },
        ["<F8>"] = { require("utils.compiler").monitor, "Serial monitor toggle" },
        [","] = {
            k = {
                a = { "<cmd>lua require('utils.compiler').ardRef(vim.fn.expand('<cword>'))<CR>", "Arduino" },
                t = { require("utils.compiler").teensypins, "teensy pins" },
                T = { require("utils.compiler").teensyspecs, "teensy specs" },
            },
        },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              OpenFrameworks                        --
------------------------------------------------------------------------

function M.makeC()
    wk.register({
        ["<F4>"] = { "<cmd>w <CR> <cmd>Make Debug -j12<CR>", "Compile Debug" },
        ["<F5>"] = {
            function()
                require("utils.compiler").renderOffload("make RunRelease", "Make -j12", true)
            end,
            "Compile and Run Release",
        },
        ["<F6>"] = { '<cmd>lua require("utils.compiler").renderOffload("make RunRelease")<CR>', "Run Release" },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              General cpp mappings                  --
------------------------------------------------------------------------

-- ******************************** C files ----------------------------
function M.ctests()
    wk.register({
        ["<F3>"] = { "<cmd>w <CR> <cmd>Dispatch gcc % -lm -o %<<CR> <cmd>Dispatch ./%<<CR>", "Use gcc" },
        ["<F4>"] = { "<cmd>w <CR> <cmd>lua require('utils.compiler').with_flags()<cr>", "Make with defined flags" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -g % -o %<<CR>", "Make" },
        ["<F6>"] = { '<cmd>lua require("utils.compiler").renderOffload("./%<")<cr>', "Launch binary" },
    }, { buffer = 0 })
end

-- ******************************** Pd externals ------------------------
function M.pdc()
    wk.register({
        ["<F5>"] = { "<cmd>w<CR><cmd>Make<CR>", "Build Pd external" },
        ["<F6>"] = { "<cmd>w<CR><cmd>lua require('utils.compiler').pdBuild()<CR>", "Copy external to PD directory" },
    }, { buffer = 0 })
end

-- ******************************** Clang Lsp----------------------------

function M.clang()
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
                    "<cmd>lua require('utils.compiler').creference(vim.fn.expand('<cword>'))<CR>",
                    "C++ std reference",
                },
                g = { "<cmd>lua require('utils.compiler').glRef(vim.fn.expand('<cword>'))<CR>", "OpenGL reference" },
            },
        },
        ["<leader>"] = {
            s = { "<cmd>ClangdSwitchSourceHeader<cr>", "Switch to Header/Source" },
            m = { "<cmd>lua require('utils.compiler').makefile(vim.g.makeFile)<CR>", "Open Makefile" },
            c = { "<cmd>lua require('utils.compiler').ctags(vim.g.cfiles)<CR>", "generate Ctags with includes" },
        },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              Cmake                                 --
------------------------------------------------------------------------

function M.cmake()
    wk.register({
        ["<F2>"] = { require("utils.compiler").cmake_clean, "Clean cmake" },
        ["<F3>"] = { '<cmd>w <CR> <cmd>lua require("utils.compiler").cmake_gen_debug()<CR>', "Generate Cmake Debug" },
        ["<F4>"] = { '<cmd>w <CR> <cmd>lua require("utils.compiler").cmake_gen()<CR>', "Generate Cmake Release" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -j12 -C build<CR>", "Make" },
        ["<F6>"] = { '<cmd>lua require("utils.compiler").renderOffload(vim.g.cmakeBin)<cr>', "Launch binary" },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              Co-Autho                              --
------------------------------------------------------------------------

function M.coauthor()
    wk.register {
        ["<leader>"] = {
            i = {
                name = "Co-Authoring",
                i = { require("utils").Start, "Start server" },
                s = { require("utils").Session, "Launch session" },
                b = { require("utils").Single, "Launch current buffer" },
                j = { require("utils").JoinSession, "Join session" },
                J = { require("utils").JoinSingle, "Join single buffer" },
                f = { require("utils").Follow, "follow user" },
            },
        },
    }
end

------------------------------------------------------------------------
--                              Debug Adapters                        --
------------------------------------------------------------------------

function M.debug()
    wk.register({
        ["<leader>"] = {
            d = {
                name = "debug",
                E = { require("debugger").exp, "Expressions" },
                b = { require("dap").toggle_breakpoint, "set breakpoint" },
                x = { require("dap").set_exception_breakpoints, "set breakpoint" },
                o = { require("dapui").float_element, "Open floating features" },
                f = { "<cmd>lua require('dapui').float_element('scopes', {enter = true})<CR>", "Floating Scopes" },
                e = { "<cmd>lua require('dapui').eval()<CR><cmd>lua require('dapui').eval()<CR>", "Evaluate Hover" },
                F = { "<cmd>lua require('dapui').float_element('stacks', {enter = true})<CR>", "Floating Stacks" },
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
            u = { require("dapui").toggle, "Toggle all UI" },
            c = { require("dap").continue, "continue to next breakpoint" },
            n = { require("dap").step_over, "step over" },
            s = { require("dap").step_into, "step into" },
            S = { require("dap").step_out, "step Out" },
        },
        ["<F10>"] = { "<cmd>lua require('dap').repl.toggle({height = 10},'split')<CR>", "Repl Toggle" },
    }
    wk.register({
        ["<leader>"] = {
            d = {
                e = { "<cmd>lua require('dapui').eval()<CR><cmd>lua require('dapui').eval()<CR>", "Evaluate" },
                o = { require("dapui").float_element, "Open floating elements" },
                E = { require("debugger").exp, "Expressions" },
            },
        },
    }, { mode = "v", buffer = 0 })
end

------------------------------------------------------------------------
--                              Latex                                 --
------------------------------------------------------------------------

function M.tex()
    wk.register({
        ["<F3>"] = { "<cmd>TexWordCount<CR>", "Word count" },
        ["<F4>"] = { "<cmd>Make -C<CR>", "Clean tex files" },
        ["<F5>"] = { "<cmd>TexlabBuild<CR>", "Compile tex document" },
        ["<F6>"] = { "<cmd>TexlabForward<CR>", "Launch zathura" },
    }, { buffer = 0 })
end

return M
