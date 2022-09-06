local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        env = { type = 'string', optional = true },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local cmd = { 'flutter' }
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end
        if params.env then
            table.insert(cmd, params.env)
        end

        return {
            cmd = cmd,
            components = { 'default', 'unique', { 'r.dispatch', save = params.save } },
        }
    end,
}

return {
    condition = {
        filetype = { 'dart' },
    },
    generator = function(_)
        local commands = {
            { args = { 'build' }, tags = { TAG.BUILD }, priority = 10, save = true },
            { args = { 'run' }, tags = { TAG.TEST }, priority = 20 },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = string.format('Flutter %s', table.concat(command.args, ' ')),
                    tags = command.tags,
                    priority = command.priority,
                }, { args = command.args, save = command.save })
            )
        end
        table.insert(
            ret,
            overseer.wrap_template(tmpl, { name = 'Flutter', priority = 50, desc = 'Run with custom args' })
        )
        return ret
    end,
}
