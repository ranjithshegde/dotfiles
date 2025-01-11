------------------------------------------------------------------------
--                              TexLab                                --
------------------------------------------------------------------------

local texlab = {}

---Return word count for the tex document
function texlab.tex_word_count()
    local result = ''
    local handle
    local output = vim.uv.new_pipe(false)

    handle = vim.uv.spawn('texcount', {
        args = { '-inc', '-sum', '-1', vim.fn.expand '%' },
        stdio = { nil, output, nil },
    }, function(code)
        if code == 0 then
            output:read_stop()
            output:close()
        else
            vim.notify('texcount failed with exit code ' .. code, vim.log.levels.ERROR)
        end
    end)

    output:read_start(function(err, chunk)
        if err then
            vim.notify('Error reading texcount output: ' .. err, vim.log.levels.ERROR)
            return
        end
        if chunk then
            result = result .. chunk
        end
    end)

    vim.wait(1000, function()
        return result ~= ''
    end)

    handle:close()

    vim.notify(result, nil, { title = 'Current document word count' })
end

function texlab.tex_clean()
    local bufnr = vim.api.nvim_get_current_buf()
    local texlab_client = require('lspconfig.util').get_active_client_by_name(bufnr, 'texlab')
    local params = {
        command = 'texlab.cleanArtifacts',
        arguments = { vim.lsp.util.make_text_document_params(bufnr) },
    }
    if texlab_client then
        texlab_client.request('workspace/executeCommand', params, function(err, result)
            if err then
                error(tostring(err))
            end
            if result then
                vim.print(result)
            end
        end, bufnr)
    else
        print 'method texlab.cleanArtifacts is not supported by any servers active on the current buffer'
    end
end

function texlab.lsp()
    local config = {
        name = 'texlab',
        capabilities = require('r.plugins.lsp.handlers').capabilities(),
        cmd = { 'texlab', '--log-file', './aux/texlab-log' },
        before_init = function(_, _)
            if vim.fn.isdirectory 'aux' ~= 1 then
                vim.fn.mkdir 'aux'
            end
        end,
        settings = {
            texlab = {
                build = {
                    args = {
                        '-lualatex',
                        '-verbose',
                        '-file-line-error',
                        '-synctex=1',
                        '-interaction=nonstopmode',
                        '-shell-escape',
                        '-outdir=aux',
                        '%f',
                    },
                    executable = 'latexmk',
                    forwardSearchAfter = true,
                },
                bibtexFormatter = 'latexindent',
                lint = { onSave = true, onChange = true },
                chktex = { onOpenAndSave = true },
                auxDirectory = 'aux',
                latexindent = { modifyLineBreaks = true },
                forwardSearch = {
                    args = {
                        '--reuse-instance',
                        '%p',
                        '--forward-search-file',
                        '%f',
                        '--forward-search-line',
                        '%l',
                        '--inverse-search',
                        'nvr --servername ' .. vim.v.servername .. ' --remote-tab-silent +%2 %1',
                    },
                    executable = 'sioyek',
                },
            },
        },
    }
    return config
end

return texlab
