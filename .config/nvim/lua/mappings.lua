local M = {}
local u = require('utils')

-- ******************************** General functions ---------------------------------------

function M.general()
	M.edit_config_files()
	M.git()
	M.telescope()

	local opts = {nowait = true, noremap = true, silent = false}
	local maps = {
		-- Window movement
		{'n', '<C-J>', '<C-W><C-J>'},
		{'n', '<C-K>', '<C-W><C-K>'},
		{'n', '<C-L>', '<C-W><C-L>'},
		{'n', '<C-H>', '<C-W><C-H>'},
		{'x', 'K', ':move \'<-2<CR>gv-gv'},
		{'x', 'J', ':move \'>+1<CR>gv-gv'},
		{'n', '<leader>qf', ':copen<CR>'},
		{'n', '<leader>lf', ':lopen<CR>'},
		-- visual cut for replase
		{'v', '<leader>p', '"_dP'},
		{'s', '<leader>p', '"_dP'},
		-- Indent
		{'v', '<', '<gv'},
		{'v', '>', '>gv'},
		-- Escape in terminal mode
		{'t', '<Esc>', '<C-\\><C-n>'},
		{'n', '<leader>ht', ':sp term://zsh<cr>'},
		{'n', '<leader>t', ':vspl term://zsh<cr>'},
		{'n', ';K', ':TSHighlightCapturesUnderCursor<cr>'},
		{'n', ';P', ':TSPlaygroundToggle<cr>'},
	}
	u.maps(maps,opts)
end

-- ******************************** language server ---------------------------------------

