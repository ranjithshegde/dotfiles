# Neovim Personalized Development Environment

Note: Until comprehensive documentation is in-place, explore the config source code or simply type `:WhichKey` inside any filetype

## Features

- Modularized lua configuration
- On-demand (lazy) load:
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
- [Compiler](lua/r/utils/compiler.lua) `overseer.nvim` to a full compile suite
- [Scratchpad](lua/r/utils/project/scratchpad.lua) Quick and saveable scratchpad for some languages

### Editor extensions

- [CamelCase](lua/r/utils/camel.lua) motion
- [Unimpaired](lua/r/mappings/pairs.lua) keybindings with features
- [QuickFix](lua/r/utils/qf.lua) management
- [WordProcessor](lua/r/utils/extensions.lua#90) mode

### LSP extensions

- [Ltex extensions](lua/r/utils/ls.lua#282) out-of-spec code actions for ltex LSP
- [Lsp Rename](lua/r/lsp/rename.lua) Incremental and previewable
- [signature help](lua/r/lsp/signature.lua) Auto-popup with snippet support
- [Diagnostics](lua/r/utils/diagnostics/init.lua) Configuire and toggle
- [Lsp Capabilities](lua/r/utils/ls.lua#37) view in md/json popup

### Eye candy extensions

- [Statusline](lua/r/settings/statusline.lua) Event based subscription model for every component
- [Toggle](lua/r/utils/extensions.lua#45) transparent background
- [Context](lua/r/settings/statusline.lua#155) nvim-gps like treesitter statusline
- [winbar](lua/r/settings/winbar.lua) only when it makes sense
- [Decorations](lua/r/settings/autocmds.lua#50) relativenumber, cursorline, foldcolumn only when it makes sense

## External Plugin list

### LSP

- [nvim-lspconfig](https://github.com/ranjithshegde/nvim-lspconfig/tree/0.7) - Quick-start configurations for built-in LSP
- [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) - Wrapper and quickstart configurations for cmdline linters/formatters
- [vim-ccls](https://github.com/m-pilia/vim-ccls) - Extends CCLS language server for custom requests
- [clangd_extensions](https://github.com/p00f/clangd_extensions.nvim) - Same for clangd
- [lua-dev](https://github.com/folke/lua-dev.nvim) - Integrate nvim lua directories to LSP + EmmyLua annotations
- [symbols-outline](https://github.com/simrat39/symbols-outline.nvim) - A sidebar with LSP document symbols

### TreeSitter

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Basic modules and parser collection for tree-sitter
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - vim textobjects support for tree-sitter nodes
- [nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor) - basic refactor support for tree-sitter nodes
- [nvim-treesitter-playground](https://github.com/nvim-treesitter/playground) - Interactively explore ts queries and highlights
- [nvim-ts-rainbow](https://github.com/p00f/nvim-ts-rainbow) - rainbow colorize parens using tree-sitter hierarchy
- [nvim-treesitter-cpp-tools](https://github.com/Badhi/nvim-treesitter-cpp-tools) - Cpp specific refactoring using tree-sitter

### Autocomeletion + Snippets

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) Async Autocomeletion framework
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Versatile and extensible snippets engine
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Collection of quickstart snippets for common languages
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) - LuaSnip completion source for nvim-cmp
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - LSP completion source for nvim-cmp
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - buffer words completion source for nvim-cmp
- [cmp-path](https://github.com/hrsh7th/cmp-path) - system path completion source for nvim-cmp
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Extensible bracket and htag completion engine

### Debug adapter protocol

- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Leverage DAP framework and make nvim a DAP client
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - Extend and customize DAP output windows to interact with

### Filetype extensions

- [scnvim](https://github.com/davidgranstrom/scnvim) - Turn vim into SuperCollider IDE
- [orgmode.nvim](https://github.com/nvim-orgmode/orgmode) - Emacs' orgmode extension for nvim
- [orgWiki](https://github.com/ranjithshegde/orgWiki.nvim/tree/refactor) - Extend journaling and note-taking features of orgmode (vimWiki)

### Fuzzy search and navigation

- [telescope-nvim](https://github.com/nvim-telescope/telescope.nvim) - Highly extensible fzf framework + picker-sorter collection
- [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) - fzf C binary for telescope-nvim
- [telescope-project](https://github.com/nvim-telescope/telescope-project.nvim) - Git/LSP recognized projects picker for telescope
- [telescope-file-browser](https://github.com/nvim-telescope/telescope-file-browser.nvim) - Telescope picker to view and interact with folders

### Tooling enhancements

- [packer.nvim](https://github.com/wbthomason/packer.nvim) - Programatically extends native package management
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Magical integration with Git tooling
- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - Async display of git-gutter and change-highlights
- [overseer.nvim](https://github.com/stevearc/overseer.nvim) -Async and Programatically extend `:compiler`
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Libuv shorthands + other LuaJIT features
- [which-key](https://github.com/folke/which-key.nvim) - Programtically configure keybindings with incremental descriptions

### Editor enhancements

- [Comments.nvim](https://github.com/numToStr/Comment.nvim) - Add/remove/manipulate commentstrings using tree-sitter
- [nvim-surround](https://github.com/kylechui/nvim-surround) - Add/remove/manipulate surrounding pairs with tree-sitter
- [express_line.nvim](https://github.com/tjdevries/express_line.nvim/) - Adds libuv and subscription model to built-in statusline
- [nvim-colorizer](https://github.com/xiyaowong/nvim-colorizer.lua) - Attach colors as highlights for RGB/HEX text

### Database management

- [vim-dadbod](https://github.com/tpope/vim-dadbod) - Interactit with `MySQL`, `Postgre` and other databases
- [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) - Interactive UI for query tasks
- [sqls.nvim](https://github.com/nanotee/sqls.nvim/) - Extensions for SQL language server

### UI customization

- [nvim-notify](https://github.com/rcarriga/nvim-notify) - Extend `vim.notify` with configurations and floating UI
- [dressing.nvim](https://github.com/stevearc/dressing.nvim) - turn `vim.ui.` calls into Popups

### Eye candy

- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) - Highly customizable colorscheme collection
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) - Turn foldtext into extmarks + Popup fold-preview
- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) - Add Extmark indent guides with tree-sitter context
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - Fancy icons for filetype and LSP
