---@diagnostic disable: missing-parameter
-- -------------------------- Defs **********************************************************************
local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- selfmanage packer
local packer_bootstrap = false
if not vim.loop.fs_stat(vim.fs.normalize(packer_path)) then
    packer_bootstrap = true
    vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. packer_path)
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

        use "EdenEast/nightfox.nvim"

        -- Tim pope
        use {
            { "tpope/vim-dispatch", cmd = { "Make", "Dispatch", "Start" } },
            { "tpope/vim-fugitive", cmd = { "G", "Git", "Gclog" } },
        }

        -- Databases
        use {
            "kristijanhusak/vim-dadbod-ui",
            cmd = "DBUI",
            opt = true,
            requires = { "tpope/vim-dadbod", "nanotee/sqls.nvim" },
        }

        -- surround
        use {
            "kylechui/nvim-surround",
            opt = true,
            config = function()
                require("nvim-surround").setup {}
            end,
        }

        -- StatusLine
        use {
            "tjdevries/express_line.nvim",
            requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
            config = function()
                require "r.settings.statusline"()
            end,
        }

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            opt = true,
            config = function()
                require("r.settings.plugin").indent()
            end,
        }

        -- SuperCollider
        use {
            "davidgranstrom/scnvim",
            ft = "supercollider",
            config = function()
                require("r.settings.plugin").scnvim()
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

        -- Fancy UI
        use {
            "stevearc/dressing.nvim",
            module_pattern = "vim.ui.*",
            config = function()
                require("dressing").setup { input = { prompt_align = "right" } }
            end,
        }

        -- Colorizer
        use {
            "xiyaowong/nvim-colorizer.lua",
            config = function()
                require("r.settings.plugin").color()
            end,
            cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
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
                require("r.settings.plugin").gitsigns()
            end,
            opt = true,
        }

        -- Fancy folds
        use {
            "kevinhwang91/nvim-ufo",
            rocks = "promise-async",
            opt = true,
            config = function()
                require "r.settings.folds"()
            end,
        }

        -- Debugger adapter protocol
        use {
            "mfussenegger/nvim-dap",
            config = function()
                require("r.debugger").setup()
            end,
            opt = true,
            requires = "rcarriga/nvim-dap-ui",
        }

        -- ZenMode
        use {
            "Pocco81/true-zen.nvim",
            requires = { { "folke/twilight.nvim", opt = true } },
            cmd = "TZAtaraxis",
            config = function()
                require("r.settings.plugin").zenmode()
            end,
        }

        -- Tasks
        use {
            "stevearc/overseer.nvim",
            branch = "stevearc-quickfix",
            opt = true,
            config = function()
                require("overseer").setup()
                require "r.settings.build"()
            end,
        }

        -- TreeSitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
                { "nvim-treesitter/nvim-treesitter-textobjects", module = "nvim-treesitter.textobjects" },
                { "nvim-treesitter/nvim-treesitter-refactor", after = "scnvim" },
                { "nvim-treesitter/playground", module = "nvim-treesitter-playground" },
                { "Badhi/nvim-treesitter-cpp-tools", ft = { "c", "cpp", "opencl" } },
            },
        }

        -- Telescope
        use {
            {
                "nvim-telescope/telescope.nvim",
                module = "telescope",
                cmd = "Telescope",
                config = function()
                    require("r.settings.telescope").telescope()
                end,
                requires = "nvim-lua/plenary.nvim",
            },
            { "nvim-telescope/telescope-fzf-native.nvim", opt = true, run = "make" },
            { "nvim-telescope/telescope-project.nvim", after = "telescope.nvim" },
            { "nvim-telescope/telescope-file-browser.nvim", module_pattern = ".*.extensions.file_browser.*" },
        }

        -- Comment with TreeSitter
        use {
            "numToStr/Comment.nvim",
            keys = require("r.settings.plugin").comment.keys,
            config = function()
                require("r.settings.plugin").comment.config()
            end,
        }

        -- Orgmode
        use {
            "nvim-orgmode/orgmode",
            ft = "org",
            config = function()
                require("r.settings.plugin").org()
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
            is_custom("WORKSPACE", "Repos/nvim-lspconfig", "ranjithshegde/nvim-lspconfig"),
            branch = "0.8",
            requires = {
                { "jose-elias-alvarez/null-ls.nvim", opt = true },
                { "simrat39/symbols-outline.nvim", module = "symbols-outline" },
                {
                    "m-pilia/vim-ccls",
                    ft = { "c", "cpp", "opencl" },
                    config = function()
                        require("r.lsp.clangd").ccls()
                    end,
                },
                {
                    is_custom("WORKSPACE", "Repos/lua-dev.nvim", "folke/lua-dev.nvim"),
                    ft = "lua",
                    config = function()
                        require "r.lsp.sumneko"()
                    end,
                },
                {
                    "p00f/clangd_extensions.nvim",
                    ft = { "c", "cpp", "opencl" },
                    config = function()
                        require("r.lsp.clangd").clangd()
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
                    require("r.settings.completion").luasnip()
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
                    require("r.settings.completion").init()
                end,
                requires = {
                    { "hrsh7th/cmp-path", after = "nvim-cmp" },
                    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                    {
                        "windwp/nvim-autopairs",
                        after = "nvim-cmp",
                        config = function()
                            require("r.settings.completion").pairs()
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
        compile_path = require("packer.util").join_paths(vim.fn.stdpath "config", "lua", "r", "packer_compiled.lua"),
        profile = { enable = true, threshold = 0 },
        autoremove = true,
    },
}
