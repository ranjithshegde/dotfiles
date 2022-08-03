local constants = require "overseer.constants"
local overseer = require "overseer"
local TAG = constants.TAG

local tmpl = {
    params = {
        args = { type = "list", delimiter = " " },
        save = { type = "boolean", optional = true },
    },
    builder = function(params)
        local cmd = { "pio" }
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end

        local components = { "default", "r.on_output_parse_errors" }
        if params.save then
            table.insert(components, "r.save")
        end
        return { cmd = cmd, components = components }
    end,
}

return {
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            return vim.b.makeFile == "platformio.ini"
        end,
    },
    generator = function(_)
        local commands = {
            { args = { "run" }, tags = { TAG.BUILD }, priority = 20, save = true },
            { args = { "run", "-t", "upload" }, tags = { TAG.TEST }, priority = 10 },
            { args = { "check", "--skip-packages" }, priority = 60 },
            { args = { "run", "-t", "clean" }, priority = 40, tags = { TAG.CLEAN } },
            { args = { "run", "-t", "compiledb" }, priority = 30 },
        }
        local ret = {}
        for _, command in ipairs(commands) do
            local start = nil
            if vim.tbl_contains(command.args, "-t") then
                start = command.args[#command.args]
            end
            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = string.format("pio %s", start and start or table.concat(command.args, " ")),
                    tags = command.tags,
                    priority = command.priority,
                }, { args = command.args, save = command.save })
            )
        end
        table.insert(ret, overseer.wrap_template(tmpl, { name = "pio", priority = 50, desc = "Run with custom args" }))
        return ret
    end,
}
