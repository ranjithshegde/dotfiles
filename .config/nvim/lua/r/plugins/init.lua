-- -------------------------- Defs **********************************************************************
vim.g.navigator = true
vim.keymap.set('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return {
    -- CamelCaseMotion
    'chaoren/vim-wordmotion',

    -- Colorscheme
    { 'folke/tokyonight.nvim', opts = { plugins = { mini_statusline = true } } },

    -- Unreal integration
    {
        'ranjithshegde/nvim-ue5',
        dev = true,
        lazy = false,
        config = function()
            require('nvim-ue5').setup {
                unreal_engine_path = '/opt/unreal-engine/',
            }
        end,
    },

    -- Fancy UI
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
        opts = { input = { relative = 'editor' } },
    },

    -- Comment with TreeSitter
    {
        'numToStr/Comment.nvim',
        keys = {
            { 'gc', mode = { 'n', 'v' } },
            { 'gb', mode = { 'n', 'v' } },
        },
        opts = { ignore = '^$' },
    },

    -- WhichKey
    {
        'folke/which-key.nvim',
        branch = 'release-please--branches--main--components--which-key.nvim',
        opts = {
            show_help = false,
            show_keys = false,
            layout = { layout = { spacing = 15 } },
            window = { border = 'single' },
        },
    },

    -- Colorizer
    {
        'NvChad/nvim-colorizer.lua',
        cmd = { 'ColorizerAttachToBuffer', 'ColorizerToggle' },
        config = function()
            require('colorizer').setup {
                filetypes = {
                    '*',
                    cpp = { AARRGGBB = true },
                    yaml = { AARRGGBB = true },
                    html = { mode = 'foreground' },
                    css = { rgb_fn = true, css_fn = true },
                },
            }
        end,
    },

    { 'milanglacier/yarepl.nvim', config = true, ft = 'python' },
}
