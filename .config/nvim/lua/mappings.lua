local M = {}
local u = require("utils")

-- ******************************** General functions ---------------------------------------

function M.general()
    M.edit_config_files()
    M.git()
    M.telescope()
    M.coauthor()

    local opts = {nowait = true, noremap = true, silent = false}
    local maps = {
        -- Window movement
        {"n", "<C-J>", "<C-W><C-J>"},
        {"n", "<C-K>", "<C-W><C-K>"},
        {"n", "<C-L>", "<C-W><C-L>"},
        {"n", "<C-H>", "<C-W><C-H>"},
        --line movement
        {"x", "K", ":move '<-2<CR>gv-gv"},
        {"x", "J", ":move '>+1<CR>gv-gv"},
		{"n", "gm", ":call cursor(0, virtcol('$')/2 )<CR>"},
        -- quickfix
        {"n", "-", ":copen<CR>"},
        {"n", "+", ":lopen<CR>"},
        {"n", "_", ":pclose | cclose | lclose<CR>"},
        -- visual cut for replase
        {"v", "<leader>p", '"_dP'},
        {"s", "<leader>p", '"_dP'},
        -- Indent
        {"v", "<", "<gv"},
        {"v", ">", ">gv"},
        -- Escape in terminal mode
        {"t", "<Esc>", "<C-\\><C-n>"},
        {"n", "<leader>ht", ":sp term://zsh<cr>"},
        {"n", "<leader>t", ":vspl term://zsh<cr>"},
        -- Treesitter basics
        {"n", ";K", ":TSHighlightCapturesUnderCursor<cr>"},
        {"n", ";P", ":TSPlaygroundToggle<cr>"},
        {"n", "<leader>fm", "gg=G<C-o>zz"}
    }
    u.maps(maps, opts)
end

-- ******************************** language server ---------------------------------------

