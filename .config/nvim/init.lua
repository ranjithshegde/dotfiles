local ok, imp = pcall(require, "impatient")
if ok then
    imp.enable_profile()
end

require "plugins"
pcall(require, "packer_compiled")
require "settings"()
require("settings.treesitter").init()
require("mappings").init()
require "settings.autocmds"
