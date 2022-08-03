local overseer = require "overseer"

return {
    name = "Run Single",
    desc = "Build and run single file",
    tags = { overseer.TAG.BUILD },
    params = {},
    builder = function(_)
        return {
            cmd = { vim.b.make, vim.fn.expand "%" },
            components = { "default", "r.save" },
        }
    end,
    condition = { filetype = { "java", "lua", "python", "javascript", "perl", "dart" } },
    priority = 20,
}