function M.nvim_lsp()
    local opts = {noremap = true, silent = true}
    -- local pop_opts = {popup_opts = {border = "double"}}

    local bufmaps = {
        {"n", "<F1>", "<cmd>TlistToggle<CR>"},
        {"n", ",D", "<cmd>lua vim.lsp.buf.declaration()<CR>"},
        {"n", ",d", "<cmd>lua vim.lsp.buf.definition()<CR>"},
        {"n", ",i", "<cmd>lua vim.lsp.buf.implementation()<CR>"},
        {"n", ",t", "<cmd>lua vim.lsp.buf.type_definition()<CR>"},
        {"n", ",cc", "<cmd>lua vim.lsp.codelens.display()<CR>"},
        {"n", ",cr", "<cmd>lua vim.lsp.codelens.run()<CR>"},
        {"n", ",cR", "<cmd>lua vim.lsp.codelens.refresh()<CR>"},
        {"n", ",cg", "<cmd>lua vim.lsp.codelens.get()<CR>"},
        {"n", ",pd", "<cmd>lua require'utils'.peek_definition()<CR>"},
        {"n", ",s", '<cmd>lua vim.lsp.buf.signature_help({popup_opts = {border = "rounded"}})<CR>'},
        {"n", "[d", '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "double"}, focusable = false})<CR>'},
        {"n", "]d", '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "double"}, focusable = false})<CR>'},
        {"n", ",ld", '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({popup_opts = {border = "double"}, focusable = false})<CR>'},
        {"n", ",R", "<cmd>lua vim.lsp.buf.rename()<CR>"},
        {"n", ",ff", "<cmd>lua vim.lsp.buf.formatting()<CR>"},
        {"n", ",ac", "<cmd>lua vim.lsp.buf.code_action()<CR>"},
        {"v", ",ac", "<cmd>lua vim.lsp.buf.range_code_action()<CR>"},
        {"v", ",ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>"},
        {"n", ",ll", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>"},
        {"n", ",lv", "<cmd>lua require'utils'.virtDiagnostics.toggle()<CR>"},
        {"n", ",wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>"},
        {"n", ",wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>"},
        {"n", ",wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"}
    }

    u.bufmaps(bufmaps, opts)
end

-- ******************************** vim basic calls ---------------------------------------

function M.edit_config_files()
    local open_func = "tabnew"
    local opts = {nowait = true, noremap = true, silent = true}
    local maps = {
        {"n", "<leader>aR", "<cmd>lua require('utils').Restart()<CR>"},
        {"n", "<leader>aP", "<cmd>PackerSync<CR>"},
        {"n", "<leader>am", ":" .. open_func .. " ~/.config/nvim/lua/mappings.lua<CR>"},
        {"n", "<leader>al", ":" .. open_func .. " ~/.config/nvim/lua/settings.lua<CR>"},
        {"n", "<leader>ap", ":" .. open_func .. " ~/.config/nvim/lua/plugins.lua<CR>"},
        {"n", "<leader>as", ":" .. open_func .. " ~/.config/nvim/lua/statusline.lua<CR>"},
        {"n", "<leader>ac", ":" .. open_func .. " ~/.config/nvim/lua/compiler.lua<CR>"},
        {"n", "<leader>au", ":" .. open_func .. " ~/.config/nvim/lua/utils/init.lua<CR>"},
        {"n", "<leader>ar", ":" .. open_func .. " $MYVIMRC<CR>"}
    }

    u.maps(maps, opts)
end

-- ******************************** Telescope ---------------------------------------

function M.telescope()
    local tele = function(name)
        return string.format(":lua require('telescope.builtin').%s()<cr>", name)
    end
    local telF = function(name)
        return string.format(":lua require('telescope.builtin').%s<cr>", name)
    end
    local telE = function(name)
        return string.format(":lua require'telescope'.extensions.%s<cr>", name)
    end
    -- local follow_links = {
    -- 	cwd = vim.loop.cwd(),
    -- 	follow = true,
    -- }

    local opts = {nowait = true, noremap = true, silent = true}
    local maps = {
        -- Switch buffers
        {"n", "<space>b", tele("buffers")},
        -- Fuzzy find files in cwd
        {"n", "<space>f", tele("find_files")},
        -- Oldfiles
        {"n", "<space>rf", tele("oldfiles")},
        -- Help tags
        {"n", "<space>ht", tele("help_tags")},
        -- registers list
        {"n", '<space>"', tele("registers")},
        -- File explorer
        {"n", "<space>e", tele("file_browser")},
        -- commands explorer
        {"n", "<space>c", tele("commands")},
        -- commands history
        {"n", "<space>C", tele("command_history")},
        -- Unicode
        {"n", "<space>m", tele("symbols")},
        -- openFrameworks and other projects
        {"n", "<space>p", telE("project.project{display_type = 'full'}")},
        -- Ctags
        {"n", "<space>T", tele("tags")},
        -- TS symbols
        {"n", "<space>t", tele("treesitter")},
        -- References under cursor
        {"n", ",r", tele("lsp_references")},
        -- document symbol
        {"n", "<space>s", tele("lsp_document_symbols")},
        -- document symbol
        {"n", "<space>S", tele("lsp_dynamic_workspace_symbols")},
        -- Document diagnostics
        {"n", "<space>dd", tele("lsp_document_diagnostics")},
        -- Workspace diagnostics
        {"n", "<space>D", tele("lsp_workspace_diagnostics")},
        -- Quickfix list
        {"n", "<space>q", tele("quickfix")},
        -- Location list
        {"n", "<space>l", tele("loclist")},
        -- live grep
        {"n", "<space>G", tele("live_grep")},
        -- git branches
        {"n", "<space>gb", tele("git_branches")},
        -- git commits
        {"n", "<space>gc", tele("git_commits")},
        -- git status
        {"n", "<space>gs", tele("git_status")},
        -- git files
        {"n", "<space>gf", tele("git_files")},
        --  Serach HOME
        {"n", "<space>hf", telF("find_files({cwd='~'})")},
        --  Serach dotfiles
        {"n", "<space>df", telF("find_files({cwd='~/.config/'})")},
        -- Search plugins
        {"n", "<space>vf", telF("find_files({cwd='~/.local/share/nvim/'})")},
        -- Custom workfolder
        {"n", "<space>K", telF('live_grep({cwd = vim.fn.input("cwd: ")})')},
        -- Workspace symbol under cursor
        {"n", "<space>k", telF("lsp_workspace_symbols({query = vim.fn.expand('<cword>')})")},
        -- find-files ofProjects
        {"n", "<space>of", telF("find_files({cwd ='~/Documents/ofWorkspace/',follow = true,})")}
    }
    u.maps(maps, opts)
end

-- ******************************** Git ---------------------------------------

-- fugitive mappings
function M.git()
    local opts = {nowait = true, noremap = true, silent = false}
    local maps = {
        {"n", "<leader>gg", ":G<cr>"},
        {"n", "<leader>gc", ":Git commit %<cr>"},
        {"n", "<leader>ga", ":Git add %<cr>"},
        {"n", "<leader>gd", ":Git difftool<cr>"},
        {"n", "<leader>gb", ":Git blame<cr>"},
        {"n", "<leader>gp", ":Gitsigns preview_hunk<cr>"},
        {"n", "<leader>gs", ":Gitsigns stage_hunk<cr>"},
        {"n", "<leader>gP", ":Git push<cr>"},
        {"n", "<leader>gf", ":Git fetch<cr>"},
        {"n", "<leader>gl", ":Gclog<cr>"},
        {"n", "]h", ":Gitsigns next_hunk<cr>:Gitsigns preview_hunk<CR>"},
        {"n", "[h", ":Gitsigns prev_hunk<cr>:Gitsigns preview_hunk<CR>"}
    }

    u.maps(maps, opts)
end

-- When in a git commit window
function M.git_commit()
    local opts = {nowait = true, noremap = true, silent = false}
    local bufmaps = {
        {"n", "<C-e>", ":wq<cr>"},
        {"i", "<C-e>", "<esc>:wp<cr>"}
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** Snippets ---------------------------------------
function M.autoComplete()
    -- change completion mode
    Cmd("imap <c-j> <Plug>(completion_next_source)")
    Cmd("imap <c-k> <Plug>(completion_prev_source)")
    --vsnip commapds
    --expand
    Cmd('imap <expr> <C-h> vsnip#expandable() ? "<Plug>(vsnip-expand)"  : "<C-h>"')
    Cmd('smap <expr> <C-h> vsnip#expandable() ? "<Plug>(vsnip-expand)"  : "<C-h>"')
    --expand or jump
    Cmd('imap <expr> <C-l> vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-l>"')
    Cmd('smap <expr> <C-l> vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-l>"')
    --Plugs
    Cmd("nmap  s  <Plug>(vsnip-select-text)")
    Cmd("xmap  s  <Plug>(vsnip-select-text)")
    Cmd("nmap  S  <Plug>(vsnip-cut-text)")
    Cmd("xmap  S  <Plug>(vsnip-cut-text)")
end

-- ******************************** SuperCollider ---------------------------------------
function M.scnvim()
    local opts = {nowait = true, noremap = true, silent = true}

    Cmd("nmap <buffer> <F5> <Plug>(scnvim-send-block)")
    Cmd("nmap <buffer>,S <Plug>(scnvim-show-signature)")
    Cmd("imap <buffer> <F5> <esc><Plug>(scnvim-send-block)")
    Cmd("vmap <buffer> <F5> <Plug>(scnvim-send-selection)")
    Cmd("nmap <buffer> <F6> <Plug>(scnvim-send-line)")
    Cmd("imap <buffer> <F6> <esc><Plug>(scnvim-send-line)")
    -- Buffer local mappings:
    local bufmaps = {
        -- Start language
        {"n", "<F1>", ":SCNvimStart<cr>"},
        -- SCNvimStatusLine
        {"n", "<F2>", ":SCNvimStatusLine<cr>"},
        -- Recompile
        {"n", "<leader>sk", ":SCNvimRecompile<cr>"},
        -- Start scsynth
        {"n", "<F3>", ':call scnvim#sclang#send_silent("Server.local.boot")<CR>'},
        --Start WFSCollider
        {"n", "<F4>", ':call scnvim#sclang#send_silent("WFSLib.startup")<CR>'},
        -- Echo args
        -- {'n', ';a', ':call scnvim#util#args_popup_toggle()<cr>'},
        {"n", ";a", ":call scnvim#util#echo_args()<cr>"},
        -- Regenerate Ctags
        {"n", "<leader>rt", ":SCNvimTags<cr>"},
        -- Edit startup file
        {"n", "<leader>es", ":tabnew ~/.config/SuperCollider/startup.scd<cr>"}
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** Arduino ---------------------------------------

function M.smbc()
    local opts = {nowait = true, noremap = true, silent = true}
    local bufmaps = {
        -- Show documentation
        {"n", "<F2>", ":ArduinoRef<CR>"},
        -- Print arduino board
        {"n", "<F3>", ":PioEnv<CR>"},
        -- Clean directory
        {"n", "<F4>", ":PioClean<CR>"},
        -- Build arduino project
        {"n", "<F5>", ":w <CR>:Make<CR>"},
        -- Upload arduino project
        {"n", "<F6>", ":w <CR>:Make --target upload<CR>"},
        -- Print arduino board
        {"n", "<F7>", ":PioCheck<CR>"},
        -- Monitor arduino output
        {"n", "<F8>", ":PioMonitor<CR>"},
        -- Compile tags & link it
        {"n", "<leader>rt", ":PioCompiledb<CR>"},
        -- Show teensy pins image
        {"n", "<leader>rp", ":TeensyPinout<CR>"},
        -- Show teensy specs image
        {"n", "<leader>rs", ":TeensySpecs<CR>"}
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** cpp -openFrameworks ---------------------------------------

function M.makeC()
    local opts = {nowait = true, noremap = true, silent = true}
    local bufmaps = {
        -- Compile Debug openFrameworks
        {"n", "<F4>", ":w <CR> :Make Debug -j12<CR>"},
        -- Compile openFrameworks
        {"n", "<F5>", ":w <CR> :Make -j12 && make RunRelease<CR>"},
        -- run openFrameworks
        {"n", "<F6>", ":w <CR> :Make RunRelease<CR>"}
    }
    u.bufmaps(bufmaps, opts)
end

-- ********************************  Simple C mappings ---------------------------------------

function M.ctests()
    local opts = {nowait = true, noremap = true, silent = true}
    local bufmaps = {
        -- Compile c file, avoid preprocessor errors
        {"n", "<F4>", ":w <CR> :Dispatch gcc % -lm -o %<<CR> :Dispatch ./%<<CR>"},
        -- Compile cpp file
        {"n", "<F5>", ":w <CR> :Make -g % -o %<<CR>"},
        -- Run binary
        {"n", "<F6>", ":w <CR> :Dispatch ./%<<CR>"}
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** General Clang mappings ---------------------------------------
function M.clang()
    local opts = {nowait = true, noremap = true, silent = true}

    local bufmaps = {
        -- Switch source header
        {"n", "<leader>s", ":ClangdSwitchSourceHeader<CR>"},
        -- bases
        {"n", ";b", ":CclsBase<CR>"},
        --   bases of up to 3 levels
        {"n", ";B", ":CclsBaseHierarchy -float<CR>"},
        --   derived
        {"n", ";hd", ":CclsDerived<CR>"},
        --   derived of up to 3 levels
        {"n", ";hD", ":CclsDerivedHierarchy -float<CR>"},
        -- caller
        {"n", ";c", ":CclsCallers<CR>"},
        -- caller Hierarchy
        {"n", ";hc", ":CclsCallHierarchy -float<CR>"},
        -- callee
        {"n", ";C", ":CclsCallees<CR>"},
        -- callee Hierarchy
        {"n", ";hC", ":CclsCalleeHierarchy -float<CR>"},
        -- Members
        {"n", ";m", ":CclsMemberHierarchy -float<CR>"},
        -- memberFunction
        {"n", ";f", ":CclsMemberFunctionHierarchy -float<CR>"},
        -- memberTypes
        {"n", ";t", ":CclsMemberTypeHierarchy -float<CR>"},
        -- variables
        {"n", ";v", ":CclsVars<CR>"},
		-- open makefile
		{"n", "<leader>m", "<cmd>lua require('compiler').makefile(vim.g.makeFile)<CR>"}
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** CMake ---------------------------------------

function M.cmake()
    local opts = {nowait = true, noremap = true, silent = false}
    local bufmaps = {
        -- Clean build
        {"n", "<F2>", ':w <CR> :lua require("compiler").cmake_clean()<CR>'},
        -- Build debug
        {"n", "<F3>", ':w <CR> :lua require("compiler").cmake_gen_debug()<CR>'},
        -- Build Cmake
        {"n", "<F4>", ':w <CR> :lua require("compiler").cmake_gen()<CR>'},
        -- run Make
        {"n", "<F5>", ":w <CR> :Make -j12 -C build<CR>"},
        -- Dispatch run
        {"n", "<F6>", 'w <CR> :lua require("compiler").cmake_run()<cr>'},
        -- Dispatch install
        {"n", "<F7>", 'w <CR> :lua require("compiler").cmake_install()<cr>'},
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** CoAuthor ---------------------------------------

function M.coauthor()
    local opts = {nowait = true, noremap = true, silent = false}
    local maps = {
        -- Start server
        {"n", "<leader>ii", "<cmd>lua require('utils').Start()<CR>"},
        -- Start session
        {"n", "<leader>is", "<cmd>lua require('utils').Session()<CR>"},
        -- Start buffer
        {"n", "<leader>ib", "<cmd>lua require('utils').Single()<CR>"},
        -- Join session
        {"n", "<leader>ij", "<cmd>lua require('utils').JoinSession()<CR>"},
        -- Join buffer
        {"n", "<leader>iJ", "<cmd>lua require('utils').JoinSingle()<CR>"},
        -- Follow user
        {"n", "<leader>if", "<cmd>lua require('utils').Follow()<CR>"}
    }
    u.maps(maps, opts)
end

return M