function M.nvim_lsp()
	local opts = {noremap = true, silent = true}
	-- local pop_opts = {popup_opts = {border = "double"}}

	local bufmaps = {
		{'n', ',D', '<cmd>lua vim.lsp.buf.declaration()<CR>'},
		{'n', ',d', '<cmd>lua vim.lsp.buf.definition()<CR>'},
		{'n', ',i', '<cmd>lua vim.lsp.buf.implementation()<CR>'},
		{'n', ',t', '<cmd>lua vim.lsp.buf.type_definition()<CR>'},
		{"n", ',s', "<cmd>lua vim.lsp.buf.signature_help()<CR>"},
		{'n', ',pd', "<cmd>lua require'utils'.peek_definition()<CR>"},
		{'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "double"}})<CR>'},
		{'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "double"}})<CR>'},
		{'n', ',ld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({popup_opts = {border = "double"}})<CR>'},
		{'n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>'},
		{"n", ",ac", "<cmd>lua vim.lsp.buf.code_action()<CR>"},
		{"n", ",ff", "<cmd>lua vim.lsp.buf.formatting()<CR>"},
		{"n", ",rf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>"},
		{'n', ',sl', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
		{'n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'},
		{'n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'},
		{'n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'},
	}

	u.bufmaps(bufmaps, opts)
end

-- ******************************** vim basic calls ---------------------------------------

function M.edit_config_files()
	local open_func = "tabnew"
	local opts = {nowait = true, noremap = true, silent = true}
	local maps = {

		{'n', '<leader>aR', "<cmd>lua require('utils').Restart()<CR>"},
		{'n', '<leader>aP', "<cmd>PackerSync<CR>"},
		{'n', '<leader>am', ':' .. open_func .. " ~/.config/nvim/lua/mappings.lua<CR>"},
		{'n', '<leader>al', ':' .. open_func .. " ~/.config/nvim/lua/settings.lua<CR>"},
		{'n', '<leader>ap', ':' .. open_func .. " ~/.config/nvim/lua/plugins.lua<CR>"},
		{'n', '<leader>as', ':' .. open_func .. " ~/.config/nvim/lua/statusline.lua<CR>"},
		{'n', '<leader>ac', ':' .. open_func .. " ~/.config/nvim/lua/cmake.lua<CR>"},
		{'n', '<leader>aut', ':' .. open_func .. " ~/.config/nvim/lua/utils/init.lua<CR>"},
		{'n', '<leader>ar', ':' .. open_func .. ' $MYVIMRC<CR>'}
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
		return string.format(":lua require'telescope'.extensions.%s()<cr>", name)
	end

	local opts = {nowait = true, noremap = true, silent = true}
	local maps = {
		-- openFrameworks and other projects
		{'n', '<space>p', telE("project.project")},
		-- Plugins
		{'n', '<space>P', telE("packer.plugins")},
		-- Fuzzy find files in cwd
		{'n', '<space>f', tele("find_files")},
		-- document symbol
		{'n', '<space>s', tele("lsp_document_symbols")},
		-- Oldfiles
		{'n', '<space>rf', tele("oldfiles")},
		-- Code action
		{'n', '<space>ac', tele("lsp_code_actions")},
		-- Document diagnostics
		{'n', '<space>dd', tele("lsp_document_diagnostics")},
		-- Workspace diagnostics
		{'n', '<space>D', tele("lsp_workspace_diagnostics")},
		-- Code action
		{'n', '<space>rc', tele("lsp_range_code_actions")},
		-- References under cursor
		{'n', ',r', tele("lsp_references")},
		-- Quickfix list
		{'n', '<space>q', tele("quickfix")},
		-- Location list
		{'n', '<space>l', tele("loclist")},
		-- live grep
		{'n', '<space>G', tele("live_grep")},
		-- Help tags
		{'n', '<space>ht', tele("help_tags")},
		-- registers list
		{'n', '<space>"', tele("registers")},
		-- File explorer
		{'n', '<space>e', tele("file_browser")},
		-- commands explorer
		{'n', '<space>c', tele("commands")},
		-- commands history
		{'n', '<space>C', tele("command_history")},
		-- git branches
		{'n', '<space>gb', tele("git_branches")},
		-- git commits
		{'n', '<space>gc', tele("git_commits")},
		-- git status
		{'n', '<space>gs', tele("git_status")},
		-- git files
		{'n', '<space>gf', tele("git_files")},
		-- colorschemes
		-- {'n', '<space>c', telF("colorscheme(No_preview())")},
		-- Unicode
		{'n', '<space>m', tele("symbols")},
		-- Workspace symbol under cursor
		{'n', '<space>S', telF("lsp_workspace_symbols({query = vim.fn.expand('<cword>')})")},
		-- Switch buffers
		{'n', '<space>b', tele("buffers")},
		-- grep ofProjects
		{'n', '<space>og', telF("live_grep({cwd='~/Documents/ofWorkspace', follow = true, hidden = true})")},
		-- find-files ofProjects
		{'n', '<space>of', telF("find_files({cwd='~/Documents/ofWorkspace'})")},
		--  Serach dotfiles
		{'n', '<space>df', telF("find_files({cwd='~/.config/'})")},
		--  Serach HOME
		{'n', '<space>hf', telF("find_files({cwd='~'})")},
		-- Search plugins
		{'n', '<space>vf', telF("find_files({cwd='~/.local/share/nvim/'})")}
	}
	u.maps(maps, opts)
end

-- ******************************** Git ---------------------------------------

-- fugitive mappings
function M.git()
	local opts = {nowait = true, noremap = true, silent = false}
	local maps = {
		{'n', '<leader>gg', ':G<cr>'},
		{'n', '<leader>gc', ':Git commit %<cr>'},
		{'n', '<leader>ga', ':Git add %<cr>'},
		{'n', '<leader>gd', ':Git difftool<cr>'},
		{'n', '<leader>gb', ':Git blame<cr>'},
		{'n', '<leader>gp', ':Gitsigns preview_hunk<cr>'},
		{'n', '<leader>gP', ':Git push<cr>'},
		{'n', '<leader>gf', ':Git fetch<cr>'},
		{'n', '<leader>gl', ':Gclog<cr>'}
	}

	u.maps(maps, opts)
end

-- When in a git commit window
function M.git_commit()
	local opts = {nowait = true, noremap = true, silent = false}
	local bufmaps = {
		{'n', '<C-e>', ':wq<cr>'},
		{'i', '<C-e>', '<esc>:wp<cr>'}
	}
	u.bufmaps(bufmaps, opts)
end

-- ******************************** Arduino ---------------------------------------

function M.arduino()
	local opts = {nowait = true, noremap = true, silent = false}
	local bufmaps = {
		{'n', '<leader>bld', ':w <CR> :FloatermNew platformio run <CR>'},
		{'n', '<leader>tag', ':w <cr> :!pio run -t compiledb<CR>'},
		{'n', '<leader>upl', ':w <cr> :!platformio run --target upload<CR>'}
	}
	u.bufmaps(bufmaps, opts)
end

-- ******************************** Snippets ---------------------------------------
function M.autoComplete()
	-- change completion mode
	Cmd('imap <c-j> <Plug>(completion_next_source)')
	Cmd('imap <c-k> <Plug>(completion_prev_source)')
	--vsnip commapds
	--expand
	Cmd('imap <expr> <C-h> vsnip#expandable() ? "<Plug>(vsnip-expand)"  : "<C-h>"')
	Cmd('smap <expr> <C-h> vsnip#expandable() ? "<Plug>(vsnip-expand)"  : "<C-h>"')
	--expand or jump
	Cmd('imap <expr> <C-l> vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-l>"')
	Cmd('smap <expr> <C-l> vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-l>"')
	--Plugs
	Cmd('nmap  s  <Plug>(vsnip-select-text)')
	Cmd('xmap  s  <Plug>(vsnip-select-text)')
	Cmd('nmap  S  <Plug>(vsnip-cut-text)')
	Cmd('xmap  S  <Plug>(vsnip-cut-text)')
end

-- ******************************** SuperCollider ---------------------------------------
function M.scnvim()
	local opts = { nowait = true, noremap = true, silent = true }

	Cmd('nmap <buffer> <F5> <Plug>(scnvim-send-block)')
	Cmd('nmap <buffer>,S <Plug>(scnvim-show-signature)')
	Cmd('imap <buffer> <F5> <esc><Plug>(scnvim-send-block)')
	Cmd('vmap <buffer> <F5> <Plug>(scnvim-send-selection)')
	Cmd('nmap <buffer> <F6> <Plug>(scnvim-send-line)')
	Cmd('imap <buffer> <F6> <esc><Plug>(scnvim-send-line)')
	-- Buffer local mappings:
	local bufmaps = {
		-- Start language
		{'n', '<F1>', ':SCNvimStart<cr>'},
		-- SCNvimStatusLine
		{'n', '<F2>', ':SCNvimStatusLine<cr>'},
		-- Recompile
		{'n', '<leader>sk', ':SCNvimRecompile<cr>'},
		-- Start scsynth
		{'n', '<F3>', ':call scnvim#sclang#send_silent("Server.local.boot")<CR>'},
		--Start WFSCollider
		{'n', '<F4>', ':call scnvim#sclang#send_silent("WFSLib.startup")<CR>'},
		-- Echo args
		{'n', ';a', ':call scnvim#util#args_popup_toggle()<cr>'},
		-- {'n', ';a', ':call scnvim#util#echo_args()<cr>'},
		-- Regenerate Ctags
		{'n', '<leader>rt', ':SCNvimTags<cr>'},
		-- Edit startup file
		{'n', '<leader>es', ':tabnew ~/.config/SuperCollider/startup.scd<cr>'},
	}
	u.bufmaps(bufmaps, opts)
end

-- ******************************** cpp -openFrameworks ---------------------------------------
function M.clang()
	local opts = { nowait = true, noremap = true, silent = true }

	local bufmaps = {
		-- Switch source header
		{'n', 'mv', ':ClangdSwitchSourceHeader<CR>'},
		-- Compile c file
		{'n', '<F1>', ':w <CR> :!gcc % -o %< && ./%< <CR>'},
		-- avoid preprocessor errors
		{'n', '<F2>', ':w <CR> :!gcc % -lm -o %< && ./%< <CR>'},
		-- Compile cpp file
		{'n', '<F3>', ':w <CR> :!g++ -g % -o %< && ./%< <CR>'},
		-- Compile Debug openFrameworks
		{'n', '<F4>', ':w <CR> :!make Debug -j12<CR>'},
		-- Compile openFrameworks
		{'n', '<F5>', ':w <CR> :FloatermNew make -j12 && make RunRelease<CR>'},
		-- run openFrameworks
		{'n', '<F6>', ':w <CR> :!make RunRelease<CR>'},
		-- Build Cmake
		{'n', '<F7>', ':w <CR> :CMakeGenerate<CR>'},
		-- run Cmake
		{'n', '<F8>', ':w <CR> :CMakeBuild<CR>'},

		-- bases
		{'n',';b', ':CclsBase<CR>'},
		--   bases of up to 3 levels
		{'n',';B', ':CclsBaseHierarchy -float<CR>'},
		--   derived
		{'n',';hd', ':CclsDerived<CR>'},
		--   derived of up to 3 levels
		{'n',';hD', ':CclsDerivedHierarchy -float<CR>'},

		-- caller
		{'n',';c', ':CclsCallers<CR>'},
		-- caller Hierarchy
		{'n',';hc', ':CclsCallHierarchy -float<CR>'},
		-- callee
		{'n',';C', ':CclsCallees<CR>'},
		-- callee Hierarchy
		{'n',';hC', ':CclsCalleeHierarchy -float<CR>'},

		-- Members
		{'n',';m', ':CclsMemberHierarchy -float<CR>'},
		-- memberFunction
		{'n',';f', ':CclsMemberFunctionHierarchy -float<CR>'},
		-- memberTypes
		{'n',';t', ':CclsMemberTypeHierarchy -float<CR>'},

		-- variables
		{'n',';v', ':CclsVars<CR>'},
	}
	u.bufmaps(bufmaps, opts)
end

-- ******************************** CMake ---------------------------------------

function M.cmake()
	local opts = { nowait = true, noremap = true, silent = false }
	local bufmaps = {

		{'n', '<leader>cb', ':lua require("cmake").cmake_build()<cr>'},
		{'n', '<leader>cd', ':lua require("cmake").cmake_gen_debug()<cr>'},
		{'n', '<leader>cg', ':lua require("cmake").cmake_gen()<cr>'},
		{'n', '<leader>cc', ':lua require("cmake").cmake_clean_build()<cr>'},
		{'n', '<leader>ci', ':lua require("cmake").cmake_install()<cr>'},
		{'n', '<leader>ct', ':lua require("cmake").catch_test()<cr>'},
		{'n', '<leader>cb', ':lua require("cmake").cmake_build()<cr>'},
		{'n', '<leader>ct', ':lua require("cmake").catch_test()<cr>'},
		{'n', '<C-t>', ':lua require("cmake").fuzzy_catch()<cr>'},

	}

	u.bufmaps(bufmaps, opts)
end

return M

