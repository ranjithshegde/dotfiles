------------------------------------------------------------------------
--                              TexLab                                --
------------------------------------------------------------------------

local texlab = {}

---Return word count for the tex document
function texlab.tex_word_count()
    local result
    require('plenary.job')
        :new({
            command = 'texcount',
            args = { '-inc', '-sum', '-1', vim.fn.expand '%' },
            on_exit = function(j)
                result = j:result()[1]
            end,
        })
        :sync()
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
                vim.pretty_print(result)
            end
        end, bufnr)
    else
        print 'method texlab.cleanArtifacts is not supported by any servers active on the current buffer'
    end
end

function texlab.lsp(navigator)
    local config = {
        capabilities = require('r.plugins.lsp.servers').capabilities(),
        cmd = { 'texlab', '--log-file', './aux/texlab-log', '-vvvv' },
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
    if not navigator then
        require('lspconfig').texlab.setup(config)
    else
        config.name = 'texlab'
        return config
    end
end

return texlab
