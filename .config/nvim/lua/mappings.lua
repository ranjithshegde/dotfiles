local M = {}
local u = require "utils"
local wk = require "which-key"

-- ******************************** General functions ---------------------------------------

function M.general()
    M.configFiles()
    M.git()
    M.telescope()
    M.coauthor()
    M.diagnostic()
    M.ranger()
    M.treesitter()

    local opts = { nowait = true, noremap = true, silent = true }
    local maps = {
        --line movement
        { "x", "K", ":move '<-2<CR>gv-gv" },
        { "x", "J", ":move '>+1<CR>gv-gv" },
        -- visual cut for replase
        { "v", "<leader>p", '"_dP' },
        { "s", "<leader>p", '"_dP' },
        -- Indent
        { "v", "<", "<gv" },
        { "v", ">", ">gv" },
        -- Terminal
        { "t", "<Esc>", "<C-\\><C-n>" },
        { "t", "<F9>", "<esc><cmd>lua require('utils').toggleTerm('zsh','shell',1)<cr>" },
    }
    u.maps(maps, opts)

    wk.register {
        -- open folds when searching
        n = { "nzzzv", "jump to next search result" },
        N = { "Nzzzv", "jump to previous search result" },
        J = { "mzJ`z", "Adjoin next line" },
        gm = { "<cmd>call cursor(0, virtcol('$')/2 )<CR>", "Move cursor to middle of the line" },
        gf = { "<cmd>e <cfile><CR>", "open file under cursor" },
        --Quickfix
        ["-"] = { "<cmd>lua require('utils.qf').toggle_qf('q')<CR>", "Toggle quickfix" },
        ["_"] = { "<cmd>lua require('utils.qf').toggle_qf('l')<CR>", "Toggle loclist" },
        -- Window movement
        ["<C-J>"] = { "<C-W><C-J>", "Move to down buffer" },
        ["<C-K>"] = { "<C-W><C-K>", "Move to up buffer" },
        ["<C-L>"] = { "<C-W><C-L>", "Move to left buffer" },
        ["<C-H>"] = { "<C-W><C-H>", "Move to right buffer" },
        ["<leader>e"] = "File drawer toggle",
        -- Terminals
        ["<leader>t"] = {
            name = "Launch terminal in split",
            h = { "<cmd>sp term://zsh<cr>", "Horizontal" },
            v = { "<cmd>vspl term://zsh<cr>", "Vertical" },
            t = { "<cmd>tabnew term://zsh<cr>", "New tab" },
        },
        ["<F9>"] = { "<cmd>lua require('utils').toggleTerm('zsh','shell',1)<cr>", "Toggle zsh terminal" },
        ["<F10>"] = "Toggle repl for available filetypes",
    }

    -- vimWiki
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

    --Conditional changes
    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "org" then
        wk.register {
            ["<Tab>"] = { "za", "Toggle fold current" },
            ["<S-Tab>"] = { "zA", "Toggle fold All" },
        }
    end
end

-- ******************************** Utilities ---------------------------------------
function M.ranger()
    wk.register {
        ["<leader>r"] = {
            name = "Ranger file manager",
            r = "from current file",
            R = "from current directory",
            v = "in a split from current file",
            V = "in a split from current directory",
            t = "in a new tab from current file",
            T = "in a new tab from current directory",
        },
    }
end

function M.wordProcessor()
    wk.register {
        zG = {
            '<cmd>call writefile([expand("<cword>")], "/usr/share/words.txt", "a")<CR>',
            "Add word to LanguageTool dictionary",
        },
        ["<leader><Space>"] = { '<cmd>g/^/pu ="\n"<CR>', "Double space entire file" },
    }
end

-- ******************************** language server ---------------------------------------

