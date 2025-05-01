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

vim.g.is_win32 = vim.fn.has 'win32' == 1
vim.g.is_mac = vim.fn.has 'mac' == 1 or vim.fn.system 'uname -s' == 'Darwin'
vim.g.ue_path = vim.g.is_mac and '/Users/Shared/Epic Games/UE_5.5/' or '/opt/unreal-engine/'
vim.g.local_plugins = vim.fs.normalize '~/Repositories/Maintained'

vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('r.plugins', {
    ui = { border = 'rounded' },
    dev = { path = vim.g.local_plugins, fallback = true },
    performance = { rtp = { disabled_plugins = require('r.utils.tables').rtp } },
    defaults = { lazy = true },
    install = { colorscheme = { 'nekonight', 'default' } },
})

require 'r.options'()
require 'r.mappings'()
require 'r.autocmds'
