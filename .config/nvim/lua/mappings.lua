local M = {}
local u = require "utils"

-- ******************************** General functions ---------------------------------------

function M.general()
    M.configFiles()
    M.git()
    M.telescope()
    M.coauthor()

    local opts = { nowait = true, noremap = true, silent = true }
    local maps = {
        { "n", "n", "nzzzv" },
        { "n", "N", "Nzzzv" },
        { "n", "J", "mzJ`z" },
        -- Window movement
        { "n", "<C-J>", "<C-W><C-J>" },
        { "n", "<C-K>", "<C-W><C-K>" },
        { "n", "<C-L>", "<C-W><C-L>" },
        { "n", "<C-H>", "<C-W><C-H>" },
        --line movement
        { "x", "K", ":move '<-2<CR>gv-gv" },
        { "x", "J", ":move '>+1<CR>gv-gv" },
        { "n", "gm", ":call cursor(0, virtcol('$')/2 )<CR>" },
        -- quickfix
        { "n", "-", ":lua require('utils.qf').toggle_qf('q')<CR>" },
        { "n", "_", ":lua require('utils.qf').toggle_qf('l')<CR>" },
        -- visual cut for replase
        { "v", "<leader>p", '"_dP' },
        { "s", "<leader>p", '"_dP' },
        -- Indent
        { "v", "<", "<gv" },
        { "v", ">", ">gv" },
        -- Terminal
        { "t", "<Esc>", "<C-\\><C-n>" },
        { "n", "<leader>ht", ":sp term://zsh<cr>" },
        { "n", "<leader>t", ":vspl term://zsh<cr>" },
        { "n", "<F9>", "<cmd>lua require('utils').toggleTerm('zsh','shell',1)<cr>" },
        { "t", "<F9>", "<esc><cmd>lua require('utils').toggleTerm('zsh','shell',1)<cr>" },
        -- { "n", "<leader>e", "<cmd>NvimTreeToggle<CR>" },
        -- Treesitter basics
        { "n", ";K", ":TSHighlightCapturesUnderCursor<cr>" },
        { "n", ";P", ":TSPlaygroundToggle<cr>" },
        { "n", "<leader>fm", "gg=G<C-o>zz" },
    }
    u.maps(maps, opts)

    --Conditional changes
    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "org" then
        local cmaps = {
            { "n", "<Tab>", "za" },
            { "n", "<S-Tab>", "zA" },
        }
        u.maps(cmaps, opts)
    end
end

-- ******************************** language server ---------------------------------------