function M.nvim_lsp()
    local lspmap = {
        K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["<F7>"] = { "<cmd>lua require('debugger').init()<CR>", "Initialize Debugger adapter" },
        [","] = {
            name = "Lsp functions",
            D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Jump to Declaration" },
            d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Jump to Definition" },
            i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Jump to Implementation" },
            r = { "<cmd>lua vim.lsp.buf.references({includeDeclaration = false})<CR>", "References" },
            t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Jump to Type definition" },
            s = { '<cmd>lua vim.lsp.buf.signature_help({popup_opts = {border = "double"}})<CR>', "Show signature" },
            R = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
            f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format buffer" },
            a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions for buffer" },
            c = {
                name = "Codelens",
                c = { "<cmd>lua vim.lsp.codelens.display()<CR>", "Display" },
                r = { "<cmd>lua vim.lsp.codelens.run()<CR>", "Run" },
                R = { "<cmd>lua vim.lsp.codelens.refresh()<CR>", "Refresh" },
                g = { "<cmd>lua vim.lsp.codelens.get()<CR>", "Fetch" },
            },
            l = {
                name = "Toggle diagnostics",
                v = { "<cmd>lua require'utils.diagnostics'.toggle_virtual_text()<CR>", "Virtual text" },
                s = { "<cmd>lua require'utils.diagnostics'.toggle_signs()<CR>", "Sings" },
                u = { "<cmd>lua require'utils.diagnostics'.toggle_underline()<CR>", "Underline" },
            },
            w = {
                name = "Workspace",
                a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder" },
                r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder" },
                l = {
                    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                    "List workspace folder",
                },
            },
        },
    }
    wk.register(lspmap, { buffer = 0 })

    local vmap = {
        [","] = {
            name = "Lsp visual mode",
            a = { "<cmd>lua vim.lsp.buf.range_code_action()<CR>", "Code actions for range" },
            f = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format range" },
        },
    }
    wk.register(vmap, { mode = "v", buffer = 0 })
    wk.register { ["<F1>"] = { "<cmd>TlistToggle<CR>", "Toggle Taglist" } }
end

function M.diagnostic()
    wk.register {
        [",ld"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Show line diagnostics" },
        ["[d"] = { '<cmd>lua vim.diagnostic.goto_prev{float = {border = "double"}}<CR>', "Show previous diagnostics" },
        ["]d"] = { '<cmd>lua vim.diagnostic.goto_next{float = {border = "double"}}<CR>', "Show next diagnostics" },
    }
end

-- ******************************** vim basic calls ---------------------------------------

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
                f = { "<cmd>tabnew ~/.config/nvim/plugin/plugins.vim<CR>", "Functions in vim" },
                r = { "<cmd>tabnew $MYVIMRC<CR>", "VimRC" },
                P = { "<cmd>PackerSync<CR>", "Update packages" },
                R = { "<cmd>lua require('utils').Restart()<CR>", "Reload Vim" },
            },
        },
    }
end

-- ******************************** Treesitter ---------------------------------------

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

