------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

return function()
    local nl = require("null-ls")
    local nb = nl.builtins
    local sources = {
        nb.code_actions.refactoring.with {
            filetypes = require('r.utils.tables').lspfiles,
        },
        nb.code_actions.ts_node_action.with {
            filetypes = require('r.utils.tables').lspfiles,
        },

        nb.diagnostics.zsh,
        nb.diagnostics.flake8,
        nb.diagnostics.checkmake,
        nb.diagnostics.stylelint,

        nb.formatting.black,
        nb.formatting.isort,
        nb.formatting.shfmt,
        nb.formatting.stylua,
        nb.formatting.beautysh,
        nb.formatting.prettier,
        nb.formatting.clang_format.with {
            filetypes = { 'glsl' },
        },

        require("none-ls-shellcheck.diagnostics"),
        require("none-ls-shellcheck.code_actions"),

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
