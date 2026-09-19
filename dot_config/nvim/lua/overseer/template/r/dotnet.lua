local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local cmd = { 'dotnet' }
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end

        return {
            cmd = cmd,
            components = { 'default', 'on_output_quickfix', 'unique', { 'r.dispatch', save = params.save } },
        }
    end,
}

return {
    condition = {
        filetype = { 'cs' },
    },
    generator = function(_, cb)
        local commands = {
            { args = { 'build' }, tags = { TAG.BUILD }, priority = 20, save = true },
            { args = { 'run' }, tags = { TAG.TEST }, priority = 10 },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            -- local start = nil
            -- if vim.tbl_contains(command.args, '-t') then
            --     start = command.args[#command.args]
            -- end
            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = string.format('dotnet %s', table.concat(command.args, ' ')),
                    tags = command.tags,
                    priority = command.priority,
                }, { args = command.args, save = command.save })
            )
        end
        cb(ret)
    end,
}
