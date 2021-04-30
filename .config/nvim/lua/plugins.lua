require('utils')
-- Defs
local fn = vim.fn
local camel = fn.stdpath('data') .. '/site/pack/plugins/opt/CamelCaseMotion'
local zephyr = fn.stdpath('data') .. '/site/pack/plugins/start/zephyr-nvim'
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

--------------------------------------------------------------------------------------------------------
--				Custom Plugins 							      --
--------------------------------------------------------------------------------------------------------
-- CamelCaseMotion
if fn.empty(fn.glob(camel)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/bkad/CamelCaseMotion.git', camel})
end

-- Colorscheme zypher
if fn.empty(fn.glob(zephyr)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/glepnir/zephyr-nvim.git', zephyr})
end

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end

Exec 'autocmd BufWritePost,BufLeave plugins.lua PackerCompile'

--------------------------------------------------------------------------------------------------------
--				Main Plugins 							      --
--------------------------------------------------------------------------------------------------------
local packer = require('packer')

return packer.startup(function(use)

    use 'wbthomason/packer.nvim'

    use 'vimwiki/vimwiki'

    use 'SirVer/ultisnips'

    -- use "fhill2/floating.nvim"

    use {'m-pilia/vim-ccls', opt = true}

    use {'rhysd/vim-grammarous', opt = true}

    use {'neovim/nvim-lspconfig', requires = {'nvim-lua/lsp-status.nvim'}}

    use {"folke/which-key.nvim", config = function() require("which-key").setup {} end}

    use {'jbyuki/instant.nvim', config = function() G.instant_username = 'Ranjith' end}

    use {'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end}

    -- StatusLine
    use {'tjdevries/express_line.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}

    -- Markdown preview
    -- use {'iamcco/markdown-preview.nvim',
    -- run = function() fn['mkdp#util#install']() end
    -- }

    -- completion and snippets
    use {
        'ranjithshegde/completion-nvim',
        requires = {
            'windwp/nvim-autopairs', 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'
            -- 'norcalli/snippets.nvim',
        }
    }

    -- Tim pope
    use {
        'tpope/vim-fugitive', 'tpope/vim-commentary', 'tpope/vim-unimpaired', 'tpope/vim-surround',
        'tpope/vim-repeat', 'tpope/vim-eunuch'
    }

    -- vimTex
    use {
        'lervag/vimtex',
        config = function()
            G.vimtex_viewer_method = 'zathura'
            -- G.vimtex_format_enabled = 1
        end
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
        -- 'nvim-telescope/telescope-symbols.nvim','nvim-telescope/telescope-project.nvim','razak17/telescope-packer.nvim'
    }

    -- TreeSitter
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/playground', 'p00f/nvim-ts-rainbow',
            'nvim-treesitter/nvim-treesitter-textobjects'
            -- 'nvim-treesitter/nvim-treesitter-refactor',
            -- 'theHamsta/nvim-treesitter-pairs'
            -- 'JoosepAlviste/nvim-ts-context-commentstring'
        }
    }

    -- Floating terminal
    use {
        'voldikss/vim-floaterm',
        config = function()
            G.floaterm_autoinsert = 1
            G.floaterm_autoclose = 1
            G.floaterm_keymap_new = '<F10>'
            G.floaterm_keymap_toggle = '<F9>'
        end
    }

    -- SuperCollider
    use {
        'salkin-mada/scnvim',
        -- 'davidgranstrom/scnvim',
        -- branch = 'assets',
        branch = 'salkin-dev',
        run = function() fn['scnvim#install']() end,
        config = function()
            G.scnvim_floating_args_register = "s"
            G.scnvim_floating_args_show_full = true
            -- G.scnvim_snippet_format = 'snippets.nvim'
            -- G.scnvim_scdoc = 1
            Cmd 'autocmd FileType supercollider lua require "mappings".scnvim()'
            Cmd 'autocmd FileType supercollider setlocal wrap'
        end
    }

    -- Colorizer
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            Exec("autocmd BufReadPost *.conf setl ft=conf")
            require'colorizer'.setup {
                '*',
                html = {mode = 'foreground'},
                css = {rgb_fn = true},
                'javascript',
                'sh',
                'conf'
            }
        end
    }

    -- Indents and chars
    use {
        'lukas-reineke/indent-blankline.nvim',
        branch = 'lua',
        config = function()
            G.indent_blankline_buftype_exclude = {'terminal'}
            G.indent_blankline_char = '┊'
            G.indent_blankline_use_treesitter = true
            G.indent_blankline_show_current_context = true
            G.indent_blankline_context_patterns = {
                'class', 'return', 'function', 'method', '^if', '^while', 'jsx_element', '^for',
                '^object', '^table', 'block', 'arguments', 'if_statement', 'else_clause',
                'jsx_element', 'jsx_self_closing_element', 'try_statement', 'catch_clause',
                'import_statement', 'operation_type'
            }

        end
    }
end)

