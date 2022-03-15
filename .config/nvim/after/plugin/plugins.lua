-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_add_user_command
cmd("Cpractice", require("utils.compiler").cpractice, {})
cmd("Cproject", require("utils.compiler").cproject, {})
cmd("WordCount", require("utils.langServers").TexWordCount, {})
cmd("Agenda", require("utils").agenda, {})
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
