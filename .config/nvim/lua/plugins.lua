local u = require("utils")

-- -------------------------- Defs **********************************************************************
local fn = vim.fn
local camel = fn.stdpath("data") .. "/site/pack/plugins/opt/CamelCaseMotion"
local zephyr = fn.stdpath("data") .. "/site/pack/plugins/start/zephyr-nvim"
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Plugin autocommand
u.create_augroup(
    {
        {"BufWritePost, BufLeave", "plugins.lua", "PackerCompile"},
        {"BufReadPost", "*.conf", "setl ft=conf "},
        {"BufNewFile, BufReadPost", "*.vs,*.fs", "set ft=glsl"},
        {"FileType", "glsl", "packadd vim-glsl"}
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

-- Colorscheme zypher
if fn.empty(fn.glob(zephyr)) > 0 then
    fn.system({"git", "clone", "https://github.com/glepnir/zephyr-nvim.git", zephyr})
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

        use "vimwiki/vimwiki"

        use {"m-pilia/vim-ccls", ft = "cpp"}

        use {"yegappan/taglist", cmd = "TlistToggle"}

        use {"SirVer/ultisnips", ft = {"supercollider"}}

        use {"neovim/nvim-lspconfig", requires = {"nvim-lua/lsp-status.nvim"}}

        -- StatusLine
        use {"tjdevries/express_line.nvim", requires = {"kyazdani42/nvim-web-devicons", opt = true}}

        -- Coautoring
        use {
            "jbyuki/instant.nvim",
            config = function()
                G.instant_username = "Ranjith"
            end,
            opt = true
        }

        -- Java Lsp
        use {
            "mfussenegger/nvim-jdtls",
            ft = "java",
            config = function()
                require("settings").jdtls()
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
				Cmd'nmap <F5> <plug>(vimtex-compile)'
				Cmd'nmap <F6> <plug>(vimtex-view)'
				Cmd'nmap <F3> <plug>(vimtex-clean-full)'
            end
        }

        -- WhichKey
        use {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup {layout = {width = {max = 80}, {spacing = 10}}}
            end
        }

        -- Markdown preview
        -- use {
        -- 'iamcco/markdown-preview.nvim',
        -- run = function() fn['mkdp#util#install']() end,
        -- cmd = 'MarkdownPreview'
        -- }

        -- completion and snippets
        use {
            "ranjithshegde/completion-nvim",
            requires = {
                "windwp/nvim-autopairs",
                "hrsh7th/vim-vsnip",
                {"hrsh7th/vim-vsnip-integ"},
                opt = true
            }
        }

        -- Tim pope
        use {
            "tpope/vim-commentary",
            "tpope/vim-repeat",
            "tpope/vim-surround",
            "tpope/vim-unimpaired",
            {"tpope/vim-dispatch", cmd = {"Make", "Dispatch"}},
            {"tpope/vim-fugitive", cmd = {"G", "Git"}}
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim"
                -- 'nvim-telescope/telescope-symbols.nvim','nvim-telescope/telescope-project.nvim'
            }
        }

        -- Floating terminal
        use {
            "voldikss/vim-floaterm",
            config = function()
                G.floaterm_autoinsert = 1
                G.floaterm_autoclose = 1
                G.floaterm_keymap_new = "<F10>"
                G.floaterm_keymap_toggle = "<F9>"
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

        -- SuperCollider
        use {
            "davidgranstrom/scnvim",
            ft = "supercollider",
            run = function()
                fn["scnvim#install"]()
            end,
            config = function()
                -- G.scnvim_snippet_format = 'snippets.nvim'
                -- G.scnvim_scdoc = 1
                Cmd 'autocmd FileType supercollider lua require "mappings".scnvim()'
                Cmd "autocmd FileType supercollider setlocal wrap"
            end
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
            branch = "lua",
            config = function()
                G.indent_blankline_buftype_exclude = {"terminal"}
                G.indent_blankline_char = "┊"
                G.indent_blankline_space_char = "."
                G.indent_blankline_use_treesitter = true
                G.indent_blankline_show_current_context = true
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
