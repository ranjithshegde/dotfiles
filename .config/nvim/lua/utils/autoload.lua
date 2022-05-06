local autoload = {}
------------------------------------------------------------------------
--                          User commands                             --
------------------------------------------------------------------------

function autoload.commands()
    require("mappings.lsp").diagnostic()
    local cmd = vim.api.nvim_create_user_command
    local complete = function()
        return require("utils.langServers").getClientNames()
    end

    cmd("ToggleVirtual", function(opts)
        require("utils.diagnostics").toggle_virtual_text(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("ToggleSigns", function(opts)
        require("utils.diagnostics").toggle_signs(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("ToggleUnderline", function(opts)
        require("utils.diagnostics").toggle_underline(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("ToggleAllDiagnostics", function(opts)
        require("utils.diagnostics").toggle_all_diagnostics(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("DisableDiagnostics", function(opts)
        require("utils.diagnostics").turn_off_diagnostics(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("EnableDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics(opts.args)
    end, { nargs = 1, complete = complete })

    cmd("DefaultDiagnostics", function(opts)
        require("utils.diagnostics").turn_on_diagnostics_default(opts.args)
    end, { nargs = 1, complete = complete })
end

------------------------------------------------------------------------
--                          Camel case                                --
------------------------------------------------------------------------

function autoload.CamelCase()
    local map = vim.keymap.set
    local umap = vim.keymap.del
    require("packer").loader "CamelCaseMotion"

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
