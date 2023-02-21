-- -------------------------- Defs **********************************************************************
vim.g.navigator = true

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

    -- Granular semantic substitution
    {
        'tpope/vim-abolish',
        keys = 'cr',
        cmd = { 'Subverse', 'Abolish' },
    },

    -- Comment with TreeSitter
    {
        'numToStr/Comment.nvim',
        keys = { 'gc', { 'gc', mode = 'v' }, 'gb', { 'gb', mode = 'v' } },
        opts = { ignore = '^$' },
    },

    -- Fancy UI
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
        opts = { input = { relative = 'editor' } },
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
    },

    -- File browser/editor
    {
        'stevearc/oil.nvim',
        cmd = 'Oil',
        opts = { columns = { 'icon', 'size' }, view_options = { show_hidden = true } },
        init = function()
            vim.keymap.set('n', '<leader>e', function()
                require('oil').open_float(vim.loop.cwd())
            end, { desc = 'Open file explorer' })
        end,
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
