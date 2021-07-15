local u = require("utils")

-- -------------------------- Defs **********************************************************************
local fn = vim.fn
local camel = fn.stdpath("data") .. "/site/pack/plugins/opt/CamelCaseMotion"
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Plugin autocommand
u.create_augroup(
    {
        {"BufWritePost, BufLeave", "plugins.lua", "PackerCompile"}
    },
    "PluginLoad"
)

--------------------------------------------------------------------------------------------------------
--				Custom Plugins 							      --
--------------------------------------------------------------------------------------------------------
-- CamelCaseMotion
if fn.empty(fn.glob(camel)) > 0 then
    fn.system({"git", "clone", "https://github.com/bkad/CamelCaseMotion.git", camel})
end

-- selfmanage packer
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
end

--------------------------------------------------------------------------------------------------------
--				Main Plugins 							      --
--------------------------------------------------------------------------------------------------------
local packer = require("packer")

return packer.startup(
    function(use)
        use "wbthomason/packer.nvim"

        use "folke/tokyonight.nvim"

        use {"m-pilia/vim-ccls", ft = "cpp"}

        use {"yegappan/taglist", cmd = "TlistToggle"}

        -- StatusLine
        use {"tjdevries/express_line.nvim", requires = "kyazdani42/nvim-web-devicons"}

        -- vim Orgmode
        use {
            "kristijanhusak/orgmode.nvim",
            ft = "org",
            config = function()
                require("orgmode").setup {}
            end
        }

        -- Java Lsp
        use {
            "mfussenegger/nvim-jdtls",
            ft = "java",
            config = function()
                require("settings").jdtls()
            end
        }

        -- Coautoring
        use {
            "jbyuki/instant.nvim",
            config = function()
                G.instant_username = "Ranjith"
            end,
            opt = true
        }

        -- SuperCollider
        use {
            "davidgranstrom/scnvim",
            ft = "supercollider",
            run = function()
                fn["scnvim#install"]()
            end
        }

        -- Ultisnips for Scnvim
        use {
            "SirVer/ultisnips",
            ft = "supercollider",
            setup = function()
                require("settings").ultisnips()
            end
        }

        -- Git Signs
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup()
                -- print("gitssigns gitsgns")
            end,
            opt = true
        }

        -- Markdown preview
        use {
            "iamcco/markdown-preview.nvim",
            run = function()
                fn["mkdp#util#install"]()
            end,
            ft = {"vimwiki", "markdown"}
        }

        -- vimwiki
        use {
            "vimwiki/vimwiki",
            branch = "dev",
            ft = "vimwiki",
            keys = {"<leader>ww", "<leader>w<leader>w", "<leader>wi", "<leader>wt"}
        }

        -- WhichKey
        use {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup {
                    layout = {
                        width = {max = 80},
                        {spacing = 10}
                    }
                }
            end
        }

        --Lsp config and companions
        use {
            {
                "neovim/nvim-lspconfig",
                requires = "nvim-lua/lsp-status.nvim"
            },
            {
                "folke/lua-dev.nvim",
                ft = "lua",
                config = function()
                    require("settings").luadev()
                end
            }
        }

        -- completion and snippets
        use {
            -- "nvim-lua/completion-nvim",
            {"ranjithshegde/completion-nvim", branch = "signature_hl_active"},
            "windwp/nvim-autopairs",
            "hrsh7th/vim-vsnip",
            {
                "hrsh7th/vim-vsnip-integ",
                opt = true,
                requires = {
                    "rafamadriz/friendly-snippets"
                }
            }
        }

        -- Tim pope
        use {
            "tpope/vim-repeat",
            "tpope/vim-unimpaired",
            "tpope/vim-surround",
            {"tpope/vim-commentary", keys = "gc"},
            {"tpope/vim-dispatch", cmd = {"Make", "Dispatch"}},
            {"tpope/vim-fugitive", cmd = {"G", "Git", "Gclog"}}
        }

        -- vim Calendar
        use {
            "itchyny/calendar.vim",
            cmd = "Calendar",
            config = function()
                G.calendar_google_task = 1
                G.calendar_google_calendar = 1
                vim.cmd("source ~/.cache/calendar.vim/credentials.vim")
            end
        }

        -- Telescope
        use {
            "ranjithshegde/telescope.nvim",
            branch = "change_dir",
            requires = {
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                -- 'nvim-telescope/telescope-symbols.nvim',
                "nvim-telescope/telescope-project.nvim"
            }
        }

        -- TreeSitter
        use {
            {
                "nvim-treesitter/nvim-treesitter",
                requires = {"p00f/nvim-ts-rainbow", "nvim-treesitter/nvim-treesitter-textobjects"}
            },
            {"nvim-treesitter/nvim-treesitter-refactor", ft = "supercollider"},
            {
                "nvim-treesitter/playground",
                cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}
            }
        }

        -- Colorizer
        use {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require "colorizer".setup {
                    "*",
                    html = {mode = "foreground"},
                    css = {rgb_fn = true},
                    "javascript",
                    "sh",
                    "conf"
                }
            end,
            cmd = {"ColorizerAttachToBuffer", "ColorizerToggle"}
        }

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                G.indent_blankline_char = "┊"
                G.indent_blankline_char_highlight = "LineNr"
                G.indent_blankline_use_treesitter = true
                G.indent_blankline_show_current_context = true
                G.indent_blankline_buftype_exclude = {"terminal", "nofile"}
                G.indent_blankline_filetype_exclude = {"help", "packer", "taglist"}
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
                    "operation_type"
                }
            end
        }
    end
)
