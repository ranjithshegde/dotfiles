require 'r.plugins'
pcall(require, 'r.packer_compiled')
require 'r.settings'()
require('r.settings.treesitter').init()
require 'r.mappings'()
require 'r.settings.autocmds'
