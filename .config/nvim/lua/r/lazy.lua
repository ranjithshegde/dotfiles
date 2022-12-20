-- -------------------------- Defs **********************************************************************

local dev_path = vim.env.WORKSPACE .. 'Repos/'

local function use_custom(path)
    local check_path = dev_path and dev_path .. path
    if check_path and vim.loop.fs_stat(check_path) then
        return true
    else
        return false
    end
end

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

local function load_plugin_on_key(mode, key, desc, callback, args, pkg)
    if package.loaded[pkg] then
        return
    end
    vim.keymap.set(mode, key, function()
        vim.keymap.del(mode, key)
        callback(args)
        key = string.gsub(key, '<leader>', '\\')
        vim.api.nvim_feedkeys(key, 'm', false)
    end, { desc = desc })
end

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return require('lazy').setup({
    -- Colorscheme
    { 'folke/tokyonight.nvim', lazy = false },

    -- Better marks
    'ThePrimeagen/harpoon',

    -- Granular semantic substitution
    { 'tpope/vim-abolish', cmd = { 'Subverse', 'Abolish' } },

    -- Databases
    {
        'kristijanhusak/vim-dadbod-ui',
        cmd = 'DBUI',
        dependencies = { 'tpope/vim-dadbod', 'nanotee/sqls.nvim' },
    },

    -- Tasks
    {
        'stevearc/overseer.nvim',
        config = function()
            require('r.plugins').overseer()
        end,
    },

    -- SuperCollider
    {
        'davidgranstrom/scnvim',
        ft = 'supercollider',
        config = function()
            require('r.plugins').scnvim()
        end,
    },

    -- Indents and chars
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('r.plugins').indent()
        end,
    },

    -- Fancy UI
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
        config = function()
            require('dressing').setup { input = { relative = 'editor' } }
        end,
    },

    -- Colorizer
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('r.plugins').colorizer()
        end,
        cmd = { 'ColorizerAttachToBuffer', 'ColorizerToggle' },
    },

    -- Fancy UI
    {
        'folke/noice.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
        event = 'VimEnter',
        config = function()
            require 'r.plugins.noice'
        end,
    },

    -- Fancy folds
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = function()
            require 'r.plugins.folds'()
        end,
    },

    -- StatusLine
    {
        'ranjithshegde/express_line.nvim',
        dev = use_custom 'express_line.nvim',
        lazy = false,
        branch = '0.7',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'r.plugins.statusline'()
        end,
    },

    -- Debugger adapter protocol
    {
        'mfussenegger/nvim-dap',
        config = function()
            require('r.debuggers').setup()
        end,
        dependencies = 'rcarriga/nvim-dap-ui',
    },

    -- WhichKey
    {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {
                show_help = false,
                show_keys = false,
                layout = { layout = { spacing = 15 } },
                window = { border = 'single' },
            }
        end,
    },

    -- Git integration
    {
        {
            'lewis6991/gitsigns.nvim',
            dependencies = 'nvim-lua/plenary.nvim',
            config = function()
                require('r.plugins').gitsigns()
            end,
        },
        { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gclog' } },
    },

    -- Telescope
    {
        {
            'nvim-telescope/telescope.nvim',
            cmd = 'Telescope',
            config = function()
                require('r.plugins.telescope').telescope()
            end,
            dependencies = {
                { 'nvim-lua/plenary.nvim' },
                { 'nvim-telescope/telescope-project.nvim' },
            },
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        { 'nvim-telescope/telescope-file-browser.nvim' },
    },

    -- TreeSitter
    {
        { 'nvim-treesitter/nvim-treesitter', lazy = false, build = ':TSUpdate' },
        { 'p00f/nvim-ts-rainbow', event = 'BufReadPre' },
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'Badhi/nvim-treesitter-cpp-tools', ft = { 'c', 'cpp', 'opencl' } },
        {
            'ThePrimeagen/refactoring.nvim',

            config = function()
                require('r.plugins.treesitter').refactoring()
            end,
        },
    },

    -- Comment with TreeSitter
    {
        'numToStr/Comment.nvim',
        init = function()
            load_plugin_on_key({ 'n', 'v' }, 'gc', 'Single comment', require('lazy').load, 'Comment.nvim', 'Comment')
            load_plugin_on_key({ 'n', 'v' }, 'gb', 'Block comment', require('lazy').load, 'Comment.nvim', 'Comment')
        end,
        keys = 'gcc',
        config = function()
            require('Comment').setup {
                ignore = '^$',
            }
        end,
    },

    -- Surround with TreeSitter
    {
        'kylechui/nvim-surround',
        init = function()
            load_plugin_on_key('n', 'ys', 'Surround', require('lazy').load, 'nvim-surround', 'nvim-surround')
            load_plugin_on_key('n', 'ds', 'Delete surround', require('lazy').load, 'nvim-surround', 'nvim-surround')
            load_plugin_on_key('n', 'cs', 'Change surround', require('lazy').load, 'nvim-surround', 'nvim-surround')
            load_plugin_on_key('v', 'S', 'Surround', require('lazy').load, 'nvim-surround', 'nvim-surround')
            load_plugin_on_key('n', 'yS', 'Surround line', require('lazy').load, 'nvim-surround', 'nvim-surround')
            load_plugin_on_key('v', 'gS', 'Surround line', require('lazy').load, 'nvim-surround', 'nvim-surround')
            -- load_plugin_on_key('n', 'yss', 'Surround line', require('lazy').load, 'nvim-surround', 'nvim-surround')
            -- load_plugin_on_key('n', 'ySS', 'Surround line', require('lazy').load, 'nvim-surround', 'nvim-surround')
        end,
        config = function()
            require('r.plugins').surround()
        end,
    },

    -- Orgmode
    {
        {
            'nvim-orgmode/orgmode',
            ft = 'org',
            config = function()
                require('r.plugins').org()
            end,
        },
        {
            'ranjithshegde/orgWiki.nvim',
            dev = use_custom 'orgWiki.nvim',
            config = function()
                require('orgWiki').setup {
                    disable_mappings = true,
                    wiki_path = { '~/Documents/Orgs/', '~/Documents/Projects/' },
                    diary_path = '~/Documents/Orgs/diary/',
                }
            end,
        },
    },

    --Lsp config and companions
    {
        'neovim/nvim-lspconfig',
        { 'jose-elias-alvarez/null-ls.nvim' },
        { 'Hoffs/omnisharp-extended-lsp.nvim', ft = 'cs' },
        {
            'ranjithshegde/ccls.nvim',
            dev = use_custom 'ccls.nvim',
            ft = { 'c', 'cpp', 'opencl' },
            config = function()
                require('r.lsp.clangd').ccls()
            end,
        },
        {
            'folke/neodev.nvim',
            ft = 'lua',
            config = function()
                require('r.plugins').neodev()
            end,
        },
        {
            'p00f/clangd_extensions.nvim',
            ft = { 'c', 'cpp', 'opencl' },
            config = function()
                require('r.lsp.clangd').clangd()
            end,
        },
    },

    -- completion and snippets
    {
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                { 'hrsh7th/cmp-nvim-lsp' },
                {
                    'windwp/nvim-autopairs',
                    config = function()
                        require('r.plugins.completion').pairs()
                    end,
                },
            },
            config = function()
                require('r.plugins.completion').init()
            end,
        },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        {
            'L3MON4D3/LuaSnip',
            build = 'make install_jsregexp',
            dependencies = 'rafamadriz/friendly-snippets',
            config = function()
                require('r.plugins.completion').luasnip()
            end,
        },
    },
}, {
    dev = { path = dev_path },
    rtp = { disabled_plugins = require('r.utils.tables').disabled_builtins },
    debug = true,
    defaults = { lazy = true },
})
