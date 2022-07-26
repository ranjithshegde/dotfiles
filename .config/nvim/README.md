# Neovim Personalized Development Environment

Note: Until comprehensive documentation is in-place, explore the config source code or simply type `:WhichKey` inside any filetype

## Features

- Modularized lua configuration
- On-demand (lazy) load#
  - plugins (Packer + internal autocmds)
  - internal modules (keymaps + autocmds)
- Basic documentation (To be extended later)

### Workstation

- Featureful development envirnment for languages:
  _C/C++_, _Lua_, _shell_ (bash, zsh), _TypeScript_, _perl_, _Web-development_

- IDE support for _SuperCollider_ and _PlatformIO_ (microcontrollers)
- Multimedia development frameworks:
  _openFrameworks_, _SupeCollider_, _PureData_ (C externals, pd\*luaX)
- Tyepsetting and WordProcessing support via
  _LaTex_, _Markdown_, _Orgmode_
- Syntax handling for:
  HTML, CSS, JSON, YAML, TOML

## Internal plugin list

### Terminal management

- [Ranger](lua/r/utils/extensions.lua#109) integrated as file-picker
- [Terminal](lua/r/utils/extensions.lua#130) Persistent and toggleable
- [REPL](lua/r/settings/autocmds.lua#169) toggleable REPL for supported languages

### Project management

- [Projects](lua/r/utils/project/init.lua) Create and access project system for some languages
- [Compiler](lua/r/utils/compiler.lua) Extend `vim-dispatch` into complete build swite for supported languages
- [Scratchpad](lua/r/utils/project/scratchpad.lua) Quick and saveable scratchpad for some languages

### Editor extensions

- [CamelCase](lua/r/utils/camel.lua) motion
- [Unimpaired](lua/r/mappings/pairs.lua) keybindings with features
- [QuickFix](lua/r/utils/qf.lua) management
- [WordProcessor](lua/r/utils/extensions.lua#90) mode

### LSP extensions

- [Lsp Rename](lua/r/lsp/rename.lua) Incremental and previewable
- [signature help](lua/r/lsp/signature.lua) Auto-popup with snippet support
- [Diagnostics](lua/r/utils/diagnostics/init.lua) Configuire and toggle
- [Lsp Capabilities](lua/r/utils/ls.lua#37) view in md/json popup

### Eye candy extensions

- [Toggle](lua/r/utils/extensions.lua#45) transparent background
- [Context](lua/r/settings/statusline.lua#155) nvim-gps like treesitter statusline
- [winbar](lua/r/settings/winbar.lua) only when it makes sense
- [Decorations](lua/r/settings/autocmds.lua#50) relativenumber, cursorline, foldcolumn only when it makes sense

## External Plugin list

### LSP

- nvim-lspconfig - Quick-start configurations for built-in LSP
- null-ls - Wrapper and quickstart configurations for cmdline linters/formatters
- vim-ccls - Extends CCLS language server for custom requests
- clangd_extensions - Same for clangd
- lua-dev - Integrate nvim lua directories to LSP + EmmyLua annotations
- symbols-outline - A sidebar with LSP document symbols

### TreeSitter

- nvim-treesitter - Basic modules and parser collection for tree-sitter
- nvim-treesitter-textobjects - vim textobjects support for tree-sitter nodes
- nvim-treesitter-refactor - basic refactor support for tree-sitter nodes
- nvim-treesitter-playground - Interactively explore ts queries and highlights
- nvim-ts-rainbow - rainbow colorize parens using tree-sitter hierarchy
- nvim-treesitter-cpp-tools - Cpp specific refactoring using tree-sitter

### Autocomeletion + Snippets

- nvim-cmp Async Autocomeletion framework
- LuaSnip - Versatile and extensible snippets engine
- friendly-snippets - Collection of quickstart snippets for common languages
- cmp_luasnip - LuaSnip completion source for nvim-cmp
- cmp-nvim-lsp - LSP completion source for nvim-cmp
- cmp-buffer - buffer words completion source for nvim-cmp
- cmp-path - system path completion source for nvim-cmp
- nvim-autopairs - Extensible bracket and htag completion engine

### Debug adapter protocol

- nvim-dap - Leverage DAP framework and make nvim a DAP client
- nvim-dap-ui - Extend and customize DAP output windows to interact with

### Filetype extensions

- scnvim - Turn vim into SuperCollider IDE
- orgmode.nvim - Emacs' orgmode extension for nvim

- orgWiki - Extend journaling and note-taking features of orgmode (vimWiki)

### Fuzzy search and navigation

- telescope-nvim - Highly extensible fzf framework + picker-sorter collection
- telescope-fzf-native - fzf C binary for telescope-nvim
- telescope-project - Git/LSP recognized projects picker for telescope
- telescope-file-browser - Telescope picker to view and interact with folders

### Tooling enhancements

- packer.nvim - Programatically extends native package management
- vim-fugitive - Magical integration with Git tooling
- gitsigns - Async display of git-gutter and change-highlights
- vim-dispatch -Async and Programatically extend `#compiler`
- plenary.nvim - Libuv shorthands + other LuaJIT features
- which-key - Programtically configure keybindings with incremental descriptions

### Editor enhancements

- Comments.nvim - Add/remove/manipulate commentstrings using tree-sitter
- nvim-surround - Add/remove/manipulate surrounding pairs with tree-sitter
- express_line.nvim - Adds libuv and subscription model to built-in statusline
- nvim-colorizer - Attach colors as highlights for RGB/HEX text

### UI customization

- nvim-notify - Extend `vim.notify` with configurations and floating UI
- dressing.nvim - turn `vim.ui.` calls into Popups

### Eye candy

- nightfox.nvim - Highly customizable colorscheme collection
- nvim-ufo - Turn foldtext into extmarks + Popup fold-preview
- indent-blankline - Add Extmark indent guides with tree-sitter context
- twilight.nvim - "Dim" inactive parts of the buffer using tree-sitter context
- zen-mode - Clean text-only popup for distraction free editing
- nvim-web-devicons - Fancy icons for filetype and LSP
