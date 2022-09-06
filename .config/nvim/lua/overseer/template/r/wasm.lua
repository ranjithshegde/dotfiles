local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
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
            return vim.b.wasm ~= nil
        end,
    },
    generator = function(_)
        local commands = {
            { args = { 'emmake', 'make', '-j12' }, tags = { TAG.BUILD }, priority = 50, save = true },
            { args = { 'emrun', "--browser='brave'", vim.b.wasm }, tags = { TAG.TEST }, priority = 40 },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            local name = command.args[1] == 'emmake' and 'Build' or 'Deploy'
            local desc = name .. ' a WebAssembly binary using emscripten'
            name = name .. ' wasm'
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
        return ret
    end,
}
