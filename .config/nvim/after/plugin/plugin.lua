-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd("Scratch", function(opts)
    if opts.args ~= "" then
        require "utils.scratchpad"(_, string.gsub(opts.args, [["]], ""))
    else
        require "utils.scratchpad"()
    end
end, {})

cmd("WordCount", function()
    require("utils.langServers").TexWordCount()
end, {})

cmd("Agenda", function()
    require("packer").loader "orgmode"
    require("orgmode").action "agenda.prompt"
end, {})

cmd("ToggleTransparency", function()
    require("utils").trans()
end, {})

cmd("Gram", function()
    require("utils.autoload").WordProcessor()
end, {})

cmd("Cam", function()
    require("utils.autoload").CamelCase()
end, {})

cmd("Su", "w !sudo tee %", {})

-- ******************* Plugin mappings --------------------------------------------
require("mappings.util").ranger()
require("mappings.util").orgWiki()
require("mappings.util").misc()

vim.keymap.set("n", "<Space>", function()
    vim.keymap.del("n", "<Space>")
    require "mappings.telescope"
    vim.api.nvim_input "<Space>"
end)

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
