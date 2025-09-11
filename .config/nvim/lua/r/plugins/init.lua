-- -------------------------- Defs **********************************************************************
vim.keymap.set('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })

--------------------------------------------------------------------------------------------------------
--				                            Plugins                                            		  --
--------------------------------------------------------------------------------------------------------

return {
    -- Colorscheme
    {
        --[[ 
        { 'rebelot/kanagawa.nvim' },
        { 'EdenEast/nightfox.nvim' },
    ]]
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
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
            file_types = { 'markdown', 'codecompanion' },
            completions = { blink = { enabled = true } },
            document = { render_modes = true },
        },
        ft = { 'markdown', 'codecompanion' },
    },
}
