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
    require("utils.autoload").trans()
end, {})

cmd("Gram", function()
    require("utils.autoload").WordProcessor()
end, {})

cmd("Cam", function()
    require("utils.autoload").CamelCase()
end, {})

cmd("Su", "w !sudo tee %", {})

-- ******************* Plugin mappings --------------------------------------------

vim.keymap.set("n", "<Space>", function()
    vim.keymap.del("n", "<Space>")
    require "mappings.telescope"
    vim.api.nvim_input "<Space>"
end, { desc = "Telescope" })

vim.keymap.set("n", "<leader>r", function()
    require("mappings.util").ranger()
    vim.keymap.del("n", "<leader>r")
    vim.api.nvim_input "\\r"
end, { desc = "Ranger file picker" })

vim.keymap.set("n", "<leader>w", function()
    vim.keymap.del("n", "<leader>w")
    require("mappings.util").orgWiki()
    vim.api.nvim_input "\\w"
end, { desc = "OrgWiki" })

vim.keymap.set("n", "<leader>e", function()
    vim.cmd "Lex"
end, { desc = "Toggle Netrw" })

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
