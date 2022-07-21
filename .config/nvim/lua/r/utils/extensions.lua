local extensions = {}
local exec = vim.api.nvim_command
------------------------------------------------------------------------
--                          User commands                             --
------------------------------------------------------------------------

function extensions.diagnostics(bufnr)
    require("r.mappings.lsp").diagnostic(bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local complete = function()
        return require("r.utils.ls").getClientNames()
    end

    cmd(bufnr, "ToggleVirtual", function(opts)
        require("r.utils.diagnostics").toggle_virtual_text(opts.args)
    end, { nargs = "*", complete = complete, desc = "Toggle diagnostic virtual text for a client" })

    cmd(bufnr, "ToggleSigns", function(opts)
        require("r.utils.diagnostics").toggle_signs(opts.args)
    end, { nargs = "*", complete = complete, desc = "Toggle diagnostic signs for a client" })

    cmd(bufnr, "ToggleUnderline", function(opts)
        require("r.utils.diagnostics").toggle_underline(opts.args)
    end, { nargs = "*", complete = complete, desc = "Toggle diagnostic underlines for a client" })

    cmd(bufnr, "ToggleAllDiagnostics", function(opts)
        require("r.utils.diagnostics").toggle_all_diagnostics(opts.args)
    end, { nargs = "*", complete = complete, desc = "Toggle all diagnostic options for a client" })

    cmd(bufnr, "DisableDiagnostics", function(opts)
        require("r.utils.diagnostics").turn_off_diagnostics(opts.args)
    end, { nargs = "*", complete = complete, desc = "Disable all diagnostic options for a client" })

    cmd(bufnr, "EnableDiagnostics", function(opts)
        require("r.utils.diagnostics").turn_on_diagnostics(opts.args)
    end, { nargs = "*", complete = complete, desc = "Enable all diagnostic options for a client" })

    cmd(bufnr, "DefaultDiagnostics", function(opts)
        require("r.utils.diagnostics").turn_on_diagnostics_default(opts.args)
    end, { nargs = "*", complete = complete, desc = "Enable default diagnostic options for a client" })
end

---Toggle background transparency for dark colorschemes
local transparent = false
function extensions.trans_background()
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
    vim.cmd.colorscheme(colo)
end

------------------------------------------------------------------------
--                          Camel case                                --
------------------------------------------------------------------------

function extensions.CamelCase()
    local map = vim.keymap.set
    local umap = vim.keymap.del
    require("r.utils.camel").init()

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

function extensions.WordProcessor()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.expandtab = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us,en_gb"
    vim.opt_local.complete:append "k"
    vim.opt.thesaurus = vim.env.XDG_CONFIG_HOME .. "/nvim/thesaurus/mthesaur.txt"
    require("r.mappings.util").wordProcessor()
end

------------------------------------------------------------------------
--                              Terminal                              --
------------------------------------------------------------------------

-- Toggleable terminal
---@param cmd string launch the shell with
---@param name string name/ID for the terminal window
---@param spl number 0 = horizontal split, 1 = vertical split
function extensions.toggleTerm(cmd, name, spl)
    local win = vim.fn.bufwinnr(name)
    local buf = vim.fn.bufexists(name)
    local split = spl and "belowright vnew" or "belowright new"
    if win > 0 then
        exec(win .. " wincmd c")
    elseif buf > 0 then
        exec(split)
        vim.cmd.buffer(name)
        vim.cmd.startinsert()
    else
        exec(split)
        vim.fn.termopen(cmd)
        vim.cmd.startinsert()
        vim.cmd.f(name)
    end
end

---Use ranger as file picker
---@param path string Patht open ranger from
---@param edit_cmd string Ranger window position - e: open over current buffer - vs: Vertical split - tab drop: in new or existing tab window
function extensions.ranger(path, edit_cmd)
    local cpath = "/tmp/chosenfile"
    local currentPath = vim.fn.expand(path)
    local rc = { name = "ranger", edit_cmd = edit_cmd }
    function rc.on_exit(_, code, _)
        if not code then
            vim.api.nvim_buf_delete(0, { force = true })
        end
        if io.open(cpath, "r") then
            for f in io.lines(cpath) do
                vim.fn.execute(edit_cmd .. f)
            end
            os.remove(cpath)
        end
    end

    vim.cmd.enew()
    if vim.fn.isdirectory(currentPath) then
        vim.fn.termopen("ranger --choosefiles=" .. cpath .. ' "' .. currentPath .. '"', rc)
    else
        vim.fn.termopen("ranger --choosefiles=" .. cpath .. ' --selectfile="' .. currentPath .. '"', rc)
    end
    vim.cmd.startinsert()
end
return extensions
