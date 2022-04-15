-- -------------------------- Defs **********************************************************************
local fn = vim.fn
local packer_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- selfmanage packer
if fn.empty(fn.glob(packer_path)) > 0 then
    ---@diagnostic disable-next-line: lowercase-global
    packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_path,
    }
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
            { "tpope/vim-surround", event = "BufReadPost" },
            { "tpope/vim-unimpaired", keys = { "[", "]" } },
            { "tpope/vim-dispatch", cmd = { "Make", "Dispatch", "Start" } },
            { "tpope/vim-fugitive", cmd = { "G", "Git", "Gclog" } },
        }

        -- TreeSitter
        use {
            { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
            { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
            { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
            { "nvim-treesitter/nvim-treesitter-refactor", after = "scnvim" },
            { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle", "TSNodeUnderCursor" } },
        }

        -- Fold text
        use {
            "anuvyklack/pretty-fold.nvim",
            event = "BufReadPost",
            config = function()
                require("settings").folds()
            end,
        }

        -- Coautoring
        use {
            "jbyuki/instant.nvim",
            module_pattern = "instant.*",
            config = function()
                vim.g.instant_username = "Ranjith"
            end,
        }

        -- Comment with TreeSitter
        use {
            "numToStr/Comment.nvim",
            keys = { "gc", "gb", { "v", "gc" }, { "v", "gb" } },
            config = function()
                require("Comment").setup { ignore = "^$" }
            end,
        }

        -- ReverseJ
        use {
            "AckslD/nvim-trevJ.lua",
            module = "trevj",
            config = function()
                require("trevj").setup()
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

        -- Git Signs
        use {
            "lewis6991/gitsigns.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("gitsigns").setup()
                require("mappings").git()
            end,
            opt = true,
        }

        -- WhichKey
        use {
            "xiyaowong/which-key.nvim",
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

        -- vim Orgmode
        use {
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

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPost",
            config = function()
                vim.g.indent_blankline_char = "┊"
                require("indent_blankline").setup {
                    show_current_context = true,
                    show_end_of_line = true,
                    use_treesitter = true,
                }
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

        -- SuperCollider
        use {
            -- "davidgranstrom/scnvim",
            "ranjithshegde/scnvim",
            branch = "0.7",
            ft = "supercollider",
            run = function()
                fn["scnvim#install"]()
            end,
            config = function()
                vim.g.scnvim_snippet_format = "luasnip"
                vim.g.scnvim_postwin_auto_toggle = 1
                vim.api.nvim_create_autocmd("FileType", {
                    group = "LspSettings",
                    pattern = "supercollider",
                    callback = function()
                        vim.opt_local.wrap = true
                        require("mappings").scnvim()
                        require("scnvim").start()
                        vim.api.nvim_input "<CR>"
                    end,
                })
            end,
        }

        -- Telescope
        use {
            {
                "nvim-telescope/telescope.nvim",
                module = "telescope",
                cmd = "Telescope",
                config = function()
                    require("settings.telescope").telescope()
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
        }

        -- completion and snippets
        use {
            "hrsh7th/cmp-nvim-lsp",
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
            {
                "L3MON4D3/LuaSnip",
                event = "InsertEnter",
                config = function()
                    require("settings.completion").luasnip()
                end,
            },
            {
                "hrsh7th/nvim-cmp",
                after = "friendly-snippets",
                config = function()
                    require("settings.completion").init()
                end,
            },
            {
                "ray-x/lsp_signature.nvim",
                event = "InsertEnter",
                config = function()
                    require("lsp_signature").setup {
                        hint_enable = false,
                    }
                end,
            },
            {
                "rafamadriz/friendly-snippets",
                after = "LuaSnip",
                config = function()
                    require("luasnip.loaders.from_vscode").load()
                end,
            },
            {
                "windwp/nvim-autopairs",
                after = "nvim-cmp",
                config = function()
                    require("settings.completion").pairs()
                end,
            },
        }

        --Lsp config and companions
        use {
            "neovim/nvim-lspconfig",
            {
                "folke/lua-dev.nvim",
                ft = "lua",
                config = function()
                    require("lsp.sumneko").sumneko()
                end,
            },
            {
                "mfussenegger/nvim-jdtls",
                ft = "java",
                config = function()
                    require("lsp.jdtls").jdtls()
                end,
            },
            { "m-pilia/vim-ccls", ft = { "c", "cpp", "opencl" } },
            {
                "p00f/clangd_extensions.nvim",
                ft = { "c", "cpp", "opencl" },
                config = function()
                    require("lsp.clangd").clangd()
                end,
            },
            {
                "j-hui/fidget.nvim",
                opt = true,
                config = function()
                    require("fidget").setup {
                        text = {
                            spinner = "moon",
                        },
                        align = {
                            bottom = true,
                        },
                        window = {
                            relative = "editor",
                            blend = 0,
                        },
                    }
                end,
            },
        }

        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        compile_path = require("packer.util").join_paths(fn.stdpath "config", "lua", "packer_compiled.lua"),
        profile = { enable = true, threshold = 0 },
        autoremove = true,
    },
}
