local constants = require 'overseer.constants'
local TAG = constants.TAG

return {
    name = 'UnrealEditor',
    desc = 'Launch Unreal Editor for current project',
    tags = { TAG.BUILD },
    builder = function()
        local cwd = vim.uv.cwd()
        local project_name = vim.fn.fnamemodify(cwd, ':t') .. '.uproject'
        local target = vim.fs.joinpath(cwd, project_name)

        return {
            cmd = { 'UnrealEditor', target },
            components = {
                'default',
                'on_output_quickfix',
                'unique',
                { 'on_complete_notify' },
            },
            dispose_timeout = false,
        }
    end,
    condition = {
        filetype = { 'cpp', 'c' },
        callback = function()
            return vim.b.cpp_type == 'Unreal' and vim.fn.executable 'UnrealEditor'
        end,
    },
    priority = 50,
}
