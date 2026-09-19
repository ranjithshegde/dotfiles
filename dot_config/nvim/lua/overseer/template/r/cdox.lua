local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
    },
    builder = function(params)
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end

        return {
            cmd = cmd,
            components = { 'default', 'unique' },
        }
    end,
}

return {
    condition = {
        filetype = { 'c', 'cpp' },
    },
    generator = function(_, cb)
        local commands = {
            {
                args = { 'doxygen', 'doxyconf' },
                tags = { TAG.TEST },
                priority = 70,
                name = 'Doxygen Build',
                desc = 'Build documentation using Doxygen',
            },
            {
                args = { 'xdg-open', 'docs/html/index.html' },
                tags = { TAG.TEST },
                priority = 80,
                name = 'Doxygen Test',
                desc = 'Test Documentation',
            },
            {
                args = { 'moxygen', 'docs/xml/', '-o', 'API.md' },
                tags = { TAG.BUILD },
                priority = 90,
                name = 'Doxygen Markdown',
                desc = 'Build Mardown from Doxygen',
            },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = command.name,
                    desc = command.desc,
                    tags = command.tags,
                    priority = command.priority,
                }, { args = command.args })
            )
        end
        cb(ret)
    end,
}
