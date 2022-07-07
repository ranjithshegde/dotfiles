---@diagnostic disable: missing-parameter
-- -------------------------- Defs **********************************************************************
local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- selfmanage packer
if not vim.loop.fs_stat(vim.fs.normalize(packer_path)) then
    ---@diagnostic disable-next-line: lowercase-global
    packer_bootstrap = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_path,
    }
end

local function is_custom(env, path, plugin)
    local check_path = vim.env[env] and vim.env[env] .. path
    if check_path and vim.loop.fs_stat(check_path) then
        return check_path
    else
        return plugin
    end
end

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return require("packer").startup {
    function(use)
        use "wbthomason/packer.nvim"

        use "lewis6991/impatient.nvim"

        -- Taglist and sidebars
        use { "simrat39/symbols-outline.nvim", module = "symbols-outline" }

        -- Tim pope
        use {
            { "tpope/vim-surround", event = "BufReadPost" },
            { "tpope/vim-dispatch", cmd = { "Make", "Dispatch", "Start" } },
            { "tpope/vim-fugitive", cmd = { "G", "Git", "Gclog" } },
        }

        -- Comment with TreeSitter
        use {
            "numToStr/Comment.nvim",
            keys = { "gc", "gb", "g>", "g<", { "v", "gc", "g<" }, { "v", "gb", "g>" } },
            config = function()
                require("Comment").setup { ignore = "^$", mappings = { extended = true } }
            end,
        }

        -- StatusLine
        use {
            "tjdevries/express_line.nvim",
            requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
            config = function()
                require("statusline").el()
            end,
        }

        -- Colorizer
        use {
            "xiyaowong/nvim-colorizer.lua",
            config = function()
                require("settings.plugin").color()
            end,
            cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        }

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPost",
            config = function()
                require("settings.plugin").indent()
            end,
        }

        -- SuperCollider
        use {
            "davidgranstrom/scnvim",
            ft = "supercollider",
            config = function()
                require("settings.plugin").scnvim()
            end,
        }

        --notify
        use {
            "rcarriga/nvim-notify",
            module = "notify",
            config = function()
                require("notify").setup { timeout = 1000, stages = "static" }
            end,
        }

        -- WhichKey
        use {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup {
                    layout = { width = { max = 80 }, { spacing = 10 } },
                }
            end,
        }

        -- Git Signs
        use {
            "lewis6991/gitsigns.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("settings.plugin").gitsigns()
            end,
            opt = true,
        }

        -- Fancy folds
        use {
            "kevinhwang91/nvim-ufo",
            rocks = "promise-async",
            event = "BufReadPost",
            config = function()
                require "settings.folds"()
            end,
        }

        --- Colorschemes
        use {
            -- "EdenEast/nightfox.nvim"
            --  "VonHeikemen/little-wonder"
            "catppuccin/nvim",
            as = "catppuccin",
            config = function()
                require("catppuccin").setup { integrations = { which_key = true, gitgutter = true } }
            end,
        }

        -- TreeSitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
                { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
                { "nvim-treesitter/nvim-treesitter-refactor", after = "scnvim" },
                { "nvim-treesitter/playground", module = "nvim-treesitter-playground" },
                { "Badhi/nvim-treesitter-cpp-tools", ft = { "c", "cpp", "opencl" } },
            },
        }

        -- Debugger adapter protocol
        use {
            {
                "mfussenegger/nvim-dap",
                config = function()
                    require("debugger").setup()
                end,
                opt = true,
            },
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    require("dapui").setup {
                        sidebar = { size = 80 },
                    }
                end,
                after = "nvim-dap",
            },
        }

        -- Orgmode
        use {
            "nvim-orgmode/orgmode",
            ft = "org",
            config = function()
                require("settings.plugin").org()
            end,
            requires = {
                {
                    is_custom("WORKSPACE", "Repos/orgWiki.nvim", "ranjithshegde/orgWiki.nvim"),
                    module = "orgWiki",
                    config = function()
                        require("orgWiki").setup {
                            disable_mappings = true,
                            wiki_path = { "~/Documents/Orgs/", "~/Documents/Projects/" },
                            diary_path = "~/Documents/Orgs/diary/",
                        }
                    end,
                },
            },
        }

        --Lsp config and companions
        use {
            "/home/ranjith/Software/Workspaces/Repos/nvim-lspconfig",
            branch = "0.7",
            requires = {
                {
                    "m-pilia/vim-ccls",
                    ft = { "c", "cpp", "opencl" },
                    config = function()
                        require("lsp.clangd").ccls()
                    end,
                },
                {
                    "folke/lua-dev.nvim",
                    ft = "lua",
                    config = function()
                        require "lsp.sumneko"()
                    end,
                },
                {
                    "p00f/clangd_extensions.nvim",
                    ft = { "c", "cpp", "opencl" },
                    config = function()
                        require("lsp.clangd").clangd()
                    end,
                },
            },
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            module = "telescope",
            cmd = "Telescope",
            config = function()
                require("settings.telescope").telescope()
            end,
            requires = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-project.nvim", after = "telescope-smart-history.nvim" },
                { "nvim-telescope/telescope-file-browser.nvim", after = "telescope-project.nvim" },
                {
                    "nvim-telescope/telescope-ui-select.nvim",
                    after = "telescope-file-browser.nvim",
                    config = function()
                        require("telescope").load_extension "ui-select"
                    end,
                },
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    after = "telescope.nvim",
                    run = "make",
                    config = function()
                        require("telescope").load_extension "fzf"
                    end,
                },
                {
                    "nvim-telescope/telescope-smart-history.nvim",
                    requires = { { "kkharji/sqlite.lua", module = "sqlite", rocks = "sqlite" } },
                    after = "telescope-fzf-native.nvim",
                    config = function()
                        require("telescope").load_extension "smart_history"
                    end,
                },
            },
        }

        -- completion and snippets
        use {
            { "hrsh7th/cmp-nvim-lsp", opt = "true" },
            {
                "L3MON4D3/LuaSnip",
                event = "InsertEnter",
                config = function()
                    require("settings.completion").luasnip()
                end,
                requires = {
                    {
                        "rafamadriz/friendly-snippets",
                        after = "LuaSnip",
                        config = function()
                            require("luasnip.loaders.from_vscode").load()
                        end,
                    },
                },
            },
            {
                "hrsh7th/nvim-cmp",
                after = "friendly-snippets",
                config = function()
                    require("settings.completion").init()
                end,
                requires = {
                    { "hrsh7th/cmp-path", after = "nvim-cmp" },
                    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                    {
                        "windwp/nvim-autopairs",
                        after = "nvim-cmp",
                        config = function()
                            require("settings.completion").pairs()
                        end,
                    },
                },
            },
        }

        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        compile_path = require("packer.util").join_paths(vim.fn.stdpath "config", "lua", "packer_compiled.lua"),
        profile = { enable = true, threshold = 0 },
        autoremove = true,
    },
}
