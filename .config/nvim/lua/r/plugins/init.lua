-- -------------------------- Defs **********************************************************************
vim.keymap.set('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------

return {
    -- CamelCaseMotion
    'chaoren/vim-wordmotion',

    -- Colorscheme
    { 'folke/tokyonight.nvim', opts = { plugins = { mini_statusline = true } } },
    { 'rose-pine/neovim', name = 'rose-pine' },

    -- Unreal integration
    {
        'ranjithshegde/nvim-ue5',
        dev = true,
        config = function()
            local ue5 = require 'nvim-ue5'
            ue5.setup {
                unreal_engine_path = '/opt/unreal-engine/',
            }
            ue5.scan()
        end,
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
        opts = {
            preset = 'modern',
            show_help = false,
            show_keys = false,
            layout = { layout = { spacing = 15 } },
            win = { border = 'single' },
            triggers = {
                { '<auto>', mode = 'nixsotc' },
                { 'c', mode = { 'n', 'v' } },
                { 's', mode = { 'n', 'v' } },
            },
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
