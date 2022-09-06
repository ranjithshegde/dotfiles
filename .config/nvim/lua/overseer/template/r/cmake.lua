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
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end
        if params.type then
            table.insert(cmd, '-DCMAKE_BUILD_TYPE=' .. params.type)
        end
        if params.dGPU then
            table.insert(cmd, 1, 'prime-run')
        end

        return {
            cmd = cmd,
            components = { 'default', 'unique', { 'r.dispatch', save = params.save } },
        }
    end,
}

return {
    condition = {
        filetype = { 'c', 'cpp' },
        callback = function()
            return vim.b.makeFile == 'CMakeLists.txt'
        end,
    },
    generator = function(_)
        local commands = {
            { args = { 'make', '-C', 'build', 'clean' }, tags = { TAG.CLEAN }, priority = 70, dGPU = false },
            {
                args = { 'cmake', '-B', 'build', '-S', '.' },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
                dGPU = false,
            },
            {
                args = { 'make', '-j12', '-C', 'build' },
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
            elseif vim.tbl_contains(command.args, '-j12') then
                name = name .. ' Build'
                desc = 'Compile project binary'
            elseif vim.tbl_contains(command.args, '--config') then
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
        return ret
    end,
}
