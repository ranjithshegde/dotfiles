------------------------------------------------------------------------
--                       Linters & formatters                         --
------------------------------------------------------------------------

local function glsl()
    local null_ls = require 'null-ls'

    return {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { 'glsl' },
        generator = null_ls.generator {
            command = 'glslangValidator',
            args = { '--stdin', '-S', '$FILEEXT' },
            to_stdin = true,
            from_stderr = true,
            format = 'raw',
            check_exit_code = function(code, stderr)
                local success = code <= 1
                if not success then
                    print(stderr)
                end

                return success
            end,
            on_output = function(params, done)
                if params and params.output then
                    local diagnostics = {}
                    local lines = vim.split(params.output, '\n')
                    local sever, col, row, message = string.match(lines[2], '(%u+):%s(%d+):(%d+):.*:%s+(.*)')

                    table.insert(diagnostics, {
                        row = row,
                        col = col + 1,
                        end_col = col + 2,
                        source = 'GLSLang',
                        message = message,
                        severity = require('null-ls.helpers').diagnostics.severities[vim.fn.tolower(sever)],
                    })
                    done(diagnostics)
                else
                    done()
                end
            end,
        },
    }
end

return function()
    local nb = require 'null-ls.builtins'
    local sources = {
        nb.code_actions.shellcheck,
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
        nb.diagnostics.shellcheck,

        nb.formatting.black,
        nb.formatting.isort,
        nb.formatting.shfmt,
        nb.formatting.stylua,
        nb.formatting.beautysh,
        nb.formatting.prettier,
        nb.formatting.clang_format.with {
            filetypes = { 'glsl' },
        },
        nb.formatting.cmake_format.with {
            extra_args = { '--config-file', vim.env.XDG_CONFIG_HOME .. '/cmake-format.json', '--' },
        },
    }
    require('null-ls').setup {
        on_init = function(client)
            local ft = vim.bo.filetype
            if vim.tbl_contains({ 'c', 'cpp', 'hpp', 'glsl', 'opencl' }, ft) then
                client.offset_encoding = 'utf-32'
            end
        end,
        sources = sources,
    }
    -- require('null-ls').register(glsl())
end
