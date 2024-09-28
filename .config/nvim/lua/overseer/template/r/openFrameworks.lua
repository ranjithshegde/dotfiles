local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG
local num_jobs = _G.__MACHINE and '-j12' or '-j32'

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        type = { type = 'string', default = 'Release' },
        dGPU = { type = 'boolean', optional = true },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local build_table = {}
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end
        if params.type then
            if vim.tbl_contains(cmd, num_jobs) then
                table.insert(cmd, params.type)
            else
                table.insert(cmd, 'Run' .. params.type)
            end
        end
        if params.dGPU then
            if _G.__MACHINE then
                table.insert(cmd, 1, 'prime-run')
            else
                build_table.env = { DRI_PRIME = '1' }
            end
        end

        build_table.components = { 'default', 'on_output_quickfix', 'unique', { 'r.dispatch', save = params.save } }
        build_table.cmd = cmd

        return build_table
    end,
}

return {
    condition = {
        filetype = { 'c', 'cpp' },
        callback = function()
            return vim.b.cpp_type == 'oF'
        end,
    },
    generator = function(_, cb)
        local commands = {
            { args = { 'make' }, tags = { TAG.TEST }, priority = 10 },
            { args = { 'make', num_jobs }, tags = { TAG.BUILD }, priority = 20, save = true },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            local name = 'oF'
            local desc
            if vim.tbl_contains(command.args, num_jobs) then
                name = name .. ' Build'
                desc = 'Compile openFrameworks binary'
            else
                name = name .. ' Run'
                desc = 'Run openFrameworks binary'
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
