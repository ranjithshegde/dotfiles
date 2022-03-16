-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_add_user_command

cmd("Cpractice", function()
    require("utils.compiler").cpractice()
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

cmd("ClearBack", "call util#transparency()", {})
cmd("Gram", "call util#WordProcessor()", {})
cmd("Cam", "call util#CamelCase()", {})
cmd("Su", "call util#sudoWrite()", {})

require("mappings").ranger()

-- ******************* new functions --------------------------------------------
P = function(v)
    print(vim.inspect(v))
    return v
end

-- W = function(v)
--     local f = io.open("package.txt", "w+")
--     f:write(vim.inspect(v))
-- end

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
