local overseer = require 'overseer'
return {
    name = 'Live server',
    desc = 'Launch web application in browser',
    tags = { overseer.TAG.TEST },
    params = { save = { type = 'boolean', default = true } },
    builder = function(params)
        return {
            cmd = { 'live-server', '.' },
            components = { 'default', { 'r.dispatch', save = params.save } },
        }
    end,
    condition = {
        filetype = { 'javascript', 'typescript', 'html', 'css' },
    },
    priority = 10,
}
