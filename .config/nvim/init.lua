local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    }
end

vim.opt.runtimepath:prepend(lazypath)

if vim.fn.has 'win32' == 1 then
    vim.g.is_win32 = true
    vim.g.local_plugins = vim.fs.normalize '~/Repos/Gits/'
else
    vim.g.is_win32 = false
    vim.g.local_plugins = vim.env.WORKSPACE .. 'Repos/'
end

require('lazy').setup('r.plugins', {
    ui = { border = 'double' },
    dev = { path = vim.g.local_plugins, fallback = true },
    performance = { rtp = { disabled_plugins = require('r.utils.tables').rtp } },
    defaults = { lazy = true },
    install = { colorscheme = { 'tokyonight-night', 'habamax' } },
})

require 'r.settings'()
require 'r.mappings'()
require 'r.settings.autocmds'
