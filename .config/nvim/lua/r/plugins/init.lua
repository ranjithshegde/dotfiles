-- -------------------------- Defs **********************************************************************
vim.g.navigator = true
vim.keymap.set('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return {
    -- Colorscheme
    'folke/tokyonight.nvim',

    -- CamelCaseMotion
    'chaoren/vim-wordmotion',

    -- Unreal integration
    {
        'ranjithshegde/Unreal.nvim',
        dev = true,
    },

    -- Fancy UI
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
        opts = { input = { relative = 'editor' } },
    },

    -- Treesitter indent guides
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufReadPost',
        main = 'ibl',
        -- opts = {},
        config = function()
            local highlight = {
                'RainbowRed',
                'RainbowYellow',
                'RainbowBlue',
                'RainbowOrange',
                'RainbowGreen',
                'RainbowViolet',
                'RainbowCyan',
            }
            local hooks = require 'ibl.hooks'
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
                vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require('ibl').setup { scope = { highlight = highlight } }

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
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
            show_help = false,
            show_keys = false,
            layout = { layout = { spacing = 15 } },
            window = { border = 'single' },
        },
        -- commit = '4acffc9',
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
}
