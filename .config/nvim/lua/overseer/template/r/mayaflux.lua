local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local build_table = {}
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
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
            },
            {
                args = { 'cmake', '-B', 'build', '-S', '.', '-G', 'Ninja', '-DMAYAFLUX_DEV=ON' },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
            },
            {
                args = { 'cmake', '--build', 'build', '--parallel' },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
            },
            {
                args = { './build/project_launcher' },
                tags = { TAG.TEST },
                priority = 10,
                save = false,
            },
            {
                args = { 'cmake', '--install', 'build' },
                tags = { TAG.TEST },
                priority = 20,
                save = false,
            },
        }

        local ret = {}
        for _, command in ipairs(commands) do
            local name = 'Mayaflux'
            local desc

            if vim.tbl_contains(command.args, 'clean') then
                name = name .. ' clean'
                desc = 'Clean build artifacts'
            elseif vim.tbl_contains(command.args, '-B') then
                name = name .. ' configure'
                desc = 'Configure Mayaflux project (Ninja + MAYAFLUX_DEV=ON)'
            elseif vim.tbl_contains(command.args, '--parallel') then
                name = name .. ' Build'
                desc = 'Build project with parallel jobs'
            elseif vim.tbl_contains(command.args, 'install') then
                name = name .. ' install'
                desc = 'Install built targets'
            else
                name = name .. ' Run'
                desc = 'Run project_launcher (pass extra args if needed)'
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
                }, { args = command.args, save = command.save })
            )
        end
        cb(ret)
    end,
}
