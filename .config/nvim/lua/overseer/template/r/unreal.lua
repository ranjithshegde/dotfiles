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
            -- cmd = { 'zsh', '-c', ('UnrealEditor "%s" & disown'):format(target) },
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
            if vim.b.cpp_type ~= 'Unreal' then
                return false
            end
            if not vim.fn.executable 'UnrealEditor' then
                return false
            end
            local cwd = vim.uv.cwd()
            local project_name = vim.fn.fnamemodify(cwd, ':t') .. '.uproject'
            local target = vim.fs.joinpath(cwd, project_name)
            return vim.uv.fs_stat(target) ~= nil
        end,
    },
    priority = 50,
}
