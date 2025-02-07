local overseer = require 'overseer'

return {
    name = 'Run Single',
    desc = 'Build and run single file',
    tags = { overseer.TAG.BUILD },
    params = { save = { type = 'boolean', default = true } },
    builder = function(params)
        return {
            cmd = { vim.b.make, vim.fn.expand '%' },
            components = {
                'default',
                'on_output_quickfix',
                'on_result_diagnostics_trouble',
                'unique',
                { 'r.dispatch', save = params.save },
            },
        }
    end,
    condition = { filetype = { 'lua', 'python', 'javascript' } },
    priority = 20,
}
