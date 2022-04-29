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
cmd("Su", "w !sudo tee %", {})

-- ******************* Plugin mappings --------------------------------------------
require("mappings.util").ranger()
require("mappings.util").orgWiki()
require("mappings.util").misc()
require "mappings.telescope"

-- ******************* new functions --------------------------------------------

W = function(v)
    local f = io.open("package.txt", "w+")
    f:write(vim.inspect(v))
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
