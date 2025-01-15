------------------------------------------------------------------------
--                              General functions                     --
------------------------------------------------------------------------

local current_diagnostics = {}

local methods = { 'underline', 'virtual_text', 'signs', 'update_in_insert', 'float' }

local sign_conf = {
    text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
}

local function fmt(diagnostic)
    if diagnostic.code then
        return ('[%s] %s'):format(diagnostic.code, diagnostic.message)
    end
    return diagnostic.message
end

local float_conf = {
    show_header = true,
    source = 'always',
    border = 'rounded',
    format = fmt,
}

local ns = {}

local virt_text_conf = {
    default = {
        source = 'always',
    },
    clangd = {
        source = 'always',
        severity = vim.diagnostic.severity.ERROR,
    },
    ltex = {
        source = 'always',
        severity = { min = vim.diagnostic.severity.WARN },
    },
}

local default_opts = {
    title = 'Diagnostics',
}

local function client_opts(client)
    return {
        title = 'Diagnostics: ' .. client,
    }
end

local function displayStatus(msg, val, client)
    if not client then
        if val == false then
            vim.notify(string.format('%s off', msg), nil, default_opts)
        else
            vim.notify(string.format('%s on', msg), nil, default_opts)
        end
    else
        if val == false then
            vim.notify(string.format('%s off for %s', msg, client), nil, client_opts(client))
        else
            vim.notify(string.format('%s on for %s', msg, client), nil, client_opts(client))
        end
    end
end

local function tableHasKey(table, key)
    return vim.tbl_contains(vim.tbl_keys(table), key)
end

local function returnID(client)
    local lang_server = vim.lsp.get_clients { name = client }
    if not lang_server then
        vim.notify(
            string.format('The language server %s is not active on this buffer', vim.log.levels.WARN, client),
            client_opts(client)
        )
        return
    end
    return lang_server[1].id
end

local function currentSettings(new_settings, client)
    local settings = {}
    for _, setting in pairs(methods) do
        settings[setting] = current_diagnostics[client].settings[setting].value
    end
    if not vim.tbl_isempty(new_settings) then
        for setting, value in pairs(new_settings) do
            settings[setting] = value
        end
    end
    return settings
end

