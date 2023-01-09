-- -------------------------- Defs **********************************************************************

local dev_path = nil

if vim.fn.has 'win32' == 1 then
    vim.g.is_win32 = true
    dev_path = vim.fs.normalize '~/Repos/Gits/'
else
    vim.g.is_win32 = false
    dev_path = vim.env.WORKSPACE .. 'Repos/'
end

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

local function setup(module, key, config)
    return function()
        if key then
            require(module)[key](config)
        else
            require(module)()
        end
    end
end

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return require('lazy').setup({
    -- Colorscheme
    'folke/tokyonight.nvim',

    -- Better marks
    'ThePrimeagen/harpoon',

    -- CamelCaseMotion
    'chaoren/vim-wordmotion',

    -- Tasks
    {
        'stevearc/overseer.nvim',
        config = setup('r.plugins', 'overseer'),
    },

    {
        'ranjithshegde/Unreal.nvim',
        dev = use_custom 'Unreal.nvim',
    },

    -- Granular semantic substitution
    {
        'tpope/vim-abolish',
        keys = 'cr',
        cmd = { 'Subverse', 'Abolish' },
    },

    -- Debugger adapter protocol
    {
        'mfussenegger/nvim-dap',
        config = setup('r.debuggers', 'setup'),
        dependencies = 'rcarriga/nvim-dap-ui',
    },

    -- SuperCollider
    {
        'davidgranstrom/scnvim',
        ft = 'supercollider',
        config = setup('r.plugins', 'scnvim'),
    },

    -- Surround with TreeSitter
    {
        'kylechui/nvim-surround',
        keys = { 'ys', 'yss', 'ySS', 'cs', 'ds', { 'S', mode = 'v' } },
        config = setup('r.plugins', 'surround'),
    },

    -- Comment with TreeSitter
    {
        'numToStr/Comment.nvim',
        keys = { 'gc', { 'gc', mode = 'v' }, 'gb', { 'gb', mode = 'v' } },
        config = { ignore = '^$' },
    },

    -- Treesitter indent guides
    {
        'lukas-reineke/indent-blankline.nvim',
        config = setup('r.plugins', 'indent'),
        event = 'BufReadPost',
    },

    -- Colorizer
    {
        'NvChad/nvim-colorizer.lua',
        cmd = { 'ColorizerAttachToBuffer', 'ColorizerToggle' },
        config = setup('r.plugins', 'colorizer'),
    },

    -- Fancy UI
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
        config = { input = { relative = 'editor' } },
    },

    -- Fancy folds
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = setup 'r.plugins.folds',
        event = 'BufReadPost',
    },

    -- Fancy UI
    {
        'folke/noice.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
        event = 'VimEnter',
        config = setup 'r.plugins.noice',
    },

    -- StatusLine
    {
        'ranjithshegde/express_line.nvim',
        dev = use_custom 'express_line.nvim',
        event = 'UIEnter',
        branch = '0.7',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
        config = setup 'r.plugins.statusline',
    },

    -- Git integration
    {
        {
            'lewis6991/gitsigns.nvim',
            dependencies = 'nvim-lua/plenary.nvim',
            config = setup('r.plugins', 'gitsigns'),
        },
        { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gclog' } },
    },

    -- WhichKey
    {
        'folke/which-key.nvim',
        config = {
            show_help = false,
            show_keys = false,
            layout = { layout = { spacing = 15 } },
            window = { border = 'single' },
        },
    },

    -- TreeSitter
    {
        { 'nvim-treesitter/nvim-treesitter', lazy = false, build = ':TSUpdate' },
        { 'p00f/nvim-ts-rainbow', event = 'BufReadPre' },
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'Badhi/nvim-treesitter-cpp-tools', ft = { 'c', 'cpp', 'opencl' } },
        {
            'ThePrimeagen/refactoring.nvim',
            config = setup('r.plugins.treesitter', 'refactoring'),
        },
    },

    -- Telescope
    {
        {
            'nvim-telescope/telescope.nvim',
            init = function()
                require('r.utils').lazy_on_key('n', '<Space>', 'Telescope', require, 'r.mappings.telescope')
            end,
            cmd = 'Telescope',
            dependencies = 'nvim-lua/plenary.nvim',
            config = setup('r.plugins.telescope', 'telescope'),
        },
        'nvim-telescope/telescope-project.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    -- Orgmode
    {
        {
            'nvim-orgmode/orgmode',
            ft = 'org',
            config = setup('r.plugins', 'org'),
        },
        {
            'ranjithshegde/orgWiki.nvim',
            dev = use_custom 'orgWiki.nvim',
            init = function()
                require('r.utils').lazy_on_key('n', '<leader>w', 'OrgWiki', function()
                    require('r.mappings.util').orgWiki()
                end)
            end,
            config = {
                disable_mappings = true,
                wiki_path = { '~/Documents/Orgs/', '~/Documents/Projects/' },
                diary_path = '~/Documents/Orgs/diary/',
            },
        },
    },

    -- completion and snippets
    {
        {
            'L3MON4D3/LuaSnip',
            build = 'make install_jsregexp',
            dependencies = 'rafamadriz/friendly-snippets',
            config = setup('r.plugins.completion', 'luasnip'),
        },
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'saadparwaiz1/cmp_luasnip',
                {
                    'windwp/nvim-autopairs',
                    config = setup('r.plugins.completion', 'pairs'),
                },
            },
            config = setup('r.plugins.completion', 'init'),
        },
    },

    --Lsp config and companions
    {
        { 'Hoffs/omnisharp-extended-lsp.nvim', ft = 'cs' },
        {
            'folke/neodev.nvim',
            config = setup('r.plugins', 'neodev'),
        },
        {
            'p00f/clangd_extensions.nvim',
            ft = { 'c', 'cpp', 'opencl' },
            config = setup('r.lsp.clangd', 'clangd'),
        },
        {
            'ranjithshegde/ccls.nvim',
            dev = use_custom 'ccls.nvim',
            ft = { 'c', 'cpp', 'opencl' },
            config = setup('r.lsp.clangd', 'ccls'),
        },
        {
            'neovim/nvim-lspconfig',
            ft = require('r.utils.tables').lspfiles,
            dependencies = 'jose-elias-alvarez/null-ls.nvim',
            config = function()
                require('r.lsp').servers()
                require('r.lsp').lintFormat()
            end,
        },
    },
}, {
    ui = { border = 'double' },
    dev = { path = dev_path },
    performance = { rtp = { disabled_plugins = require('r.utils.tables').rtp } },
    defaults = { lazy = true },
    install = { colorscheme = { 'tokyonight' } },
})
