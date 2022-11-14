local overseer = require 'overseer'

return {
    name = 'Valgrind',
    desc = 'Debug with Valgrind',
    tags = { overseer.TAG.TEST },
    priority = 90,
    params = {},
    builder = function(_)
        return {
            cmd = { 'valgrind', '--leak-check=full', '--track-origins=yes', vim.b.debugBin },
            components = { 'default', 'on_output_quickfix', 'unique', 'r.dispatch' },
        }
    end,
    condition = { filetype = { 'c', 'cpp' } },
}
