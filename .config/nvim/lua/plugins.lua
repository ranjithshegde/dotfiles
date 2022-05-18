---@diagnostic disable: missing-parameter
-- -------------------------- Defs **********************************************************************
local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- selfmanage packer
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
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

local wikiP = vim.env.WORKSPACE and vim.env.WORKSPACE .. "Repos/orgWiki.nvim"
local wiki = vim.env.WORKSPACE and vim.loop.fs_stat(wikiP) and wikiP or "ranjithshegde/orgWiki.nvim"

--------------------------------------------------------------------------------------------------------
--				 Plugins                                            							      --
--------------------------------------------------------------------------------------------------------
return require("packer").startup {
    function(use)
        use "wbthomason/packer.nvim"

        use "lewis6991/impatient.nvim"

        use "EdenEast/nightfox.nvim"

        use { "bkad/CamelCaseMotion", opt = true }

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

        -- TreeSitter
        use {
            { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
            { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
            { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
            { "nvim-treesitter/nvim-treesitter-refactor", after = "scnvim" },
            { "nvim-treesitter/playground", module = "nvim-treesitter-playground" },
            { "Badhi/nvim-treesitter-cpp-tools", ft = { "c", "cpp", "opencl" } },
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

        -- ZenMode
        use {
            { "folke/zen-mode.nvim", cmd = "ZenMode" },
            {
                "folke/twilight.nvim",
                after = "zen-mode.nvim",
                config = function()
                    require("zen-mode").setup()
                    require("twilight").setup()
                end,
            },
        }

        -- OrgWiki
        use {
            wiki,
            module = "orgWiki",
            config = function()
                require("orgWiki").setup {
                    disable_mappings = true,
                    wiki_path = { "~/Documents/Orgs/", "~/Documents/Projects/" },
                    diary_path = "~/Documents/Orgs/diary/",
                }
            end,
        }

        -- Git Signs
        use {
            "lewis6991/gitsigns.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("gitsigns").setup {
                    on_attach = function(bufnr)
                        local gs = package.loaded.gitsigns
                        require("mappings.git").signs(bufnr, gs)
                    end,
                }
                require("mappings.git").fugitive()
            end,
            opt = true,
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
                    yaml = { rgb_0x = true },
                    "javascript",
                    "conf",
                }
            end,
            cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        }

        -- Indents and chars
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPost",
            config = function()
                vim.g.indent_blankline_char = "┊"
                -- vim.g.indent_blankline_use_treesitter_scope = true
                require("indent_blankline").setup {
                    show_current_context = true,
                    show_end_of_line = true,
                    use_treesitter = true,
                }
                for _, v in pairs(require("utils.tables").indentContext) do
                    vim.cmd("let g:indent_blankline_context_patterns+=['" .. v .. "']")
                end
            end,
        }

        -- Orgmode
        use {
            "nvim-orgmode/orgmode",
            ft = "org",
            config = function()
                require("orgmode").setup_ts_grammar()
                require("orgmode").setup {
                    org_agenda_files = {
                        "~/Documents/Orgs/*",
                        "~/Documents/Orgs/*/*",
                        "~/Documents/Orgs/*/*/*",
                        "~/Documents/Orgs/*/*/*/*",
                    },
                    org_highlight_latex_and_related = "entities",
                    emacs_config = { config_path = "$XDG_CONFIG_HOME/emacs/init.el" },
                }
            end,
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

        -- SuperCollider
        use {
            "davidgranstrom/scnvim",
            ft = "supercollider",
            run = function()
                vim.fn["scnvim#install"]()
            end,
            config = function()
                vim.g.scnvim_snippet_format = "luasnip"
                vim.g.scnvim_postwin_auto_toggle = 1
                vim.api.nvim_create_autocmd("FileType", {
                    group = "LspSettings",
                    pattern = "supercollider",
                    callback = function()
                        require("mappings.filetypes").scnvim()
                        vim.opt_local.wrap = true
                        if not require("scnvim").is_running() then
                            require("scnvim").start()
                            vim.api.nvim_input "<CR>"
                        end
                    end,
                })
            end,
        }

        --Lsp config and companions
        use {
            { "neovim/nvim-lspconfig", branch = "feat/0_7_goodies" },
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
                    require("lsp.sumneko").sumneko()
                end,
            },
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
                        text = { spinner = "moon" },
                        align = { bottom = true },
                        window = { relative = "editor", blend = 0 },
                    }
                end,
            },
        }

        -- completion and snippets
        use {
            { "hrsh7th/cmp-nvim-lsp", opt = "true" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
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
                "windwp/nvim-autopairs",
                after = "nvim-cmp",
                config = function()
                    require("settings.completion").pairs()
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
                "ray-x/lsp_signature.nvim",
                event = "InsertEnter",
                config = function()
                    require("lsp_signature").setup {
                        hint_enable = false,
                    }
                end,
            },
        }

        -- Telescope
        use {
            {
                "nvim-telescope/telescope.nvim",
                module = "telescope",
                cmd = "Telescope",
                config = function()
                    require("packer").loader "sqlite.lua"
                    require("settings.telescope").telescope()
                end,
                requires = "nvim-lua/plenary.nvim",
            },
            { "nvim-telescope/telescope-file-browser.nvim", after = "telescope-project.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                after = "telescope-smart-history.nvim",
                run = "make",
                config = function()
                    require("telescope").load_extension "fzf"
                end,
            },
            {
                "nvim-telescope/telescope-smart-history.nvim",
                after = "sqlite.lua",
                config = function()
                    require("telescope").load_extension "smart_history"
                end,
            },
            { "tami5/sqlite.lua", opt = true },
            {
                "nvim-telescope/telescope-project.nvim",
                after = "telescope-fzf-native.nvim",
                config = function()
                    require("telescope").setup {
                        extensions = {
                            project = {
                                base_dirs = {
                                    { "~/Documents/LaTeX", max_depth = 3 },
                                    { "~/Software/Workspaces/lua", max_depth = 4 },
                                    { "~/Software/Workspaces/cpp", max_depth = 4 },
                                    { "~/Software/Workspaces/Repos", max_depth = 4 },
                                    { "~/Software/Workspaces/electronics", max_depth = 4 },
                                    { "~/Software/Workspaces/openFrameworks", max_depth = 5 },
                                },
                            },
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
        compile_path = require("packer.util").join_paths(vim.fn.stdpath "config", "lua", "packer_compiled.lua"),
        profile = { enable = true, threshold = 0 },
        autoremove = true,
    },
}
