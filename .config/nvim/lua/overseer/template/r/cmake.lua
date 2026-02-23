local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        type = { type = 'string', optional = true },
        dGPU = { type = 'boolean' },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local build_table = {}
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end
        if params.type then
            table.insert(cmd, '-DCMAKE_BUILD_TYPE=' .. params.type)
        end
        if params.dGPU then
            if _G.__MACHINE then
                table.insert(cmd, 1, 'prime_run')
            else
                build_table.env = { DRI_PRIME = '1' }
            end
        end

        build_table.cmd = cmd
        build_table.components = { 'default', 'on_output_quickfix', 'unique', { 'r.dispatch', save = params.save } }

        return build_table
    end,
}

return {
    condition = {
        filetype = { 'c', 'cpp' },
        callback = function()
            return vim.b.cpp_type == 'CMake'
        end,
    },
    generator = function(_, cb)
        local commands = {
            {
                args = { 'cmake', '--build', 'build', '--target', 'clean' },
                tags = { TAG.CLEAN },
                priority = 70,
                save = false,
                dGPU = false,
            },
            {
                args = { 'cmake', '-B', 'build', '-S', '.', '-G', 'Ninja' },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
                dGPU = false,
            },
            {
                args = { 'cmake', '--build', 'build', '--parallel' },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
                dGPU = false,
            },
            {
                args = { './build/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') },
                tags = { TAG.TEST },
                priority = 10,
            },
            {
                args = { 'cmake', '--build', 'build', '--config', 'Release', '--target', 'install' },
                tags = { TAG.TEST },
                priority = 20,
                dGPU = false,
            },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            local name = 'Cmake'
            local desc
            if vim.tbl_contains(command.args, 'clean') then
                name = name .. ' clean'
                desc = 'cleanup build files'
            elseif vim.tbl_contains(command.args, '-B') then
                name = name .. ' configure'
                desc = 'configure project for build or release'
            elseif vim.tbl_contains(command.args, '--parallel') then
                name = name .. ' Build'
                desc = 'Compile project binary'
            elseif vim.tbl_contains(command.args, 'install') then
                name = name .. ' install'
                desc = 'Install binary in system prefix'
            else
                name = name .. ' Run'
                desc = 'Run binary for testing'
            end
            if not command.save then
                command.save = false
            end
            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = name,
                    desc = desc,
                    tags = command.tags,
                    priority = command.priority,
                }, { args = command.args, save = command.save, dGPU = command.dGPU })
            )
        end
        cb(ret)
    end,
}
