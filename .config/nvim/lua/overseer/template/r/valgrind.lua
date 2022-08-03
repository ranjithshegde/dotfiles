local overseer = require "overseer"

return {
    name = "Valgrind",
    desc = "Debug with Valgrind",
    tags = { overseer.TAG.TEST },
    priority = 90,
    params = {},
    builder = function(_)
        return {
            cmd = { "valgrind", "--leak-check=full", vim.b.debugBin },
            components = { "default", "r.on_output_parse_errors" },
        }
    end,
    condition = { filetype = { "c", "cpp" } },
}
