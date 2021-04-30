" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
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

time("Luarocks path setup", true)
local package_path_str = "/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/ranjith/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  ["completion-nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/completion-nvim"
  },
  ["express_line.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/express_line.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nÎ\3\0\0\2\0\t\0\0166\0\0\0005\1\2\0=\1\1\0006\0\0\0'\1\4\0=\1\3\0006\0\0\0+\1\2\0=\1\5\0006\0\0\0+\1\2\0=\1\6\0006\0\0\0005\1\b\0=\1\a\0K\0\1\0\1\21\0\0\nclass\vreturn\rfunction\vmethod\b^if\v^while\16jsx_element\t^for\f^object\v^table\nblock\14arguments\17if_statement\16else_clause\16jsx_element\29jsx_self_closing_element\18try_statement\17catch_clause\21import_statement\19operation_type&indent_blankline_context_patterns*indent_blankline_show_current_context$indent_blankline_use_treesitter\bâ”Š\26indent_blankline_char\1\2\0\0\rterminal%indent_blankline_buftype_exclude\6G\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["instant.nvim"] = {
    config = { "\27LJ\2\n2\0\0\2\0\3\0\0046\0\0\0'\1\2\0=\1\1\0K\0\1\0\fRanjith\21instant_username\6G\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/instant.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\nÄ\1\0\0\4\0\n\0\0146\0\0\0'\2\1\0B\0\2\0016\0\2\0'\2\3\0B\0\2\0029\0\4\0005\2\5\0005\3\6\0=\3\a\0025\3\b\0=\3\t\2B\0\2\1K\0\1\0\bcss\1\0\1\vrgb_fn\2\thtml\1\0\1\tmode\15foreground\1\5\0\0\6*\15javascript\ash\tconf\nsetup\14colorizer\frequire,autocmd BufReadPost *.conf setl ft=conf\tExec\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
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
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
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
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/playground"
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
    config = { "\27LJ\2\nì\1\0\0\3\0\a\0\r6\0\0\0'\1\2\0=\1\1\0006\0\0\0+\1\2\0=\1\3\0006\0\4\0'\2\5\0B\0\2\0016\0\4\0'\2\6\0B\0\2\1K\0\1\0001autocmd FileType supercollider setlocal wrapCautocmd FileType supercollider lua require \"mappings\".scnvim()\bCmd#scnvim_floating_args_show_full\6s\"scnvim_floating_args_register\6G\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/scnvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-ccls"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-ccls"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-eunuch"
  },
  ["vim-floaterm"] = {
    config = { "\27LJ\2\nš\1\0\0\2\0\a\0\r6\0\0\0)\1\1\0=\1\1\0006\0\0\0)\1\1\0=\1\2\0006\0\0\0'\1\4\0=\1\3\0006\0\0\0'\1\6\0=\1\5\0K\0\1\0\t<F9>\27floaterm_keymap_toggle\n<F10>\24floaterm_keymap_new\23floaterm_autoclose\24floaterm_autoinsert\6G\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-grammarous"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/opt/vim-grammarous"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  },
  vimtex = {
    config = { "\27LJ\2\n6\0\0\2\0\3\0\0046\0\0\0'\1\2\0=\1\1\0K\0\1\0\fzathura\25vimtex_viewer_method\6G\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vimtex"
  },
  vimwiki = {
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/vimwiki"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/ranjith/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time("Defining packer_plugins", false)
-- Config for: which-key.nvim
time("Config for which-key.nvim", true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time("Config for which-key.nvim", false)
-- Config for: vim-floaterm
time("Config for vim-floaterm", true)
try_loadstring("\27LJ\2\nš\1\0\0\2\0\a\0\r6\0\0\0)\1\1\0=\1\1\0006\0\0\0)\1\1\0=\1\2\0006\0\0\0'\1\4\0=\1\3\0006\0\0\0'\1\6\0=\1\5\0K\0\1\0\t<F9>\27floaterm_keymap_toggle\n<F10>\24floaterm_keymap_new\23floaterm_autoclose\24floaterm_autoinsert\6G\0", "config", "vim-floaterm")
time("Config for vim-floaterm", false)
-- Config for: nvim-colorizer.lua
time("Config for nvim-colorizer.lua", true)
try_loadstring("\27LJ\2\nÄ\1\0\0\4\0\n\0\0146\0\0\0'\2\1\0B\0\2\0016\0\2\0'\2\3\0B\0\2\0029\0\4\0005\2\5\0005\3\6\0=\3\a\0025\3\b\0=\3\t\2B\0\2\1K\0\1\0\bcss\1\0\1\vrgb_fn\2\thtml\1\0\1\tmode\15foreground\1\5\0\0\6*\15javascript\ash\tconf\nsetup\14colorizer\frequire,autocmd BufReadPost *.conf setl ft=conf\tExec\0", "config", "nvim-colorizer.lua")
time("Config for nvim-colorizer.lua", false)
-- Config for: instant.nvim
time("Config for instant.nvim", true)
try_loadstring("\27LJ\2\n2\0\0\2\0\3\0\0046\0\0\0'\1\2\0=\1\1\0K\0\1\0\fRanjith\21instant_username\6G\0", "config", "instant.nvim")
time("Config for instant.nvim", false)
-- Config for: scnvim
time("Config for scnvim", true)
try_loadstring("\27LJ\2\nì\1\0\0\3\0\a\0\r6\0\0\0'\1\2\0=\1\1\0006\0\0\0+\1\2\0=\1\3\0006\0\4\0'\2\5\0B\0\2\0016\0\4\0'\2\6\0B\0\2\1K\0\1\0001autocmd FileType supercollider setlocal wrapCautocmd FileType supercollider lua require \"mappings\".scnvim()\bCmd#scnvim_floating_args_show_full\6s\"scnvim_floating_args_register\6G\0", "config", "scnvim")
time("Config for scnvim", false)
-- Config for: vimtex
time("Config for vimtex", true)
try_loadstring("\27LJ\2\n6\0\0\2\0\3\0\0046\0\0\0'\1\2\0=\1\1\0K\0\1\0\fzathura\25vimtex_viewer_method\6G\0", "config", "vimtex")
time("Config for vimtex", false)
-- Config for: gitsigns.nvim
time("Config for gitsigns.nvim", true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time("Config for gitsigns.nvim", false)
-- Config for: indent-blankline.nvim
time("Config for indent-blankline.nvim", true)
try_loadstring("\27LJ\2\nÎ\3\0\0\2\0\t\0\0166\0\0\0005\1\2\0=\1\1\0006\0\0\0'\1\4\0=\1\3\0006\0\0\0+\1\2\0=\1\5\0006\0\0\0+\1\2\0=\1\6\0006\0\0\0005\1\b\0=\1\a\0K\0\1\0\1\21\0\0\nclass\vreturn\rfunction\vmethod\b^if\v^while\16jsx_element\t^for\f^object\v^table\nblock\14arguments\17if_statement\16else_clause\16jsx_element\29jsx_self_closing_element\18try_statement\17catch_clause\21import_statement\19operation_type&indent_blankline_context_patterns*indent_blankline_show_current_context$indent_blankline_use_treesitter\bâ”Š\26indent_blankline_char\1\2\0\0\rterminal%indent_blankline_buftype_exclude\6G\0", "config", "indent-blankline.nvim")
time("Config for indent-blankline.nvim", false)
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
