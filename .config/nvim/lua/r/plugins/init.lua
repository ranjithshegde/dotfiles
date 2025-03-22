-- -------------------------- Defs **********************************************************************
vim.keymap.set('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })

--------------------------------------------------------------------------------------------------------
--				                            Plugins                                            		  --
--------------------------------------------------------------------------------------------------------

return {
    -- Colorscheme
    {
        {
            'neko-night/nvim',
            name = 'nekonight',
            config = function()
                require('nekonight').setup {
                    transparent = true,
                    on_highlights = function(hl, c)
                        hl.Folded = { bg = c.bg_dark1 }
                    end,
                }
            end,
        },
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
            layout = { spacing = 10 },
            win = { border = 'rounded' },
            triggers = {
                { '<auto>', mode = 'nixsotc' },
                { 'c', mode = { 'n', 'v' } },
                { 's', mode = { 'n', 'v' } },
            },
        },
    },

    -- Modular bufferline
    {
        'Bekaboo/dropbar.nvim',
        event = 'BufReadPost',
        opts = {
            sources = { treesitter = { valid_types = require('r.utils.tables').tsNodes } },
            icons = { kinds = { symbols = require('r.utils.tables').nodeSymbols } },
        },
    },

    -- Markdown and orgmode headlines
    {
        'lukas-reineke/headlines.nvim',
        ft = 'markdown',
        opts = { org = { codeblock_highlight = '' } },
    },
}