-- ******************************** Telescope ---------------------------------------

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
            require("telescope.builtin").file_browser {
                prompt_title = prompt,
                cwd = cwd,
                attach_mappings = function(prompt_bufnr, map)
                    local change_dir =
                        -- vim.api.nvim_buf_call(bufnr, function(window) end)
                        function()
                            local wd = require("telescope.actions.state").get_selected_entry().value
                            require("telescope.actions.set").select(prompt_bufnr, "default")
                            if wd:sub(-1, -1) == require("plenary.path").path.sep then
                                vim.fn.execute("tcd " .. wd)
                            end
                        end
                    map("n", "<CR>", function()
                        change_dir()
                    end)
                    map("i", "<CR>", function()
                        change_dir()
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
                attach_mappings = function(prompt_bufnr, map)
                    local change_dir = function(window)
                        local wd = require("telescope.actions.state").get_selected_entry().value
                        require("telescope.actions.set").select(prompt_bufnr, window)
                        vim.fn.execute("tcd " .. cwd)
                        local dir = vim.fn.fnamemodify(wd, ":p:h")
                        vim.fn.execute("tcd " .. dir)
                    end
                    map("n", "<CR>", function()
                        change_dir "default"
                    end)
                    map("i", "<CR>", function()
                        change_dir "default"
                    end)
                    map("n", "<C-v>", function()
                        change_dir "vertical"
                    end)
                    map("i", "<C-v>", function()
                        change_dir "vertical"
                    end)
                    map("n", "<C-t>", function()
                        change_dir "tab"
                    end)
                    map("i", "<C-t>", function()
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
            ["'"] = { tele "registers", "Registers" },
            e = { tele "file_browser", "File browser" },
            c = { tele "commands", "Vim commands" },
            C = { tele "command_history", "Command history" },
            m = { tele "symbols", "Unicode characters" },
            T = { tele "tags", "Lsp Ctags" },
            t = { tele "treesitter", "TreeSitter nodes in buffer" },
            s = { tele "lsp_document_symbols", "Lsp symbols in buffer" },
            r = { tele "lsp_references", "Lsp References" },
            z = { tele "current_buffer_fuzzy_find", "Fuzzy find in buffer" },
            S = { tele "lsp_dynamic_workspace_symbols", "Grep lsp workspace symbols" },
            k = { telF "lsp_workspace_symbols({query = vim.fn.expand('<cword>')})", "Search lsp workspace symbol" },
            d = {
                name = "diagnostics",
                b = { tele "diagnostics", "buffer diagnostics" },
                w = { tele "diagnostics", "Workspace diagnostics" },
            },
            q = { tele "quickfix", "Quickfix list" },
            l = { tele "loclist", "local quickfix list" },
            g = {
                name = "Live grep in",
                o = {
                    telF "live_grep({cwd ='~/Documents/ofWorkspace/',prompt_title = 'oF Workspace grep'})",
                    "ofWorkspace",
                },
                b = { tele "live_grep", "current buffer" },
            },
            F = { tele "find_files", "Current directory" },
            f = {
                name = "find files in",
                f = { tele "find_files", "Current directory" },
                h = { telF "find_files({cwd='~'})", "Home directory" },
                d = { telF "find_files({cwd='~/.config/', prompt_title = 'Dotfiles'})", "Dotfiles" },
                r = { tele "oldfiles", "Vim recent files" },
                t = { tele "help_tags", "vim help files" },
                c = { cd_browser("C++ Practice files/dirs", "$CWORK/Practice"), "Open C practice" },
                C = { cd_files("C++ Practice files/dirs", "$CWORK/Practice"), "Open C practice" },
                b = {
                    telF "find_files({cwd='~/.local/bin/', prompt_title = 'Scripts and binaries in local'})",
                    "scripts & binaries",
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
            },
            G = {
                name = "git commands",
                b = { tele "git_branches", "Branches" },
                c = { tele "git_commits", "Commit history" },
                s = { tele "git_status", "Status" },
                f = { tele "git_files", "Tracked files" },
            },
            p = { telE "project.project{display_type = 'full'}", "Projects" },
            K = { telF 'live_grep({cwd = vim.fn.input("cwd: ")})', "Live grep in directory" },
            o = { cd_files("Org files", "~/Documents/Orgs"), "Org files" },
        },
    }
end

-- ******************************** Git ---------------------------------------
function M.git()
    local opts = { nowait = true, noremap = true, silent = false }
    local maps = {}
    u.maps(maps, opts)
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

-- ******************************** Snippets ---------------------------------------
function M.autoComplete()
    -- change completion mode
    Exec "imap <c-j> <Plug>(completion_next_source)"
    Exec "imap <c-k> <Plug>(completion_prev_source)"
    local maps = {
        ["<C-l>"] = { "<cmd>lua require('luasnip').jump(1)<cr>", "jump to next placeholder" },
        ["<C-h>"] = { "<cmd>lua require('luasnip').jump(-1)<cr>", "jump to prev placeholder" },
    }
    wk.register(maps, { mode = "i" })
    wk.register(maps, { mode = "s" })
end

-- ******************************** SuperCollider ---------------------------------------
function M.scnvim()
    Exec "nmap <buffer> <F5> <Plug>(scnvim-send-block)"
    Exec "nmap <buffer>,S <Plug>(scnvim-show-signature)"
    Exec "imap <buffer> <F5> <esc><Plug>(scnvim-send-block)"
    Exec "vmap <buffer> <F5> <Plug>(scnvim-send-selection)"
    Exec "nmap <buffer> <F6> <Plug>(scnvim-send-line)"
    Exec "imap <buffer> <F6> <esc><Plug>(scnvim-send-line)"

    local bufmaps = {
        ["<F1>"] = { "<cmd>SCNvimStart<cr>", "Launch Sclang" },
        ["<F2>"] = { "<cmd>SCNvimStatusLine<cr>", "Display server status" },
        ["<F3>"] = { '<cmd>call scnvim#sclang#send_silent("Server.local.boot")<CR>', "Boot local server" },
        ["<F4>"] = { '<cmd>call scnvim#sclang#send_silent("WFSLib.startup")<CR>', "Boot WFS server" },
        [";a"] = { "<cmd>call scnvim#util#echo_args()<cr>", "Echo arguments in commandline" },
        ["<leader>s"] = { "<cmd>tabnew ~/.config/SuperCollider/startup.scd<cr>", "open startup file" },
    }
    wk.register(bufmaps, { buffer = 0 })
end

-- ******************************** Arduino ---------------------------------------

function M.micro()
    local maps = {
        ["<F8>"] = { "<esc><cmd>lua require('utils.compiler').monitor()<CR>", "Serial monitor toggle" },
    }
    wk.register(maps, { mode = "t" })

    local mkeys = {
        ["<F2>"] = { "<cmd>lua require('utils.compiler').pio_clean()<CR>", "Regenerate tags" },
        ["<F3>"] = { "<cmd>lua require('utils.compiler').pio_check()<CR>", "Verify code" },
        ["<F5>"] = { "<cmd>w <CR>:Make<CR>", "Build" },
        ["<F6>"] = { "<cmd>w <CR>:Make --target upload<CR>", "Upload" },
        ["<F8>"] = { "<cmd>lua require('utils.compiler').monitor()<CR>", "Serial monitor toggle" },
        ["<leader>"] = {
            r = {
                name = "Online specs",
            },
        },
        [","] = {
            k = {
                a = { "<cmd>lua require('utils.compiler').ardRef(vim.fn.expand('<cword>'))<CR>", "Arduino" },
                t = { "<cmd>lua require('utils.compiler').teensypins()<CR>", "teensy pins" },
                T = { "<cmd>lua require('utils.compiler').teensyspecs()<CR>", "teensy specs" },
            },
        },
    }
    wk.register(mkeys, { buffer = 0 })
end

-- ******************************** cpp -openFrameworks ---------------------------------------

function M.makeC()
    local bufmaps = {
        ["<F4>"] = { "<cmd>w <CR> <cmd>Make Debug -j12<CR>", "Compile Debug" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -j12 && make RunRelease<CR>", "Compile Release" },
        ["<F6>"] = { "<cmd>w <CR> <cmd>Make RunRelease<CR>", "Run Release" },
    }
    wk.register(bufmaps, { buffer = 0 })
end

-- ******************************** Openframeworks Android ---------------------------------------

function M.makeGradle() end

-- ********************************  Simple C mappings ---------------------------------------

function M.ctests()
    local bufmaps = {
        ["<F3>"] = { "<cmd>w <CR> <cmd>Dispatch gcc % -lm -o %<<CR> <cmd>Dispatch ./%<<CR>", "Use gcc" },
        ["<F4>"] = { "<cmd>w <CR> <cmd>lua require('utils.compiler').with_flags()<cr>", "Make with defined flags" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -g % -o %<<CR>", "Make" },
        ["<F6>"] = { "<cmd>w <CR> <cmd>Dispatch ./%<<CR>", "Run binary" },
    }
    wk.register(bufmaps, { buffer = 0 })
end

-- PureData C Externals
function M.pdc()
    local bufmaps = {
        ["<F5>"] = { "<cmd>w<CR><cmd>Make<CR>", "Build Pd external" },
        ["<F6>"] = { "<cmd>w<CR><cmd>lua require('utils.compiler').pdBuild()<CR>", "Copy external to PD directory" },
    }
    wk.register(bufmaps, { buffer = 0 })
end

-- ******************************** General Clang mappings ---------------------------------------
function M.clang()
    local wmaps = {
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
                D = { "<cmd>CclsDerivedHierarchy -float<CR>", "Derived functions" },
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
    }
    wk.register(wmaps, { buffer = 0 })
end

-- ******************************** CMake ---------------------------------------

function M.cmake()
    local bufmaps = {
        ["<F2>"] = { '<cmd>w <CR> <cmd>lua require("utils.compiler").cmake_clean()<CR>', "Clean cmake" },
        ["<F3>"] = { '<cmd>w <CR> <cmd>lua require("utils.compiler").cmake_gen_debug()<CR>', "Generate Cmake Debug" },
        ["<F4>"] = { '<cmd>w <CR> <cmd>lua require("utils.compiler").cmake_gen()<CR>', "Generate Cmake Release" },
        ["<F5>"] = { "<cmd>w <CR> <cmd>Make -j12 -C build<CR>", "Make" },
        ["<F6>"] = { '<cmd>w <CR> <cmd>lua require("utils.compiler").cmake_run()<cr>', "Launch binary" },
    }
    wk.register(bufmaps, { buffer = 0 })
end

-- ******************************** CoAuthor ---------------------------------------

function M.coauthor()
    wk.register {
        ["<leader>"] = {
            i = {
                name = "Co-Authoring",
                i = { "<cmd>lua require('utils').Start()<CR>", "Start server" },
                s = { "<cmd>lua require('utils').Session()<CR>", "Launch session" },
                b = { "<cmd>lua require('utils').Single()<CR>", "Launch current buffer" },
                j = { "<cmd>lua require('utils').JoinSession()<CR>", "Join session" },
                J = { "<cmd>lua require('utils').JoinSingle()<CR>", "Join single buffer" },
                f = { "<cmd>lua require('utils').Follow()<CR>", "follow user" },
            },
        },
    }
end

-- ******************************** debug ---------------------------------------
function M.debug()
    wk.register({
        ["<leader>"] = {
            d = {
                name = "debug",
                b = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "set breakpoint" },
                x = { "<cmd>lua require('dap').set_exception_breakpoints()<CR>", "set breakpoint" },
                o = { "<cmd>lua require('dapui').float_element()<CR>", "Open floating features" },
                f = { "<cmd>lua require('dapui').float_element('scopes', {enter = true})<CR>", "Floating Scopes" },
                e = { "<cmd>lua require('dapui').eval()<CR><cmd>lua require('dapui').eval()<CR>", "Evaluate Hover" },
                E = { "<cmd>lua require('debugger').exp()<CR>", "Expressions" },
                F = { "<cmd>lua require('dapui').float_element('stacks', {enter = true})<CR>", "Floating Stacks" },
                B = {
                    "<cmd>lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
                    "set breakpoint",
                },
            },
        },
    }, { buffer = 0 })
    wk.register {
        ["<leader>d"] = {
            name = "debug",
            ["."] = { "<cmd>lua require('dap').close()<CR>", "End" },
            ["?"] = { "<cmd>lua require('debugger').frames()<CR>", "Frames" },
            ["/"] = { "<cmd>lua require('debugger').scopes()<CR>", "Scopes" },
            u = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle all UI" },
            c = { "<cmd>lua require('dap').continue()<CR>", "continue to next breakpoint" },
            n = { "<cmd>lua require('dap').step_over()<CR>", "step over" },
            s = { "<cmd>lua require('dap').step_into()<CR>", "step into" },
            S = { "<cmd>lua require('dap').step_out()<CR>", "step Out" },
        },
        ["<F10>"] = { "<cmd>lua require('dap').repl.toggle({height = 10},'split')<CR>", "Repl Toggle" },
    }
    wk.register({
        ["<leader>"] = {
            d = {
                e = { "<cmd>lua require('dapui').eval()<CR><cmd>lua require('dapui').eval()<CR>", "Evaluate" },
                o = { "<cmd>lua require('dapui').float_element()<CR>", "Open floating elements" },
                E = { "<cmd>lua require('debugger').exp()<CR>", "Expressions" },
            },
        },
    }, { mode = "v", buffer = 0 })
end

-- ******************************** Latex ---------------------------------------
function M.tex()
    local bufmaps = {
        ["<F3>"] = { "<cmd>TexWordCount<CR>", "Word count" },
        ["<F4>"] = { "<cmd>Make -C<CR>", "Clean tex files" },
        ["<F5>"] = { "<cmd>TexlabBuild<CR>", "Compile tex document" },
        ["<F6>"] = { "<cmd>TexlabForward<CR>", "Launch zathura" },
    }
    wk.register(bufmaps, { buffer = 0 })
end

return M
