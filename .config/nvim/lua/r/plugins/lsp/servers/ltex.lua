------------------------------------------------------------------------
--                              LTex-ls                               --
------------------------------------------------------------------------

local ltex = {}

local function write_file(path, data)
    local file = io.open(path, 'a+')
    io.output(file)
    for _, line in ipairs(data) do
        io.write(line .. '\n')
    end
    io.close(file)
end

local function update_dict()
    local client = vim.lsp.get_clients({ name = 'ltex' })[1]
    client.config.settings.ltex.dictionary['en-GB'] =
        require('r.utils').concat_fileLines(vim.api.nvim_get_option_value('spellfile', {}))
    return client.notify('workspace/didChangeConfiguration', client.config.settings)
end

local function update_rule(file)
    local client = vim.lsp.get_clients({ name = 'ltex' })[1]
    if not client.config.settings.ltex.disabledRules then
        client.config.settings.ltex.disabledRules = {}
    end
    client.config.settings.ltex.disabledRules['en-GB'] = require('r.utils').concat_fileLines(file)
    return client.notify('workspace/didChangeConfiguration', client.config.settings)
end

local function hidden(file)
    local client = vim.lsp.get_clients({ name = 'ltex' })[1]
    if not client.config.settings.ltex.hiddenFalsePositives then
        client.config.settings.ltex.hiddenFalsePositives = {}
    end
    client.config.settings.ltex.hiddenFalsePositives['en-GB'] = require('r.utils').concat_fileLines(file)
    return client.notify('workspace/didChangeConfiguration', client.config.settings)
end

---Add cword to dictionary
function ltex.add_to_dict(command)
    local args = command.arguments[1].words
    for _, words in pairs(args) do
        write_file(vim.api.nvim_get_option_value('spellfile', {}), words)
    end
    update_dict()
end

---Disable current rule CodeAction
function ltex.disable_rule(command)
    local args = command.arguments[1].ruleIds
    local file = '.ltex_rules'
    for _, rules in pairs(args) do
        write_file(file, rules)
    end
    update_rule(file)
end

---Mark current rule as false positive CodeAction
function ltex.false_positive(command)
    local args = command.arguments[1].falsePositives
    local file = '.ltex_false_positive'
    for _, rules in pairs(args) do
        write_file(file, rules)
    end
    hidden(file)
end

function ltex.lsp()
    local dict = vim.api.nvim_get_option_value('spellfile', {})
    local config = {
        name = 'ltex_plus',
        filetypes = { 'bib', 'markdown', 'org', 'tex' },
        autostart = false,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
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
    return config
end

return ltex
