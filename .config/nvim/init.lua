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

if vim.env.MACHINE_TYPE == 'laptop' then
    _G.__MACHINE = 'laptop'
end

if vim.fn.has 'win32' == 1 then
    vim.g.is_win32 = true
else
    vim.g.is_win32 = false
end

if vim.fn.has 'mac' == 1 then
    vim.g.is_mac = true
else
    vim.g.is_mac = false
end

vim.g.local_plugins = vim.fs.normalize '~/Repositories/Maintained'

if vim.g.is_mac then
    vim.g.ue_path = '/Users/Shared/Epic Games/UE_5.5/'
else
    vim.g.ue_path = '/opt/unreal-engine/'
end

vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('r.plugins', {
    ui = { border = 'single' },
    dev = { path = vim.g.local_plugins, fallback = true },
    performance = { rtp = { disabled_plugins = require('r.utils.tables').rtp } },
    defaults = { lazy = true },
    install = { colorscheme = { 'rose-pine-moon', 'habamax' } },
})

require 'r.options'()
require 'r.mappings'()
require 'r.autocmds'
