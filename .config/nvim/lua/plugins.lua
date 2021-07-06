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

        use {"m-pilia/vim-ccls", ft = "cpp"}

        use {"yegappan/taglist", cmd = "TlistToggle"}

        use {"SirVer/ultisnips", ft = "supercollider"}

        use {"neovim/nvim-lspconfig", requires = "nvim-lua/lsp-status.nvim"}

        -- StatusLine
        use {"tjdevries/express_line.nvim", requires = "kyazdani42/nvim-web-devicons"}

        -- vim Orgmode
        use {
            "kristijanhusak/orgmode.nvim",
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

        -- Git Signs
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup()
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

        -- completion and snippets
        use {
            "nvim-lua/completion-nvim",
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
            "tpope/vim-commentary",
            "tpope/vim-repeat",
            "tpope/vim-surround",
            "tpope/vim-unimpaired",
            {"tpope/vim-fugitive", cmd = {"G", "Git", "Gclog"}},
            {"tpope/vim-dispatch", cmd = {"Make", "Dispatch"}}
        }

        -- vim Calendar
        use {
            "itchyny/calendar.vim",
            cmd = "Calendar",
            config = function()
                G.calendar_google_calendar = 1
                G.calendar_google_task = 1
                vim.cmd("source ~/.cache/calendar.vim/credentials.vim")
            end
        }

        -- TreeSitter
        use {
            {
                "nvim-treesitter/nvim-treesitter",
                requires = {"p00f/nvim-ts-rainbow", "nvim-treesitter/nvim-treesitter-textobjects"}
            },
            {
                "nvim-treesitter/playground",
                cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}
            },
            {"nvim-treesitter/nvim-treesitter-refactor", ft = "supercollider"}
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

        -- vimTex
        use {
            "lervag/vimtex",
            ft = {"tex", "bib"},
            config = function()
                G.vimtex_viewer_method = "zathura"
                G.tex_conceal = "abdmg"
                G.vimtex_compiler_latexmk = {
                    options = {
                        "-shell-escape"
                    }
                }
                G.vimtex_compiler_latexmk_engines = {
                    _ = "-xelatex"
                }
            end
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            config = function()
                require("telescope").setup {
                    extensions = {
                        project = {
                            base_dirs = {
                                {"~/Software/Workspaces/", max_depth = 3},
                                {"~/Documents/ofWorkspace/", max_depth = 3}
                            }
                        }
                    }
                }
                require "telescope".load_extension("project")
            end,
            requires = {
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                -- 'nvim-telescope/telescope-symbols.nvim',
                "nvim-telescope/telescope-project.nvim"
            }
        }

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            -- branch = "lua",
            config = function()
                G.indent_blankline_char = "┊"
                G.indent_blankline_char_highlight = "LineNr"
                -- G.indent_blankline_space_char = "."
                G.indent_blankline_use_treesitter = true
                G.indent_blankline_show_current_context = true
                G.indent_blankline_buftype_exclude = {"terminal", "nofile"}
                G.indent_blankline_filetype_exclude = {"help", "packer"}
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
