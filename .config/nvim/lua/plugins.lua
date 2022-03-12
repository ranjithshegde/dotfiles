-- -------------------------- Defs **********************************************************************
local fn = vim.fn
local packer_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- selfmanage packer
if fn.empty(fn.glob(packer_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path }
end

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return require("packer").startup {
    function(use)
        use "wbthomason/packer.nvim"

        use "lewis6991/impatient.nvim"

        use "EdenEast/nightfox.nvim"

        use { "petrbroz/vim-glsl", ft = "glsl" }

        use { "bkad/CamelCaseMotion", opt = true }

        -- Tim pope
        use {
            { "tpope/vim-surround", event = "BufRead" },
            { "tpope/vim-unimpaired", keys = { "[", "]" } },
            { "tpope/vim-dispatch", cmd = { "Make", "Dispatch" } },
            { "tpope/vim-fugitive", cmd = { "G", "Git", "Gclog" } },
        }

        -- vimwiki
        use {
            "vimwiki/vimwiki",
            branch = "dev",
            ft = "vimwiki",
            keys = { "<leader>ww", "<leader>w<leader>w", "<leader>wi", "<leader>wt", "<leader>wn" },
        }

        -- Fold text
        use {
            "anuvyklack/pretty-fold.nvim",
            event = "BufReadPost",
            config = function()
                require("settings").folds()
            end,
        }

        -- StatusLine
        use {
            "tjdevries/express_line.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("statusline").el()
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

        -- Git Signs
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup { keymaps = {} }
                require("mappings").git()
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

        -- Comment with TreeSitter
        use {
            "numToStr/Comment.nvim",
            keys = { "gc", "gb", { "v", "gc" }, { "v", "gb" } },
            config = function()
                require("Comment").setup { ignore = "^$" }
            end,
        }

        -- SuperCollider
        use {
            "davidgranstrom/scnvim",
            ft = "supercollider",
            run = function()
                fn["scnvim#install"]()
            end,
            config = function()
                require("mappings").scnvim()
                G.scnvim_snippet_format = "luasnip"
                require("luasnip").snippets.supercollider = require("scnvim/utils").get_snippets()
                vim.opt_local.wrap = true
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

        -- Taglist and sidebars
        use {
            -- { "yegappan/taglist", cmd = "TlistToggle"},
            { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" },
            {
                "sidebar-nvim/sidebar.nvim",
                cmd = "SidebarNvimToggle",
                config = function()
                    require("sidebar-nvim").setup {
                        sections = { "buffers", "files", "symbols" },
                    }
                end,
            },
        }

        -- TreeSitter
        use {
            {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
            },
            { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
            { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
            { "nvim-treesitter/nvim-treesitter-refactor", after = "scnvim" },
            -- {
            --     "nvim-treesitter/playground",
            --     cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
            -- },
        }

        -- Colorizer
        use {
            "afonsocraposo/nvim-colorizer.lua",
            config = function()
                require("colorizer").setup {
                    "*",
                    cpp = { rgb_0x = true },
                    html = { mode = "foreground" },
                    css = { rgb_fn = true, css_fn = true },
                    "javascript",
                    "conf",
                }
            end,
            cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
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

        -- vim Orgmode
        use {
            {
                "nvim-orgmode/orgmode",
                ft = "org",
                config = function()
                    require("orgmode").setup_ts_grammar()
                    require("orgmode").setup {
                        org_agenda_files = "~/Documents/Orgs/*",
                        org_highlight_latex_and_related = "entities",
                        emacs_config = { config_path = "$XDG_CONFIG_HOME/emacs/init.el" },
                    }
                end,
            },
            {
                "akinsho/org-bullets.nvim",
                after = "orgmode",
                config = function()
                    require("org-bullets").setup {}
                end,
            },
        }

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPost",
            config = function()
                G.indent_blankline_char = "┊"
                require("indent_blankline").setup {
                    show_current_context = true,
                    show_end_of_line = true,
                    use_treesitter = true,
                }
                vim.cmd "let g:indent_blankline_filetype_exclude+=['taglist']"
                -- stylua: ignore
                local context = {
                    "^for", "^case", "block", "^table", "return", "^while", "^public", "^switch",
                    "^object", "inherits", "^private", "^protected", "jsx_element", "jsx_element",
                    "else_clause", "if_statement", "catch_clause", "try_statement", "operation_type",
                    "access_specifier", "import_statement", "jsx_self_closing_element",
                }
                for _, v in pairs(context) do
                    vim.cmd("let g:indent_blankline_context_patterns+=['" .. v .. "']")
                end
            end,
        }

        --Lsp config and companions
        use {
            "neovim/nvim-lspconfig",
            { "nvim-lua/lsp-status.nvim", opt = true },
            {
                "folke/lua-dev.nvim",
                ft = "lua",
                config = function()
                    require("settings").luadev()
                end,
            },
            {
                "mfussenegger/nvim-jdtls",
                ft = "java",
                config = function()
                    require("settings").jdtls()
                end,
            },
            { "m-pilia/vim-ccls", ft = { "c", "cpp" } },
            {
                "p00f/clangd_extensions.nvim",
                ft = { "c", "cpp" },
                config = function()
                    require("settings").clangd()
                end,
            },
        }

        -- completion and snippets
        use {
            "L3MON4D3/LuaSnip",
            {
                "ranjithshegde/completion-nvim",
                config = function()
                    require("settings").completion()
                end,
            },
            {
                "rafamadriz/friendly-snippets",
                event = "InsertEnter",
                config = function()
                    require("luasnip.loaders.from_vscode").load()
                end,
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

        -- Telescope
        use {
            {
                "nvim-telescope/telescope.nvim",
                module_pattern = "telescope.*",
                cmd = "Telescope",
                config = function()
                    require("settings").telescope()
                end,
                requires = "nvim-lua/plenary.nvim",
            },
            { "nvim-telescope/telescope-file-browser.nvim", after = "telescope.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                after = "telescope.nvim",
                run = "make",
                config = function()
                    require("telescope").load_extension "fzf"
                end,
            },
            {
                "nvim-telescope/telescope-project.nvim",
                after = "telescope.nvim",
                config = function()
                    require("telescope").setup {
                        extensions = {
                            project = {
                                base_dirs = {
                                    { "~/Software/Workspaces", max_depth = 5 },
                                    { "~/Documents/ofWorkspace", max_depth = 5 },
                                    { "~/Documents/LaTeX", max_depth = 3 },
                                },
                            },
                        },
                    }
                end,
            },
            -- {
            -- "nvim-telescope/telescope-dap.nvim",
            -- opt = true,
            -- },
        }
    end,
    config = {
        compile_path = require("packer.util").join_paths(fn.stdpath "config", "lua", "packer_compiled.lua"),
        profile = { enable = true, threshold = 1 },
    },
}
