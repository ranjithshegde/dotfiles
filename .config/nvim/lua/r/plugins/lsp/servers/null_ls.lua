------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

return function()
    local nl = require 'null-ls'
    local nb = nl.builtins
    local sources = {
        nb.formatting.stylua,
        nb.formatting.prettier,

        nb.code_actions.refactoring.with {
            filetypes = require('r.utils.tables').lspfiles,
        },
        nb.code_actions.ts_node_action.with {
            filetypes = require('r.utils.tables').lspfiles,
        },
    }
    nl.setup {
        on_init = function(client)
            local ft = vim.bo.filetype
            if vim.tbl_contains({ 'c', 'cpp', 'hpp', 'glsl', 'opencl' }, ft) then
                client.offset_encoding = 'utf-32'
            end
        end,
        sources = sources,
    }
end
