local autoload = {}
------------------------------------------------------------------------
--                          User commands                             --
------------------------------------------------------------------------

function autoload.diagnostics(bufnr)
    require("mappings.lsp").diagnostic(bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local complete = function()
        return require("utils.langServers").getClientNames()
    end

    cmd(bufnr, "ToggleVirtual", function(opts)
        require("utils.diagnostics").toggle_virtual_text(opts.args)
    end, { nargs = 1, complete = complete, desc = "Toggle diagnostic virtual text for a client" })

    cmd(bufnr, "ToggleSigns", function(opts)
        require("utils.diagnostics").toggle_signs(opts.args)
    end, { nargs = 1, complete = complete, desc = "Toggle diagnostic signs for a client" })

    cmd(bufnr, "ToggleUnderline", function(opts)
        require("utils.diagnostics").toggle_underline(opts.args)
    end, { nargs = 1, complete = complete, desc = "Toggle diagnostic underlines for a client" })

    cmd(bufnr, "ToggleAllDiagnostics", function(opts)
        require("utils.diagnostics").toggle_all_diagnostics(opts.args)
    end, { nargs = 1, complete = complete, desc = "Toggle all diagnostic options for a client" })

    cmd(bufnr, "DisableDiagnostics", function(opts)
        require("utils.diagnostics").turn_off_diagnostics(opts.args)
    end, { nargs = 1, complete = complete, desc = "Disable all diagnostic options for a client" })

    cmd(bufnr, "EnableDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics(opts.args)
    end, { nargs = 1, complete = complete, desc = "Enable all diagnostic options for a client" })

    cmd(bufnr, "DefaultDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics_default(opts.args)
    end, { nargs = 1, complete = complete, desc = "Enable default diagnostic options for a client" })
end

---Toggle background transparency for dark colorschemes
local transparent = false
function autoload.trans_background()
    local colo = vim.api.nvim_exec("colo", true)
    if colo == "dayfox" or colo == "dawnfox" then
        print "Error: Transparent background does not work with a light colorscheme!"
        return
    end
    transparent = not transparent
    require("nightfox").setup {
        options = {
            transparent = transparent,
        },
    }
    vim.cmd("colo " .. colo)
end

------------------------------------------------------------------------
--                          Camel case                                --
------------------------------------------------------------------------

function autoload.CamelCase()
    local map = vim.keymap.set
    local umap = vim.keymap.del
    require("utils.camel").init()

    map("", "w", "<Plug>CamelCaseMotion_w")
    map("", "b", "<Plug>CamelCaseMotion_b")
    map("", "e", "<Plug>CamelCaseMotion_e")
    map("", "ge", "<Plug>CamelCaseMotion_ge")

    umap("s", "w")
    umap("s", "b")
    umap("s", "e")
    umap("s", "ge")

    map({ "o", "x" }, "iw", "<Plug>CamelCaseMotion_iw")
    map({ "o", "x" }, "ib", "<Plug>CamelCaseMotion_ib")
    map({ "o", "x" }, "ie", "<Plug>CamelCaseMotion_ie")
    map("i", "<S-Left>", "<C-o><Plug>CamelCaseMotion_b")
    map("i", "<S-Right>", "<C-o><Plug>CamelCaseMotion_w")
end

------------------------------------------------------------------------
--                          Word Processor                            --
------------------------------------------------------------------------

function autoload.WordProcessor()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.expandtab = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us,en_gb"
    vim.opt_local.complete:append "k"
    vim.opt.thesaurus = vim.env.XDG_CONFIG_HOME .. "/nvim/thesaurus/mthesaur.txt"
    require("mappings.util").wordProcessor()
end

return autoload
