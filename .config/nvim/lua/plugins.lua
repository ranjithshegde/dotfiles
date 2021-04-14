local u = require('utils')

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    Exec('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    -- Exec 'packadd packer.nvim'
end

Exec 'autocmd BufWritePost,BufLeave plugins.lua PackerCompile'

local packer = require('packer')

return packer.startup(function(use)

    use 'wbthomason/packer.nvim'

    use 'norcalli/snippets.nvim'

    use 'liuchengxu/vim-which-key'

    use 'vimwiki/vimwiki'

    -- use 'tjdevries/cyclist.vim'

    -- use 'SirVer/ultisnips'

    -- use 'vigoux/LanguageTool.nvim'

    use {'rhysd/vim-grammarous', opt = true}

    use {'m-pilia/vim-ccls', opt = true}

    use {'neovim/nvim-lspconfig', requires = {'nvim-lua/lsp-status.nvim'}}

    use {'jbyuki/instant.nvim', config = function() G.instant_username = 'Ranjith' end}

    use {'lervag/vimtex', config = function() G.vimtex_viewer_method = 'zathura' end}

    use {'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end}

    use {
        'ranjithshegde/completion-nvim',
        requires = {'windwp/nvim-autopairs', 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ'}
    }

    use {
        'tpope/vim-fugitive', 'tpope/vim-commentary', 'tpope/vim-unimpaired', 'tpope/vim-surround',
        'tpope/vim-repeat', 'tpope/vim-eunuch'
    }

    use {
        -- 'glepnir/galaxyline.nvim',
        -- branch = 'main',
        'tjdevries/express_line.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
        -- 'nvim-telescope/telescope-symbols.nvim','nvim-telescope/telescope-project.nvim','razak17/telescope-packer.nvim'
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/playground', 'nvim-treesitter/nvim-treesitter-refactor',
            'p00f/nvim-ts-rainbow', 'ranjithshegde/nvim-treesitter-textobjects'
            -- 'JoosepAlviste/nvim-ts-context-commentstring'
        }
    }

    use {
        'voldikss/vim-floaterm',
        config = function()
            G.floaterm_autoinsert = 1
            G.floaterm_autoclose = 1
            G.floaterm_keymap_new = '<F10>'
            G.floaterm_keymap_toggle = '<F9>'
        end
    }

    use {
        'salkin-mada/scnvim',
        -- branch = 'assets',
        branch = 'salkin-dev',
        run = function() fn 'scnvim#install()' end,
        config = function()
            -- G.scnvim_floating_args_max_width = 60
            G.scnvim_floating_args_register = "s"
            G.scnvim_floating_args_show_full = true
            G.scnvim_snippet_format = 'snippets.nvim'
            -- G.scnvim_snippet_format = 'UltiSnips'
            -- G.scnvim_scdoc = 1
            Cmd 'autocmd FileType supercollider lua require "mappings".scnvim()'
            Cmd 'autocmd FileType supercollider setlocal wrap'
        end
    }

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

    use {
        'lukas-reineke/indent-blankline.nvim',
        branch = 'lua',
        config = function()
            G.indent_blankline_buftype_exclude = {'terminal'}
            G.indent_blankline_filetype_exclude = {'packer', 'netrw'}
            G.indent_blankline_char = '▏'
            G.indent_blankline_use_treesitter = true
            G.indent_blankline_show_trailing_blankline_indent = false
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
