if vim.env.MACHINE_TYPE == 'laptop' then
    _G.__MACHINE = 'laptop'
end

vim.g.is_win64 = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
vim.g.is_mac = vim.fn.has 'mac' == 1 or vim.fn.system 'uname -s' == 'Darwin'
vim.g.ue_path = vim.g.is_mac and '/Users/Shared/Epic Games/UE_5.5/' or '/opt/unreal-engine/'

-- vim.g.local_plugins = vim.fs.normalize '~/Repositories/Maintained'

--[[ 
require('vim._core.ui2').enable {
    enable = true,
    msg = {
        targets = {
            all = 'pager',
            search_count = 'pager',
            confirm = 'dialog',
            return_prompt = 'pager',
        },
        msg = {
            timeout = 3000,
            height = 0.4,
        },
        cmd = {
            height = 0.5,
        },
    },
}
]]

require 'r.options'()
require 'r.mappings'()
require 'r.autocmds'