local function configure(settings, client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            local conf = currentSettings(settings, id)
            if conf.virtual_text then
                conf.virtual_text = virt_text_conf[client] and virt_text_conf[client] or virt_text_conf.default
            end
            vim.diagnostic.config(conf, ns[client])
            local client_id = returnID(id)
            if not client_id then
                return
            end
            local buffers = vim.lsp.get_buffers_by_client_id(client_id)
            if vim.tbl_isempty(buffers) then
                vim.diagnostic.show(ns[client], 0, nil, conf)
                return
            end
            for _, buffer_id in ipairs(buffers) do
                vim.diagnostic.show(ns[client], buffer_id, nil, conf)
            end
        end
    else
        local conf = currentSettings(settings, client)

        if conf.virtual_text then
            conf.virtual_text = virt_text_conf[client] and virt_text_conf[client] or virt_text_conf.default
        end
        vim.diagnostic.config(conf, ns[client])
        local client_id = returnID(client)
        if not client_id then
            return
        end
        local buffers = vim.lsp.get_buffers_by_client_id(client_id)

        if vim.tbl_isempty(buffers) then
            vim.diagnostic.show(ns[client], 0, nil, conf)
            return
        end

        for _, buffer_id in ipairs(buffers) do
            vim.diagnostic.show(ns[client], buffer_id, nil, conf)
        end
    end
end

local Diagnostics = {}

------------------------------------------------------------------------
--                              Diagnostic Toggle                     --
------------------------------------------------------------------------

local function init(settings, client, config)
    local client_settings = settings or {}
    for _, setting in ipairs(methods) do
        if client_settings[setting] ~= nil then
            config.settings[setting].default = client_settings[setting]
        end
        config.settings[setting].value = config.settings[setting].default
    end
    if client_settings['start_on'] ~= nil and not client_settings['start_on'] then
        current_diagnostics[client] = config
        Diagnostics.turn_off_diagnostics(client)
    else
        current_diagnostics[client] = config
        configure({}, client)
    end
end

function Diagnostics.attach(user_settings, client)
    local config = {
        settings = {
            all = true,
            start_on = true,
            underline = { default = true },
            virtual_text = { default = true },
            signs = { default = true },
            update_in_insert = { default = true },
            float = float_conf,
        },
    }

    local current_virt = tableHasKey(virt_text_conf, client.name) and virt_text_conf[client.name]
        or virt_text_conf.default

    ns[client.name] = vim.lsp.diagnostic.get_namespace(client.id)

    vim.diagnostic.config {
        float = float_conf,
        severity_sort = true,
        signs = sign_conf,
        jump = { float = true },
    }

    if ns[client.name] then
        vim.diagnostic.config({
            float = float_conf,
            severity_sort = true,
            virtual_text = current_virt,
            signs = sign_conf,
            jump = { float = true },
        }, ns[client.name])
    end

    if vim.tbl_isempty(current_diagnostics) then
        init(user_settings, client.name, config)
    else
        if not tableHasKey(current_diagnostics, client.name) then
            init(user_settings, client.name, config)
        end
    end
end

function Diagnostics.turn_off_diagnostics(client)
    if client and client ~= '' then
        local name = vim.lsp.get_clients { name = client }
        if name[1] then
            configure({
                underline = false,
                virtual_text = false,
                signs = false,
                update_in_insert = false,
            }, client)
            current_diagnostics[client].settings.all = false
            vim.notify(string.format('all diagnostics for %s are defabled', client), nil, client_opts(client))
        else
            vim.notify(
                string.format('The language server %s is not active on this buffer', vim.log.levels.WARN, client),
                client_opts(client)
            )
        end
    else
        for id, _ in pairs(current_diagnostics) do
            configure {
                underline = false,
                virtual_text = false,
                signs = false,
                update_in_insert = false,
            }
            current_diagnostics[id].settings.all = false
        end
        vim.notify('diagnostics for all attached servers are at disabled', nil, default_opts)
    end
end

function Diagnostics.turn_on_diagnostics_default(client)
    local settings = {}
    if client and client ~= '' then
        local name = vim.lsp.get_clients { name = client }
        if name[1] then
            for _, setting in ipairs(methods) do
                settings[setting] = current_diagnostics[client].settings[setting].default
            end
            configure(settings, client)
            current_diagnostics[client].settings.all = true
            vim.notify(string.format('all diagnostics for %s are at default', client), nil, client_opts(client))
        else
            vim.notify(
                string.format('The language server %s is not active on this buffer', client),
                vim.log.levels.WARN,
                default_opts
            )
        end
    else
        for id, _ in pairs(current_diagnostics) do
            for _, setting in ipairs(methods) do
                settings[setting] = current_diagnostics[id].settings[setting].default
            end
            configure(settings)
            current_diagnostics[id].settings.all = true
        end
        vim.notify('diagnostics for all attached servers are at default', nil, default_opts)
    end
end

function Diagnostics.turn_on_diagnostics(client)
    if client and client ~= '' then
        local name = vim.lsp.get_clients { name = client }
        if name then
            configure({
                underline = true,
                virtual_text = true,
                signs = true,
                update_in_insert = true,
            }, client)
            current_diagnostics[client].settings.all = true
            vim.notify(string.format('all diagnostics for %s are at enabled', client), nil, client_opts(client))
        else
            vim.notify(
                string.format('The language server %s is not active on this buffer', client),
                vim.log.levels.WARN,
                { title = 'Diagnostics' }
            )
        end
    else
        for id, _ in pairs(current_diagnostics) do
            configure {
                underline = true,
                virtual_text = true,
                signs = true,
                update_in_insert = true,
            }
            current_diagnostics[id].settings.all = true
            vim.notify('diagnostics for all attached servers are enabled', nil, default_opts)
        end
    end
end

function Diagnostics.toggle_all_diagnostics(client)
    if client and client ~= '' then
        local name = vim.lsp.get_clients { name = client }
        if name[1] then
            if current_diagnostics[name[1].id].settings.all then
                Diagnostics.turn_off_diagnostics(client)
            else
                Diagnostics.turn_on_diagnostics(client)
            end
            displayStatus('all diagnostics are', current_diagnostics[client].settings.all, client)
        else
            vim.notify(string.format('The language server %s is not active on this buffer', client))
        end
    else
        for id, _ in pairs(current_diagnostics) do
            if current_diagnostics[id].settings.all then
                Diagnostics.turn_off_diagnostics()
            else
                Diagnostics.turn_on_diagnostics()
            end
            displayStatus('all diagnostics for attached servers are', current_diagnostics[id].settings.all)
        end
    end
end

function Diagnostics.toggle_diagnostic(name, client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            if type(current_diagnostics[id].settings[name].default) == 'boolean' then
                current_diagnostics[id].settings[name].value = not current_diagnostics[id].settings[name].value
            elseif current_diagnostics[id].settings[name].value == false then
                current_diagnostics[id].settings[name].value = current_diagnostics[id].settings[name].default
            else
                current_diagnostics[id].settings[name].value = false
            end
            displayStatus(name .. ' is', current_diagnostics[id].settings[name].value)
            configure { [name] = current_diagnostics[id].settings[name].value }
            return current_diagnostics[id].settings[name].value
        end
    else
        local cname = vim.lsp.get_clients { name = client }
        if cname[1] then
            if type(current_diagnostics[client].settings[name].default) == 'boolean' then
                current_diagnostics[client].settings[name].value = not current_diagnostics[client].settings[name].value
            elseif current_diagnostics[client].settings[name].value == false then
                current_diagnostics[client].settings[name].value = current_diagnostics[client].settings[name].default
            else
                current_diagnostics[client].settings[name].value = false
            end
            displayStatus(name .. ' is', current_diagnostics[client].settings[name].value, client)
            configure({
                [name] = current_diagnostics[client].settings[name].value,
            }, client)
            return current_diagnostics[client].settings[name].value
        else
            vim.notify(
                string.format('The language server %s is not active on this buffer', client),
                vim.log.levels.WARN,
                default_opts
            )
        end
    end
end

function Diagnostics.toggle_underline(client)
    if client and client ~= '' then
        Diagnostics.toggle_diagnostic('underline', client)
    else
        Diagnostics.toggle_diagnostic 'underline'
    end
end

function Diagnostics.toggle_signs(client)
    if client and client ~= '' then
        Diagnostics.toggle_diagnostic('signs', client)
    else
        Diagnostics.toggle_diagnostic 'signs'
    end
end

function Diagnostics.toggle_virtual_text(client)
    if client and client ~= '' then
        Diagnostics.toggle_diagnostic('virtual_text', client)
    else
        Diagnostics.toggle_diagnostic 'virtual_text'
    end
end

function Diagnostics.toggle_update_in_insert(client)
    if client and client ~= '' then
        Diagnostics.toggle_diagnostic('update_in_insert', client)
    else
        Diagnostics.toggle_diagnostic 'update_in_insert'
    end
end

function Diagnostics.dump(client)
    if not client then
        vim.print(current_diagnostics)
    end
    vim.print(current_diagnostics[client])
end

return Diagnostics