function M.nvim_lsp()
    local opts = { noremap = true, silent = true }

    local bufmaps = {
        { "n", "<F1>", "<cmd>TlistToggle<CR>" },
        { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" },
        { "n", ",D", "<cmd>lua vim.lsp.buf.declaration()<CR>" },
        { "n", ",d", "<cmd>lua vim.lsp.buf.definition()<CR>" },
        { "n", ",i", "<cmd>lua vim.lsp.buf.implementation()<CR>" },
        { "n", ",t", "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
        { "n", ",cc", "<cmd>lua vim.lsp.codelens.display()<CR>" },
        { "n", ",cr", "<cmd>lua vim.lsp.codelens.run()<CR>" },
        { "n", ",cR", "<cmd>lua vim.lsp.codelens.refresh()<CR>" },
        { "n", ",cg", "<cmd>lua vim.lsp.codelens.get()<CR>" },
        { "n", ",s", '<cmd>lua vim.lsp.buf.signature_help({popup_opts = {border = "double"}})<CR>' },
        { "n", ",ld", '<cmd>lua vim.diagnostic.show_line_diagnostics({popup_opts = {border = "double"}})<CR>' },
        { "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({focusable = false, popup_opts = {border = "double"}} )<CR>' },
        { "n", "]d", '<cmd>lua vim.diagnostic.goto_next({focusable = false, popup_opts = {border = "double"}})<CR>' },
        { "n", ",R", "<cmd>lua vim.lsp.buf.rename()<CR>" },
        { "n", ",ff", "<cmd>lua vim.lsp.buf.formatting()<CR>" },
        { "n", ",ac", "<cmd>lua vim.lsp.buf.code_action()<CR>" },
        { "v", ",ac", "<cmd>lua vim.lsp.buf.range_code_action()<CR>" },
        { "v", ",ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>" },
        { "n", ",lv1", "<cmd>lua require'utils'.toggleVirt.toggle(1)<CR>" },
        { "n", ",lv2", "<cmd>lua require'utils'.toggleVirt.toggle(2)<CR>" },
        { "n", ",ls1", "<cmd>lua require'utils'.toggleSigns.toggle(1)<CR>" },
        { "n", ",ls2", "<cmd>lua require'utils'.toggleSigns.toggle(2)<CR>" },
        { "n", ",wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" },
        { "n", ",wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" },
        { "n", ",wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>" },
    }

    u.bufmaps(bufmaps, opts)
end

-- ******************************** vim basic calls ---------------------------------------

function M.configFiles()
    -- local opts = { nowait = true, noremap = true, silent = true }
    -- local maps = {
    --     { "n", "<leader>aP", "<cmd>PackerSync<CR>" },
    --     { "n", "<leader>aR", "<cmd>lua require('utils').Restart()<CR>" },
    --     { "n", "<leader>am", "<cmd>tabnew ~/.config/nvim/lua/mappings.lua<CR>" },
    --     { "n", "<leader>al", "<cmd>tabnew ~/.config/nvim/lua/settings.lua<CR>" },
    --     { "n", "<leader>ap", "<cmd>tabnew ~/.config/nvim/lua/plugins.lua<CR>" },
    --     { "n", "<leader>as", "<cmd>tabnew ~/.config/nvim/lua/statusline.lua<CR>" },
    --     { "n", "<leader>ac", "<cmd>tabnew ~/.config/nvim/lua/compiler.lua<CR>" },
    --     { "n", "<leader>au", "<cmd>tabnew ~/.config/nvim/lua/utils/init.lua<CR>" },
    --     { "n", "<leader>aa", "<cmd>tabnew ~/.config/nvim/autoload/util.vim<CR>" },
    --     { "n", "<leader>af", "<cmd>tabnew ~/.config/nvim/plugin/plugins.vim<CR>" },
    --     { "n", "<leader>ar", "<cmd>tabnew $MYVIMRC<CR>" },
    -- }

    -- u.maps(maps, opts)

    local wk = require "which-key"
    wk.register {
        ["<leader>"] = {
            a = {
                name = "vimrc files",
                p = { "<cmd>tabnew ~/.config/nvim/lua/plugins.lua<CR>", "Packer config" },
                m = { "<cmd>tabnew ~/.config/nvim/lua/mappings.lua<CR>", "Keymaps" },
                l = { "<cmd>tabnew ~/.config/nvim/lua/settings.lua<CR>", "Lua settings" },
                s = { "<cmd>tabnew ~/.config/nvim/lua/statusline.lua<CR>", "Statusline and Tabline" },
                c = { "<cmd>tabnew ~/.config/nvim/lua/compiler.lua<CR>", "Cpp Workstation" },
                u = { "<cmd>tabnew ~/.config/nvim/lua/utils/init.lua<CR>", "Utilities in lua" },
                a = { "<cmd>tabnew ~/.config/nvim/autoload/util.vim<CR>", "Utilities in autoload" },
                f = { "<cmd>tabnew ~/.config/nvim/plugin/plugins.vim<CR>", "Functions in vim" },
                r = { "<cmd>tabnew $MYVIMRC<CR>", "VimRC" },
                P = { "<cmd>PackerSync<CR>", "Update packages" },
                R = { "<cmd>lua require('utils').Restart()<CR>", "Reload Vim" },
            },
        },
    }
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

    local opts = { nowait = true, noremap = true, silent = true }
    local maps = {
        -- Switch buffers
        { "n", "<space>b", tele "buffers" },
        -- Fuzzy find files in cwd
        { "n", "<space>f", tele "find_files" },
        -- Oldfiles
        { "n", "<space>rf", tele "oldfiles" },
        -- Help tags
        { "n", "<space>ht", tele "help_tags" },
        -- registers list
        { "n", '<space>"', tele "registers" },
        -- File explorer
        { "n", "<space>e", tele "file_browser" },
        -- commands explorer
        { "n", "<space>c", tele "commands" },
        -- commands history
        { "n", "<space>C", tele "command_history" },
        -- Unicode
        { "n", "<space>m", tele "symbols" },
        -- openFrameworks and other projects
        { "n", "<space>p", telE "project.project{display_type = 'full'}" },
        -- Ctags
        { "n", "<space>T", tele "tags" },
        -- TS symbols
        { "n", "<space>t", tele "treesitter" },
        -- References under cursor
        { "n", ",r", tele "lsp_references" },
        -- document symbol
        { "n", "<space>s", tele "lsp_document_symbols" },
        -- document symbol
        { "n", "<space>S", tele "lsp_dynamic_workspace_symbols" },
        -- Document diagnostics
        { "n", "<space>dd", tele "lsp_document_diagnostics" },
        -- Workspace diagnostics
        { "n", "<space>D", tele "lsp_workspace_diagnostics" },
        -- Quickfix list
        { "n", "<space>q", tele "quickfix" },
        -- Location list
        { "n", "<space>l", tele "loclist" },
        -- live grep
        { "n", "<space>G", tele "live_grep" },
        -- git branches
        { "n", "<space>gb", tele "git_branches" },
        -- git commits
        { "n", "<space>gc", tele "git_commits" },
        -- git status
        { "n", "<space>gs", tele "git_status" },
        -- git files
        { "n", "<space>gf", tele "git_files" },
        --  Serach HOME
        { "n", "<space>hf", telF "find_files({cwd='~'})" },
        -- Custom workfolder
        { "n", "<space>K", telF 'live_grep({cwd = vim.fn.input("cwd: ")})' },
        -- Workspace symbol under cursor
        { "n", "<space>k", telF "lsp_workspace_symbols({query = vim.fn.expand('<cword>')})" },
        --  Serach dotfiles
        { "n", "<space>df", telF "find_files({cwd='~/.config/', prompt_title = 'Dotfiles'})" },
        -- Search plugins
        { "n", "<space>vf", telF "find_files({cwd='~/.local/share/nvim/', prompt_title = 'Plugin files'})" },
        -- find-files ofProjects
        { "n", "<space>of", telF "find_files({cwd ='~/Documents/ofWorkspace/',prompt_title = 'oF Workspace files'})" },
        -- find-files ofProjects
        { "n", "<space>oo", telF "find_files({cwd ='~/Documents/Orgs/',prompt_title = 'Org Files'})" },
        -- livegrep ofWorkspace
        { "n", "<space>og", telF "live_grep({cwd ='~/Documents/ofWorkspace/',prompt_title = 'oF Workspace grep'})" },
    }
    u.maps(maps, opts)
end

-- ******************************** Git ---------------------------------------

-- fugitive mappings
function M.git()
    local opts = { nowait = true, noremap = true, silent = false }
    local maps = {
        { "n", "<leader>gg", ":G<cr>" },
        { "n", "<leader>gc", ":G commit<cr>" },
        { "n", "<leader>gC", ":G commit %<cr>" },
        { "n", "<leader>ga", ":G add %<cr>" },
        { "n", "<leader>gd", ":G difftool<cr>" },
        { "n", "<leader>gb", ":G blame<cr>" },
        { "n", "<leader>gp", ":Gitsigns preview_hunk<cr>" },
        { "n", "<leader>gs", ":Gitsigns stage_hunk<cr>" },
        { "n", "<leader>gP", ":G push<cr>" },
        { "n", "<leader>gL", ":Gclog<cr>" },
        { "n", "<leader>gl", ":G log<cr>" },
        { "n", "]h", ":Gitsigns next_hunk<cr>:Gitsigns preview_hunk<CR>" },
        { "n", "[h", ":Gitsigns prev_hunk<cr>:Gitsigns preview_hunk<CR>" },
    }

    u.maps(maps, opts)
end

-- ******************************** Snippets ---------------------------------------
function M.autoComplete()
    -- change completion mode
    Exec "imap <c-j> <Plug>(completion_next_source)"
    Exec "imap <c-k> <Plug>(completion_prev_source)"
    --vsnip commapds
    --expand
    Exec 'imap <expr> <C-h> vsnip#expandable() ? "<Plug>(vsnip-expand)"  : "<C-h>"'
    Exec 'smap <expr> <C-h> vsnip#expandable() ? "<Plug>(vsnip-expand)"  : "<C-h>"'
    --expand or jump
    Exec 'imap <expr> <C-l> vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-l>"'
    Exec 'smap <expr> <C-l> vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-l>"'
    --Plugs
    Exec "nmap  s  <Plug>(vsnip-select-text)"
    Exec "xmap  s  <Plug>(vsnip-select-text)"
    Exec "nmap  S  <Plug>(vsnip-cut-text)"
    Exec "xmap  S  <Plug>(vsnip-cut-text)"
end

-- ******************************** SuperCollider ---------------------------------------
function M.scnvim()
    local opts = { nowait = true, noremap = true, silent = true }

    Exec "nmap <buffer> <F5> <Plug>(scnvim-send-block)"
    Exec "nmap <buffer>,S <Plug>(scnvim-show-signature)"
    Exec "imap <buffer> <F5> <esc><Plug>(scnvim-send-block)"
    Exec "vmap <buffer> <F5> <Plug>(scnvim-send-selection)"
    Exec "nmap <buffer> <F6> <Plug>(scnvim-send-line)"
    Exec "imap <buffer> <F6> <esc><Plug>(scnvim-send-line)"
    -- Buffer local mappings:
    local bufmaps = {
        -- Start language
        { "n", "<F1>", ":SCNvimStart<cr>" },
        -- SCNvimStatusLine
        { "n", "<F2>", ":SCNvimStatusLine<cr>" },
        -- Recompile
        { "n", "<leader>sk", ":SCNvimRecompile<cr>" },
        -- Start scsynth
        { "n", "<F3>", ':call scnvim#sclang#send_silent("Server.local.boot")<CR>' },
        --Start WFSCollider
        { "n", "<F4>", ':call scnvim#sclang#send_silent("WFSLib.startup")<CR>' },
        -- Echo args
        { "n", ";a", ":call scnvim#util#echo_args()<cr>" },
        -- Regenerate Ctags
        { "n", "<leader>rt", ":SCNvimTags<cr>" },
        -- Edit startup file
        { "n", "<leader>es", ":tabnew ~/.config/SuperCollider/startup.scd<cr>" },
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** Arduino ---------------------------------------

function M.smbc()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Show documentation
        { "n", "<F2>", ":lua require('compiler').arduinoref()<CR>" },
        -- Print arduino board
        { "n", "<F3>", ":lua require('compiler').print_env()<CR>" },
        -- Clean directory
        { "n", "<F4>", ":lua require('compiler').print_clean()<CR>" },
        -- Build arduino project
        { "n", "<F5>", ":w <CR>:Make<CR>" },
        -- Upload arduino project
        { "n", "<F6>", ":w <CR>:Make --target upload<CR>" },
        -- Print arduino board
        { "n", "<F7>", ":lua require('compiler').pio_check()<CR>" },
        -- Monitor arduino output
        { "n", "<F8>", ":lua require('compiler').monitor()<CR>" },
        -- Compile tags & link it
        { "n", "<leader>rt", ":lua require('compiler').compiletags()<CR>" },
        -- Show teensy pins image
        { "n", "<leader>rp", ":lua require('compiler').teensypins()<CR>" },
        -- Show teensy specs image
        { "n", "<leader>rs", ":lua require('compiler').teensyspecs()<CR>" },
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** cpp -openFrameworks ---------------------------------------

function M.makeC()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Compile Debug openFrameworks
        { "n", "<F4>", ":w <CR> :Make Debug -j12<CR>" },
        -- Compile openFrameworks
        { "n", "<F5>", ":w <CR> :Make -j12 && make RunRelease<CR>" },
        -- run openFrameworks
        { "n", "<F6>", ":w <CR> :Make RunRelease<CR>" },
        -- Call gdb (termdebug)
        { "n", "<F7>", 'w <CR> :lua require("compiler").termdebug()<cr>' },
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** Openframeworks Android ---------------------------------------

function M.makeGradle()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Compile Debug openFrameworks
        -- { "n", "<F4>", ":w <CR> :Make Debug -j12<CR>" },
        -- Compile openFrameworks
        { "n", "<F5>", ":w <CR> :Make<CR>" },
        -- run openFrameworks
        { "n", "<F6>", ":w <CR> :Dispatch make RunRelease<CR>" },
        -- Call gdb (termdebug)
        { "n", "<F7>", 'w <CR> :lua require("compiler").termdebug()<cr>' },
    }
    u.bufmaps(bufmaps, opts)
end

-- ********************************  Simple C mappings ---------------------------------------

function M.ctests()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Compile c file, avoid preprocessor errors
        { "n", "<F4>", ":w <CR> :Dispatch gcc % -lm -o %<<CR> :Dispatch ./%<<CR>" },
        -- Compile cpp file
        { "n", "<F5>", ":w <CR> :Make -g % -o %<<CR>" },
        -- Run binary
        { "n", "<F6>", ":w <CR> :Dispatch ./%<<CR>" },
        -- Dispatch install
        { "n", "<F7>", 'w <CR> :lua require("compiler").termdebug()<cr>' },
    }
    u.bufmaps(bufmaps, opts)
end

-- PureData C Externals
function M.pdc()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Compile c file, avoid preprocessor errors
        -- { "n", "<F4>", ":w <CR> :Dispatch gcc % -lm -o %<<CR> :Dispatch ./%<<CR>" },
        -- Compile cpp file
        { "n", "<F5>", ":w<CR>:Make<CR>" },
        -- Copy binary
        { "n", "<F6>", ":w<CR><cmd>lua require('compiler').pdBuild()<CR>" },
        -- Dispatch install
        -- { "n", "<F7>", 'w <CR> :lua require("compiler").termdebug()<cr>' },
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** General Clang mappings ---------------------------------------
function M.clang()
    local opts = { nowait = true, noremap = true, silent = true }

    local bufmaps = {
        -- Switch source header
        { "n", "<leader>s", ":ClangdSwitchSourceHeader<CR>" },
        -- open cpp reference
        { "n", ",K", "<cmd>lua require('compiler').creference(vim.fn.expand('<cword>'))<CR>" },
        -- bases
        { "n", ";b", ":CclsBase<CR>" },
        --   bases of up to 3 levels
        { "n", ";B", ":CclsBaseHierarchy -float<CR>" },
        --   derived
        { "n", ";hd", ":CclsDerived<CR>" },
        --   derived of up to 3 levels
        { "n", ";hD", ":CclsDerivedHierarchy -float<CR>" },
        -- caller
        { "n", ";c", ":CclsCallers<CR>" },
        -- caller Hierarchy
        { "n", ";hc", ":CclsCallHierarchy -float<CR>" },
        -- callee
        { "n", ";C", ":CclsCallees<CR>" },
        -- callee Hierarchy
        { "n", ";hC", ":CclsCalleeHierarchy -float<CR>" },
        -- Members
        { "n", ";m", ":CclsMemberHierarchy -float<CR>" },
        -- memberFunction
        { "n", ";f", ":CclsMemberFunctionHierarchy -float<CR>" },
        -- memberTypes
        { "n", ";t", ":CclsMemberTypeHierarchy -float<CR>" },
        -- variables
        { "n", ";v", ":CclsVars<CR>" },
        -- open makefile
        { "n", "<leader>m", "<cmd>lua require('compiler').makefile(vim.g.makeFile)<CR>" },
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** CMake ---------------------------------------

function M.cmake()
    local opts = { nowait = true, noremap = true, silent = false }
    local bufmaps = {
        -- Clean build
        { "n", "<F2>", ':w <CR> :lua require("compiler").cmake_clean()<CR>' },
        -- Build debug
        { "n", "<F3>", ':w <CR> :lua require("compiler").cmake_gen_debug()<CR>' },
        -- Build Cmake
        { "n", "<F4>", ':w <CR> :lua require("compiler").cmake_gen()<CR>' },
        -- run Make
        { "n", "<F5>", ":w <CR> :Make -j12 -C build<CR>" },
        -- Dispatch run
        { "n", "<F6>", 'w <CR> :lua require("compiler").cmake_run()<cr>' },
        -- Dispatch install
        { "n", "<F7>", 'w <CR> :lua require("compiler").termdebug()<cr>' },
    }
    u.bufmaps(bufmaps, opts)
end

-- ******************************** CoAuthor ---------------------------------------

function M.coauthor()
    local opts = { nowait = true, noremap = true, silent = false }
    local maps = {
        -- Start server
        { "n", "<leader>ii", "<cmd>lua require('utils').Start()<CR>" },
        -- Start session
        { "n", "<leader>is", "<cmd>lua require('utils').Session()<CR>" },
        -- Start buffer
        { "n", "<leader>ib", "<cmd>lua require('utils').Single()<CR>" },
        -- Join session
        { "n", "<leader>ij", "<cmd>lua require('utils').JoinSession()<CR>" },
        -- Join buffer
        { "n", "<leader>iJ", "<cmd>lua require('utils').JoinSingle()<CR>" },
        -- Follow user
        { "n", "<leader>if", "<cmd>lua require('utils').Follow()<CR>" },
    }
    u.maps(maps, opts)
end

-- ******************************** debug ---------------------------------------
function M.debug()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Run
        { "n", "<leader>dr", "<cmd>Run<CR>" },
        -- Breakpoint
        { "n", "<leader>db", "<cmd>Break<CR>" },
        -- Clear breakpoint
        { "n", "<leader>dc", "<cmd>Clear<CR>" },
        -- Step into
        { "n", "<leader>ds", "<cmd>Step<CR>" },
        -- Step over
        { "n", "<leader>do", "<cmd>Over<CR>" },
        -- Finish
        { "n", "<leader>df", "<cmd>Finish<cr>" },
        -- Stop debug
        { "n", "<leader>de", "<cmd>Stop<cr>" },
    }
    u.bufmaps(bufmaps, opts)

    local maps = {
        -- Focus asm
        { "n", "<leader>da", "<cmd>Asm<cr>" },
        -- Focus program
        { "n", "<leader>dp", "<cmd>Program<cr>" },
        -- Focus Gdb
        { "n", "<leader>dg", "<cmd>Gdb<cr>" },
        -- Focus codebuffer
        { "n", "<leader>dv", "<cmd>Source<cr>" },
    }
    u.maps(maps, opts)
end

-- ******************************** Latex ---------------------------------------
function M.tex()
    local opts = { nowait = true, noremap = true, silent = true }
    local bufmaps = {
        -- Word Count
        { "n", "<F3>", "<cmd>TexWordCount<CR>" },
        -- Clean dir
        { "n", "<F4>", "<cmd>Make -C<CR>" },
        -- Compile document
        { "n", "<F5>", "<cmd>TexlabBuild<CR>" },
        -- Launch pdf
        { "n", "<F6>", "<cmd>TexlabForward<CR>" },
    }
    u.bufmaps(bufmaps, opts)
end

return M
