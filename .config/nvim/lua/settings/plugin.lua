local plugins = {}

------------------------------------------------------------------------
--                      Config for various plugins                    --
------------------------------------------------------------------------

---SuperCollider
function plugins.scnvim()
    local scnvim = require "scnvim"
    local map = scnvim.map
    scnvim.setup {
        keymaps = {
            ["<F6>"] = map("editor.send_line", { "i", "n" }),
            ["<F5>"] = {
                map("editor.send_block", { "i", "n" }),
                map("editor.send_selection", "x"),
            },
            ["<F12>"] = map("sclang.hard_stop", { "n", "x", "i" }),
            ["<CR>"] = map("postwin.toggle", "n"),
            ["<C-CR>"] = map("postwin.toggle", "i"),
            ["<M-L>"] = map("postwin.clear", { "n", "i" }),
            [",s"] = map("signature.show", { "n", "i" }),
        },
        completion = { signature = { config = { border = "rounded" } } },
    }
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
        desc = "Load SCNvim settings and launch interpreter on filetype",
    })
end

---Gitsigns
function plugins.gitsigns()
    require("gitsigns").setup {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            require("mappings.git").signs(bufnr, gs)
        end,
    }
    require("mappings.git").fugitive()
end

---OrgMode
function plugins.org()
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
end

---nvim-colorizer
function plugins.color()
    require("colorizer").setup {
        "*",
        cpp = { rgb_0x = true },
        html = { mode = "foreground" },
        css = { rgb_fn = true, css_fn = true },
        yaml = { rgb_0x = true },
        "javascript",
        "conf",
    }
end

---IndentBlankline
function plugins.indent()
    require("indent_blankline").setup {
        show_current_context = true,
        show_end_of_line = true,
        use_treesitter = true,
    }
    for _, v in pairs(require("utils.tables").indentContext) do
        vim.cmd("let g:indent_blankline_context_patterns+=['" .. v .. "']")
    end
end

return plugins
