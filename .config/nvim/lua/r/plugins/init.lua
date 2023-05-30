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
        commit = '4acffc9',
    },

    -- Treesitter indent guides
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufReadPost',
        config = function()
            require('indent_blankline').setup {
                show_current_context = true,
                use_treesitter = true,
            }
            for _, v in pairs(require('r.utils.tables').indentContext) do
                vim.cmd("let g:indent_blankline_context_patterns+=['" .. v .. "']")
            end
        end,
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
