-- -------------------------- Defs **********************************************************************
vim.keymap.set('n', '<leader>p', require('lazy').sync, { desc = 'Update plugins' })

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------

return {
    -- Colorscheme
    { 'rose-pine/neovim', name = 'rose-pine', opts = { styles = { transparency = true } } },

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

    -- Python REPL
    { 'milanglacier/yarepl.nvim', config = true, ft = 'python' },

    -- Modular bufferline
    {
        'Bekaboo/dropbar.nvim',
        event = 'BufReadPost',
        opts = {
            sources = { treesitter = { valid_types = require('r.utils.tables').tsNodes } },
            icons = { kinds = { symbols = require('r.utils.tables').nodeSymbols } },
        },
    },
}
