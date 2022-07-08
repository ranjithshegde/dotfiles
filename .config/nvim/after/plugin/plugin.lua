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

vim.keymap.set("n", "ys", function()
    vim.keymap.del("n", "ys")
    require("packer").loader "nvim-surround"
    vim.api.nvim_input "ys"
end, { desc = "add surround" })

vim.keymap.set("n", "cs", function()
    vim.keymap.del("n", "cs")
    require("packer").loader "nvim-surround"
    vim.api.nvim_input "cs"
end, { desc = "change surround" })

vim.keymap.set("n", "ds", function()
    vim.keymap.del("n", "ds")
    require("packer").loader "nvim-surround"
    vim.api.nvim_input "ds"
end, { desc = "delete surround" })

vim.keymap.set("v", "S", function()
    vim.keymap.del("v", "S")
    require("packer").loader "nvim-surround"
    vim.api.nvim_input "S"
end, { desc = "change surround" })

vim.keymap.set("n", "yss", function()
    require("packer").loader "nvim-surround"
    vim.api.nvim_input "^ysg_"
end, { remap = true, desc = "surround entire line" })

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
