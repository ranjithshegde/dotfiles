-- -------------------------- Defs **********************************************************************
local u = require "utils"
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer = require "packer"

-- Plugin autocommand
u.create_augroup({
    { "BufWritePost, BufLeave", "plugins.lua", "PackerCompile" },
}, "PluginLoad")

-- selfmanage packer
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
end

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------

return packer.startup(function(use)
    use "wbthomason/packer.nvim"

    -- use "folke/tokyonight.nvim"

    use { "petrbroz/vim-glsl", ft = "glsl" }

    use { "m-pilia/vim-ccls", ft = "cpp" }

    use { "yegappan/taglist", cmd = "TlistToggle" }

    use { "bkad/CamelCaseMotion", opt = true }

    -- vimwiki
    use {
        "vimwiki/vimwiki",
        branch = "dev",
        ft = "vimwiki",
        keys = { "<leader>ww", "<leader>w<leader>w", "<leader>wi", "<leader>wt" },
    }

    -- new Commentary

    use {
        "winston0410/commented.nvim",
        config = function()
            require("commented").setup {
                keybindings = { n = "gc", v = "gc", nl = "gcc" },
            }
        end,
        keys = { "gc", { "v", "gc" } },
    }
    -- StatusLine
    use {
        "tjdevries/express_line.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("statusline").el()
        end,
    }

    -- Java Lsp
    use {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            require("settings").jdtls()
        end,
    }

    -- Coautoring
    use {
        "jbyuki/instant.nvim",
        config = function()
            G.instant_username = "Ranjith"
        end,
        opt = true,
    }

    -- SuperCollider
    use {
        "davidgranstrom/scnvim",
        ft = "supercollider",
        run = function()
            fn["scnvim#install"]()
        end,
    }

    -- Ultisnips for Scnvim
    use {
        "SirVer/ultisnips",
        ft = "supercollider",
        setup = function()
            require("settings").ultisnips()
        end,
    }

    -- Git Signs
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup { keymaps = {} }
        end,
        opt = true,
    }

    -- Markdown preview
    use {
        "iamcco/markdown-preview.nvim",
        run = function()
            fn["mkdp#util#install"]()
        end,
        ft = { "vimwiki", "markdown" },
    }

    -- Tim pope
    use {
        "tpope/vim-repeat",
        "tpope/vim-surround",
        { "tpope/vim-unimpaired", keys = { "[", "]" } },
        -- { "tpope/vim-commentary", keys = { "gc", { "v", "gc" } } },
        { "tpope/vim-dispatch", cmd = { "Make", "Dispatch" } },
        { "tpope/vim-fugitive", cmd = { "G", "Git", "Gclog" } },
    }

    -- vim Orgmode
    use {
        "kristijanhusak/orgmode.nvim",
        ft = "org",
        config = function()
            require("orgmode").setup {
                org_highlight_latex_and_related = "entities",
            }
        end,
    }

    -- WhichKey
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                layout = {
                    width = { max = 80 },
                    { spacing = 10 },
                },
            }
        end,
    }

    -- TreeSitter
    use {
        {
            "nvim-treesitter/nvim-treesitter",
            requires = { "p00f/nvim-ts-rainbow", "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        { "nvim-treesitter/nvim-treesitter-refactor", ft = "supercollider" },
        {
            "nvim-treesitter/playground",
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
        },
    }

    --Lsp config and companions
    use {
        {
            "neovim/nvim-lspconfig",
            requires = "nvim-lua/lsp-status.nvim",
        },
        {
            "folke/lua-dev.nvim",
            ft = "lua",
            config = function()
                require("settings").luadev()
            end,
        },
    }

    -- completion and snippets
    use {
        -- "nvim-lua/completion-nvim",
        { "ranjithshegde/completion-nvim", branch = "signature_hl_active" },
        "hrsh7th/vim-vsnip",
        {
            "hrsh7th/vim-vsnip-integ",
            opt = true,
            requires = {
                "rafamadriz/friendly-snippets",
            },
        },
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = function()
                local npairs = require "nvim-autopairs"
                local Rule = require "nvim-autopairs.rule"
                npairs.setup()
                npairs.add_rules { Rule("|", "|", "supercollider") }
            end,
        },
    }

    -- Colorizer
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {
                "*",
                html = { mode = "foreground" },
                css = { rgb_fn = true },
                "javascript",
                "sh",
                "conf",
            }
        end,
        cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
    }

    -- Telescope
    use {
        {
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                -- 'nvim-telescope/telescope-symbols.nvim',
            },
        },
        {
            "nvim-telescope/telescope-project.nvim",
            config = function()
                require("telescope").setup {
                    extensions = {
                        project = {
                            base_dirs = {
                                { "~/Software/Workspaces/", max_depth = 5 },
                                { "~/Documents/ofWorkspace/", max_depth = 4 },
                            },
                        },
                    },
                }
            end,
        },
    }

    -- Indents and chars
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            G.indent_blankline_char = "┊"
            G.indent_blankline_char_highlight = "LineNr"
            G.indent_blankline_use_treesitter = true
            G.indent_blankline_show_current_context = true
            G.indent_blankline_buftype_exclude = { "terminal", "nofile" }
            G.indent_blankline_filetype_exclude = { "help", "packer", "taglist" }
            G.indent_blankline_context_patterns = {
                "class",
                "return",
                "function",
                "method",
                "^if",
                "^while",
                "jsx_element",
                "^for",
                "inherits",
                "access_specifier",
                "^object",
                "^table",
                "block",
                "arguments",
                "^case",
                "^public",
                "^private",
                "^protected",
                "^switch",
                "if_statement",
                "else_clause",
                "jsx_element",
                "jsx_self_closing_element",
                "try_statement",
                "catch_clause",
                "import_statement",
                "operation_type",
            }
        end,
    }
end)
