------------------------------------------------------------------------
--                              TexLab                                --
------------------------------------------------------------------------

return {
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
