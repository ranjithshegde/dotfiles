------------------------------------------------------------------------
--                              LTex-ls                               --
------------------------------------------------------------------------

local ltex = {}

local function write_file(path, line)
    local file = io.open(path, 'a+')
    file:write(line .. '\n')
    file:close()
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
    for _, word in pairs(args) do
        write_file(vim.api.nvim_get_option_value('spellfile', {}), word)
    end
    update_dict()
end

---Disable current rule CodeAction
function ltex.disable_rule(command)
    local args = command.arguments[1].ruleIds
    local file = '.ltex_rules'
    for _, rule in pairs(args) do
        write_file(file, rule)
    end
    update_rule(file)
end

---Mark current rule as false positive CodeAction
function ltex.false_positive(command)
    local args = command.arguments[1].falsePositives
    local file = '.ltex_false_positive'
    for _, fp in pairs(args) do
        write_file(file, fp)
    end
    hidden(file)
end

return ltex
