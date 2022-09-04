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
        -- manage self
        use "wbthomason/packer.nvim"

        -- Colorscheme
        use "EdenEast/nightfox.nvim"

        -- Better marks
        use { "ThePrimeagen/harpoon", module = "harpoon" }

        -- Databases
        use {
            "kristijanhusak/vim-dadbod-ui",
            cmd = "DBUI",
            opt = true,
            requires = { "tpope/vim-dadbod", "nanotee/sqls.nvim" },
        }

        -- Tasks
        use {
            "stevearc/overseer.nvim",
            module = "overseer",
            config = function()
                require("overseer").setup { templates = { "builtin", "r" } }
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

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            opt = true,
            config = function()
                require("r.settings.plugin").indent()
            end,
        }

        --notify
        use {
            "rcarriga/nvim-notify",
            module = "notify",
            config = function()
                require("notify").setup { top_down = false, timeout = 2000, stages = "static" }
            end,
        }

        -- Fancy UI
        use {
            "stevearc/dressing.nvim",
            module_pattern = "vim.ui.*",
            config = function()
                require("dressing").setup { input = { relative = "editor" } }
            end,
        }

        -- Colorizer
        use {
            "NvChad/nvim-colorizer.lua",
            config = function()
                require("r.settings.plugin").colorizer()
            end,
            cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        }

        -- StatusLine
        use {
            is_custom("WORKSPACE", "Repos/express_line.nvim", "ranjithshegde/express_line.nvim"),
            branch = "0.7",
            requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
            config = function()
                require "r.settings.statusline"()
            end,
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

        -- WhichKey
        use {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup {
                    layout = { layout = { spacing = 15 } },
                    window = { border = "single" },
                }
            end,
        }

        -- Git integration
        use {
            {
                "lewis6991/gitsigns.nvim",
                requires = "nvim-lua/plenary.nvim",
                config = function()
                    require("r.settings.plugin").gitsigns()
                end,
                opt = true,
            },
            { "tpope/vim-fugitive", cmd = { "G", "Git", "Gclog" } },
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

        -- Surround
        use {
            "kylechui/nvim-surround",
            keys = {
                { "n", "ys", "Add surround" },
                { "n", "ds", "Delete surround" },
                { "n", "cs", "Change surround" },
                { "v", "S", "Add surround" },
                { "n", "yS", "Add surround line" },
                { "v", "gS", "Add surround line" },
                { "n", "yss", "Add surround  current line" },
                { "n", "ySS", "Add surround  current line" },
            },
            config = function()
                require("r.settings.plugin").surround()
            end,
        }

        -- TreeSitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
                { "nvim-treesitter/nvim-treesitter-textobjects", module = "nvim-treesitter.textobjects" },
                { "nvim-treesitter/playground", module = "nvim-treesitter-playground" },
                { "Badhi/nvim-treesitter-cpp-tools", ft = { "c", "cpp", "opencl" } },
                {
                    "ThePrimeagen/refactoring.nvim",
                    module = "refactoring",
                    config = function()
                        require("r.settings.treesitter").refactoring()
                    end,
                },
            },
        }

        -- Comment with TreeSitter
        use {
            "numToStr/Comment.nvim",
            keys = {
                { "n", "gc", "Single Comment" },
                { "n", "gb", "Block Comment" },
                { "n", "g>", "Partial Comment right" },
                { "n", "g<", "Partial Comment left" },
                { "v", "gc", "Single Comment" },
                { "v", "gb", "Block Comment" },
                { "v", "g>", "Partial Comment right" },
                { "v", "g<", "Partial Comment left" },
            },
            config = function()
                require("Comment").setup {
                    mappings = { extended = true },
                    ignore = "^$",
                }
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
            "neovim/nvim-lspconfig",
            requires = {
                { "jose-elias-alvarez/null-ls.nvim", opt = true },
                {
                    "simrat39/symbols-outline.nvim",
                    module = "symbols-outline",
                    config = function()
                        require("symbols-outline").setup()
                    end,
                },
                {
                    is_custom("WORKSPACE", "Repos/ccls.nvim", "ranjithshegde/ccls.nvim"),
                    ft = { "c", "cpp", "opencl" },
                    config = function()
                        require("r.lsp.clangd").ccls()
                    end,
                },
                {
                    "folke/lua-dev.nvim",
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
                run = "make install_jsregexp",
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
