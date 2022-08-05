local constants = require "overseer.constants"
local overseer = require "overseer"
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = "list", delimiter = " " },
        flags = { type = "list", delimiter = " ", optional = true },
        save = { type = "boolean", optional = true },
    },
    builder = function(params)
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end

        if params.flags then
            vim.list_extend(cmd, params.flags)
        end

        return { cmd = cmd, components = { "default", { "r.dispatch", save = params.save } } }
    end,
}

return {
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            local makeprg = vim.api.nvim_get_option "makeprg"
            return makeprg == "g++" or makeprg == "gcc"
        end,
    },
    generator = function(opts)
        local compiler = opts.filetype == "cpp" and "g++" or "gcc"
        local commands = {
            {
                args = { compiler, "-g", vim.fn.expand "%", "-o", vim.fn.expand "%<" },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
            },
            { args = { "./" .. vim.fn.expand "%<" }, tags = { TAG.TEST }, priority = 10 },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            local name = command.args[1] == compiler and "Compile" or "Run"
            local desc = command.args[1] == compiler and "Compile current file" or "Run output binary"
            if opts.filetype == "c" then
                table.insert(command.args, "-lm")
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
        return ret
    end,
}
