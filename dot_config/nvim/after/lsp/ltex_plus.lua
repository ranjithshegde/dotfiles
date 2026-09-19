local dict = vim.api.nvim_get_option_value('spellfile', {})

return {
    name = 'ltex_plus',
    filetypes = { 'bib', 'markdown', 'org', 'tex' },
    autostart = false,
    settings = {
        ltex = {
            additionalRules = {
                enablePickyRules = true,
                motherTongue = 'en',
                languageModel = '/usr/share/ngrams/',
            },
            bibtex = {
                fields = { address = false, author = false, title = true, description = true, url = false },
            },
            latex = {
                commands = {
                    ['\\label{}'] = 'ignore',
                    ['\\textcite{}'] = 'ignore',
                    ['\\parencite{}'] = 'ignore',
                    ['\\documentClass{}'] = 'ignore',
                },
                environments = { lstlisting = 'ignore', verbatim = 'ignore' },
            },
            language = 'en-GB',
            dictionary = { ['en-GB'] = require('r.utils').concat_fileLines(dict) },
            hiddenFalsePositives = {
                ['en-GB'] = vim.uv.fs_stat(vim.uv.cwd() .. '/.ltex_false_positive')
                        and require('r.utils').concat_fileLines(vim.uv.cwd() .. '/.ltex_false_positive')
                    or {},
            },
            disabledRules = {
                ['en-GB'] = vim.uv.fs_stat(vim.uv.cwd() .. '/.ltex_rules') and require('r.utils').concat_fileLines(
                    vim.uv.cwd() .. '/.ltex_rules'
                ) or {},
            },
            performance = {
                cacheSize = 4096,
                maxDocumentSize = 1000000,
            },
        },
    },
}
