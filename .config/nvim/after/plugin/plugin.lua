-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd("Scratch", function(opts)
    if opts.args ~= "" then
        require "r.utils.project.scratchpad"(_, string.gsub(opts.args, [["]], ""))
    else
        require "r.utils.project.scratchpad"()
    end
end, { desc = "Open scratchpad for a filetype" })

cmd("Project", function(opts)
    if opts.args ~= "" then
        require("r.utils.project").create(string.gsub(opts.args, [["]], ""))
    else
        require("r.utils.project").create()
    end
end, { desc = "Create a project" })

cmd("WordCount", function()
    require("r.utils.ls").TexWordCount()
end, { desc = "Display text word count in the buffer" })

cmd("Agenda", function()
    require("packer").loader "orgmode"
    require("orgmode").action "agenda.prompt"
end, { desc = "Open Orgmode agenda" })

cmd("Word", function()
    require("r.utils.extensions").WordProcessor()
end, { desc = "Turn on WordProcessor mode" })

cmd("Camel", function()
    require("r.utils.extensions").CamelCase()
end, { desc = "Turn word and motion operators into camelcase" })

cmd("ToggleTransparency", function()
    require("r.utils.extensions").trans_background()
end, { desc = "Toggle background transpparency for dark scheme" })

cmd("Su", "w !sudo tee %", {})

-- ******************* Plugin mappings --------------------------------------------

vim.keymap.set("n", "<leader>e", vim.cmd.Lex, { desc = "Toggle Netrw" })

local function load_plugin_on_key(mode, key, desc, callback, args)
    vim.keymap.set(mode, key, function()
        vim.keymap.del(mode, key)
        callback(args)
        key = string.gsub(key, "<leader>", "\\")
        vim.api.nvim_input(key)
    end, { desc = desc })
end

load_plugin_on_key("n", "<Space>", "Telescope", require, "r.mappings.telescope")

load_plugin_on_key("n", "<leader>r", "Ranger file picker", function()
    require("r.mappings.util").ranger()
end)

load_plugin_on_key("n", "<leader>w", "OrgWiki", function()
    require("r.mappings.util").orgWiki()
end)

load_plugin_on_key("n", "ys", "add surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("v", "S", "change surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("n", "cs", "change surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("n", "ds", "delete surround", require("packer").loader, "nvim-surround")
