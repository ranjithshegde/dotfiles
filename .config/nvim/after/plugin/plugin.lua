-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd("Scratch", function(opts)
    if opts.args ~= "" then
        require "utils.scratchpad"(_, string.gsub(opts.args, [["]], ""))
    else
        require "utils.scratchpad"()
    end
end, { desc = "Open scratchpad for a filetype" })

cmd("WordCount", function()
    require("utils.langServers").TexWordCount()
end, { desc = "Display text word count in the buffer" })

cmd("Agenda", function()
    require("packer").loader "orgmode"
    require("orgmode").action "agenda.prompt"
end, { desc = "Open Orgmode agenda" })

cmd("Gram", function()
    require("utils.autoload").WordProcessor()
end, { desc = "Turn on WordProcessor mode" })

cmd("Cam", function()
    require("utils.autoload").CamelCase()
end, { desc = "Turn word and motion operators into camelcase" })

cmd("ToggleTransparency", function()
    require("utils.autoload").trans_background()
end, { desc = "Toggle background transpparency for dark scheme" })

cmd("Su", "w !sudo tee %", {})

-- ******************* Plugin mappings --------------------------------------------

vim.keymap.set("n", "<leader>e", function()
    vim.cmd "Lex"
end, { desc = "Toggle Netrw" })

local function load_plugin_on_key(mode, key, desc, callback, args)
    vim.keymap.set(mode, key, function()
        vim.keymap.del(mode, key)
        callback(args)
        key = string.gsub(key, "<leader>", "\\")
        vim.api.nvim_input(key)
    end, { desc = desc })
end

load_plugin_on_key("n", "<Space>", "Telescope", require, "mappings.telescope")

load_plugin_on_key("n", "<leader>r", "Ranger file picker", require("mappings.util").ranger)

load_plugin_on_key("n", "<leader>w", "OrgWiki", require("mappings.util").orgWiki)

load_plugin_on_key("n", "ys", "add surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("n", "yss", "add line surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("v", "S", "change surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("n", "cs", "change surround", require("packer").loader, "nvim-surround")

load_plugin_on_key("n", "ds", "delete surround", require("packer").loader, "nvim-surround")

-- ******************* Global functions --------------------------------------------

RELOAD = function(module)
    if type(module) == "table" then
        for _, value in pairs(module) do
            RELOAD(value)
        end
    else
        return require("plenary.reload").reload_module(module)
    end
end
