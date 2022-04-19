-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_create_user_command

cmd("CScratch", function()
    require("utils.compiler").Cscratch()
end, {})

cmd("Cproject", function()
    require("utils.compiler").cproject()
end, {})

cmd("WordCount", function()
    require("utils.langServers").TexWordCount()
end, {})

cmd("Agenda", function()
    require("utils").agenda()
end, {})

cmd("ToggleTransparency", function()
    require("utils").trans()
end, {})

cmd("Gram", "call util#WordProcessor()", {})
cmd("Cam", "call util#CamelCase()", {})
cmd("Su", "call util#sudoWrite()", {})

-- ******************* Plugin mappings --------------------------------------------
require("mappings.util").ranger()
require("mappings.util").orgWiki()
require("mappings.util").coauthor()
require "mappings.telescope"
vim.keymap.set("n", "<leader>e", "<cmd>Lex<CR>", { desc = "Toggle Netrw" })

vim.g.fold_preview = true
vim.keymap.set("n", "l", function()
    require("utils.preview").keymap_open_close "l"
end)
vim.keymap.set("n", "h", function()
    require("utils.preview").keymap_close "h"
end)

-- ******************* new functions --------------------------------------------
P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(module)
    if type(module) == "table" then
        for _, value in pairs(module) do
            RELOAD(value)
        end
    else
        return require("plenary.reload").reload_module(module)
    end
end

-- R = function(name)
--     RELOAD(name)
--     return require(name)
-- end

-- W = function(v)
--     local f = io.open("package.txt", "w+")
--     f:write(vim.inspect(v))
-- end
--
--
