-- ******************* function calls --------------------------------------------
local cmd = vim.api.nvim_add_user_command
cmd("Cpractice", require("utils.compiler").cpractice, {})
cmd("WordCount", require("utils.langServers").TexWordCount, {})
cmd("Agenda", require("utils").agenda, {})
cmd("ClearBack", "call util#transparency()", {})
cmd("Gram", "call util#WordProcessor()", {})
cmd("Cam", "call util#CamelCase()", {})
cmd("Su", "call util#sudoWrite()", {})

require("mappings").ranger()
