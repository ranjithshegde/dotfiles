require "plugins"
pcall(require, "packer_compiled")
require "settings"()
require("settings.treesitter").init()
require "mappings"()
require "settings.autocmds"
