local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    }
end

local dev_path
vim.opt.runtimepath:prepend(lazypath)

if vim.fn.has 'win32' == 1 then
    vim.g.is_win32 = true
    dev_path = vim.fs.normalize '~/Repos/Gits/'
else
    vim.g.is_win32 = false
    dev_path = vim.env.WORKSPACE .. 'Repos/'
end

require('lazy').setup('r.plugins', {
    ui = { border = 'double' },
    dev = { path = dev_path },
    performance = { rtp = { disabled_plugins = require('r.utils.tables').rtp } },
    defaults = { lazy = true },
    install = { colorscheme = { 'habamax' } },
})

require 'r.settings'()
require('r.plug.treesitter').init()
require 'r.mappings'()
require 'r.settings.autocmds'
