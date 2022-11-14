pcall(require, 'r.packer')
pcall(require, 'r.packer_compiled')
require 'r.settings'()
require('r.plugins.treesitter').init()
require 'r.mappings'()
require 'r.settings.autocmds'
