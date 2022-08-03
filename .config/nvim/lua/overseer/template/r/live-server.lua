local overseer = require "overseer"
return {
    name = "Live server",
    desc = "Launch web application in browser",
    tags = { overseer.TAG.TEST },
    params = {},
    builder = function()
        return {
            cmd = { "live-server", "." },
            components = { "default", "r.save", "r.on_output_parse_errors" },
        }
    end,
    condition = {
        filetype = { "javascript", "typescript", "html", "css" },
    },
    priority = 10,
}
