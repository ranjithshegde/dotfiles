-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  CamelCaseMotion = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/CamelCaseMotion"
  },
  ["completion-nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/completion-nvim"
  },
  ["express_line.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\ael\15statusline\frequire\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/express_line.nvim"
  },
  ["friendly-snippets"] = {
    load_after = {
      ["vim-vsnip-integ"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nM\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\nsetup\rgitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\ní\5\0\0\2\0\r\0\0226\0\0\0'\1\2\0=\1\1\0006\0\0\0'\1\4\0=\1\3\0006\0\0\0+\1\2\0=\1\5\0006\0\0\0+\1\2\0=\1\6\0006\0\0\0005\1\b\0=\1\a\0006\0\0\0005\1\n\0=\1\t\0006\0\0\0005\1\f\0=\1\v\0K\0\1\0\1\28\0\0\nclass\vreturn\rfunction\vmethod\b^if\v^while\16jsx_element\t^for\rinherits\21access_specifier\f^object\v^table\nblock\14arguments\n^case\f^public\r^private\15^protected\f^switch\17if_statement\16else_clause\16jsx_element\29jsx_self_closing_element\18try_statement\17catch_clause\21import_statement\19operation_type&indent_blankline_context_patterns\1\4\0\0\thelp\vpacker\ftaglist&indent_blankline_filetype_exclude\1\3\0\0\rterminal\vnofile%indent_blankline_buftype_exclude*indent_blankline_show_current_context$indent_blankline_use_treesitter\vLineNr$indent_blankline_char_highlight\b‚îä\26indent_blankline_char\6G\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim"
  },
  ["instant.nvim"] = {
    config = { "\27LJ\2\n2\0\0\2\0\3\0\0046\0\0\0'\1\2\0=\1\1\0K\0\1\0\fRanjith\21instant_username\6G\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/instant.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lua-dev.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vluadev\rsettings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/lua-dev.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n†\1\0\0\n\0\a\1\0186\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0B\2\1\0019\2\4\0004\4\3\0\18\5\1\0'\a\5\0'\b\5\0'\t\6\0B\5\4\0?\5\0\0B\2\2\1K\0\1\0\18supercollider\6|\14add_rules\nsetup\24nvim-autopairs.rule\19nvim-autopairs\frequire\3ÄÄ¿ô\4\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-colorizer.lua"] = {
    commands = { "ColorizerAttachToBuffer", "ColorizerToggle" },
    config = { "\27LJ\2\nê\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\bcss\1\0\2\vcss_fn\2\vrgb_fn\2\thtml\1\0\1\tmode\15foreground\1\4\0\0\6*\15javascript\tconf\nsetup\14colorizer\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-jdtls"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\njdtls\rsettings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/nvim-jdtls"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["orgmode.nvim"] = {
    config = { "\27LJ\2\ne\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1$org_highlight_latex_and_related\rentities\nsetup\forgmode\frequire\0" },
    keys = { { "", "<leader>oa" } },
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  scnvim = {
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/scnvim"
  },
  taglist = {
    commands = { "TlistToggle" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/taglist"
  },
  ["telescope-project.nvim"] = {
    config = { "\27LJ\2\nŸ\1\0\0\a\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\a\0005\4\5\0004\5\3\0005\6\3\0>\6\1\0055\6\4\0>\6\2\5=\5\6\4=\4\b\3=\3\n\2B\0\2\1K\0\1\0\15extensions\1\0\0\fproject\1\0\0\14base_dirs\1\0\0\1\2\1\0\29~/Documents/ofWorkspace/\14max_depth\3\4\1\2\1\0\27~/Software/Workspaces/\14max_depth\3\5\nsetup\14telescope\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    commands = { "Telescope" },
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14telescope\rsettings\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ultisnips = {
    after_files = { "/home/ranjith/.local/share/nvim/site/pack/packer/opt/ultisnips/after/plugin/UltiSnips_after.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/ultisnips"
  },
  ["vim-ccls"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-ccls"
  },
  ["vim-commentary"] = {
    keys = { { "", "gc" }, { "v", "gc" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-dispatch"] = {
    commands = { "Make", "Dispatch" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-dispatch"
  },
  ["vim-fugitive"] = {
    commands = { "G", "Git", "Gclog" },
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-glsl"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-glsl"
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-unimpaired"] = {
    keys = { { "", "[" }, { "", "]" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-unimpaired"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    after = { "friendly-snippets" },
    after_files = { "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ/after/plugin/vsnip_integ.vim" },
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ"
  },
  vimwiki = {
    keys = { { "", "<leader>ww" }, { "", "<leader>w<leader>w" }, { "", "<leader>wi" }, { "", "<leader>wt" } },
    loaded = false,
    needs_bufread = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vimwiki"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n|\0\0\5\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\a\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0>\4\1\3=\3\b\2B\0\2\1K\0\1\0\vlayout\1\0\0\1\0\1\fspacing\3\n\nwidth\1\0\0\1\0\1\bmax\3P\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["telescope.*"] = "telescope.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: ultisnips
time([[Setup for ultisnips]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14ultisnips\rsettings\frequire\0", "setup", "ultisnips")
time([[Setup for ultisnips]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n|\0\0\5\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\a\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0>\4\1\3=\3\b\2B\0\2\1K\0\1\0\vlayout\1\0\0\1\0\1\fspacing\3\n\nwidth\1\0\0\1\0\1\bmax\3P\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: express_line.nvim
time([[Config for express_line.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\ael\15statusline\frequire\0", "config", "express_line.nvim")
time([[Config for express_line.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gclog lua require("packer.load")({'vim-fugitive'}, { cmd = "Gclog", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TlistToggle lua require("packer.load")({'taglist'}, { cmd = "TlistToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file G lua require("packer.load")({'vim-fugitive'}, { cmd = "G", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ColorizerAttachToBuffer lua require("packer.load")({'nvim-colorizer.lua'}, { cmd = "ColorizerAttachToBuffer", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ColorizerToggle lua require("packer.load")({'nvim-colorizer.lua'}, { cmd = "ColorizerToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <leader>w<leader>w <cmd>lua require("packer.load")({'vimwiki'}, { keys = "<lt>leader>w<lt>leader>w", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[vnoremap <silent> gc <cmd>lua require("packer.load")({'vim-commentary'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>oa <cmd>lua require("packer.load")({'orgmode.nvim'}, { keys = "<lt>leader>oa", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> ] <cmd>lua require("packer.load")({'vim-unimpaired'}, { keys = "]", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>ww <cmd>lua require("packer.load")({'vimwiki'}, { keys = "<lt>leader>ww", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gc <cmd>lua require("packer.load")({'vim-commentary'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>wi <cmd>lua require("packer.load")({'vimwiki'}, { keys = "<lt>leader>wi", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>wt <cmd>lua require("packer.load")({'vimwiki'}, { keys = "<lt>leader>wt", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> [ <cmd>lua require("packer.load")({'vim-unimpaired'}, { keys = "[", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType supercollider ++once lua require("packer.load")({'nvim-treesitter-refactor', 'ultisnips', 'scnvim'}, { ft = "supercollider" }, _G.packer_plugins)]]
vim.cmd [[au FileType org ++once lua require("packer.load")({'orgmode.nvim'}, { ft = "org" }, _G.packer_plugins)]]
vim.cmd [[au FileType java ++once lua require("packer.load")({'nvim-jdtls'}, { ft = "java" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType cpp ++once lua require("packer.load")({'vim-ccls'}, { ft = "cpp" }, _G.packer_plugins)]]
vim.cmd [[au FileType vimwiki ++once lua require("packer.load")({'vimwiki', 'markdown-preview.nvim'}, { ft = "vimwiki" }, _G.packer_plugins)]]
vim.cmd [[au FileType glsl ++once lua require("packer.load")({'vim-glsl'}, { ft = "glsl" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'lua-dev.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'indent-blankline.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-autopairs'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'vim-surround'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]], true)
vim.cmd [[source /home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]]
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]], false)
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/ultisnips/ftdetect/snippets.vim]], true)
vim.cmd [[source /home/ranjith/.local/share/nvim/site/pack/packer/opt/ultisnips/ftdetect/snippets.vim]]
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/ultisnips/ftdetect/snippets.vim]], false)
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim/ftdetect/org.vim]], true)
vim.cmd [[source /home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim/ftdetect/org.vim]]
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim/ftdetect/org.vim]], false)
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim/ftdetect/org_archive.vim]], true)
vim.cmd [[source /home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim/ftdetect/org_archive.vim]]
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/orgmode.nvim/ftdetect/org_archive.vim]], false)
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/scnvim/ftdetect/supercollider.vim]], true)
vim.cmd [[source /home/ranjith/.local/share/nvim/site/pack/packer/opt/scnvim/ftdetect/supercollider.vim]]
time([[Sourcing ftdetect script at: /home/ranjith/.local/share/nvim/site/pack/packer/opt/scnvim/ftdetect/supercollider.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
