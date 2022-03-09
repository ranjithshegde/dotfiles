local Diagnostics = {}
local lsp = vim.lsp
local util = require "lspconfig.util"

local current_diagnostics = {}

local TABLE = { "underline", "virtual_text", "signs", "update_in_insert" }

function Diagnostics.attach(user_settings, client)
    local config = {
        settings = {
            all = true,
            start_on = true,
            underline = { default = true },
            virtual_text = { default = true },
            signs = { default = true },
            update_in_insert = { default = true },
        },
    }
    vim.diagnostic.config {
        virtual_text = {
            source = "always",
        },
        float = {
            source = "always",
        },
    }
    if vim.tbl_isempty(current_diagnostics) then
        Diagnostics.init(user_settings, client.name, config)
    else
        if Diagnostics.tableHasKey(current_diagnostics, client.name) then
            return
        else
            Diagnostics.init(user_settings, client.name, config)
        end
    end
end

function Diagnostics.init(settings, client, config)
    local client_settings = settings or {}
    for _, setting in ipairs(TABLE) do
        if client_settings[setting] ~= nil then
            config.settings[setting].default = client_settings[setting]
        end
        config.settings[setting].value = config.settings[setting].default
    end
    if client_settings["start_on"] ~= nil and not client_settings["start_on"] then
        current_diagnostics[client] = config
        Diagnostics.turn_off_diagnostics(client)
    else
        current_diagnostics[client] = config
        Diagnostics.configure_diagnostics({}, client)
    end
end

Diagnostics.show = function(b, c, conf)
    vim.diagnostic.show(lsp.diagnostic.get_namespace(c), b, nil, conf)
end

function Diagnostics.turn_off_diagnostics(client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            Diagnostics.configure_diagnostics {
                underline = false,
                virtual_text = false,
                signs = false,
                update_in_insert = false,
            }
            current_diagnostics[id].settings.all = false
        end
    else
        local name = util.get_active_client_by_name(0, client)
        if name then
            Diagnostics.configure_diagnostics({
                underline = false,
                virtual_text = false,
                signs = false,
                update_in_insert = false,
            }, client)
            current_diagnostics[client].settings.all = false
        else
            print(string.format("The language server %s is not active on this buffer", client))
        end
    end
end

function Diagnostics.turn_on_diagnostics_default(client)
    local settings = {}
    if not client then
        for id, _ in pairs(current_diagnostics) do
            for _, setting in ipairs(TABLE) do
                settings[setting] = current_diagnostics[id].settings[setting].default
            end
            Diagnostics.configure_diagnostics(settings)
            current_diagnostics[id].settings.all = true
        end
        vim.api.nvim_echo({ { "diagnostics for all attached servers are at default" } }, false, {})
    else
        local name = util.get_active_client_by_name(0, client)
        if name then
            for _, setting in ipairs(TABLE) do
                settings[setting] = current_diagnostics[client].settings[setting].default
            end
            Diagnostics.configure_diagnostics(settings, client)
            current_diagnostics[client].settings.all = true
            vim.api.nvim_echo({ { string.format("all diagnostics for %s are at default", client) } }, false, {})
        else
            print(string.format("The language server %s is not active on this buffer", client))
        end
    end
end

function Diagnostics.turn_on_diagnostics(client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            Diagnostics.configure_diagnostics {
                underline = true,
                virtual_text = true,
                signs = true,
                update_in_insert = true,
            }
            current_diagnostics[id].settings.all = true
        end
    else
        local name = util.get_active_client_by_name(0, client)
        if name then
            Diagnostics.configure_diagnostics({
                underline = true,
                virtual_text = true,
                signs = true,
                update_in_insert = true,
            }, client)
            current_diagnostics[client].settings.all = true
        else
            print(string.format("The language server %s is not active on this buffer", client))
        end
    end
end

function Diagnostics.toggle_all_diagnostics(client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            if current_diagnostics[id].settings.all then
                Diagnostics.turn_off_diagnostics()
            else
                Diagnostics.turn_on_diagnostics()
            end
            Diagnostics.display_status("all diagnostics for attached servers are", current_diagnostics[id].settings.all)
        end
    else
        local name = util.get_active_client_by_name(0, client)
        if name then
            if current_diagnostics[name.id].settings.all then
                Diagnostics.turn_off_diagnostics(client)
            else
                Diagnostics.turn_on_diagnostics(client)
            end
            Diagnostics.display_status("all diagnostics are", current_diagnostics[client].settings.all, client)
        else
            print(string.format("The language server %s is not active on this buffer", client))
        end
    end
end

function Diagnostics.toggle_diagnostic(name, client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            if type(current_diagnostics[id].settings[name].default) == "boolean" then
                current_diagnostics[id].settings[name].value = not current_diagnostics[id].settings[name].value
            elseif current_diagnostics[id].settings[name].value == false then
                current_diagnostics[id].settings[name].value = current_diagnostics[id].settings[name].default
            else
                current_diagnostics[id].settings[name].value = false
            end
            Diagnostics.display_status(name .. " is", current_diagnostics[id].settings[name].value)
            Diagnostics.configure_diagnostics { [name] = current_diagnostics[id].settings[name].value }
            return current_diagnostics[id].settings[name].value
        end
    else
        local cname = util.get_active_client_by_name(0, client)
        if cname then
            if type(current_diagnostics[client].settings[name].default) == "boolean" then
                current_diagnostics[client].settings[name].value = not current_diagnostics[client].settings[name].value
            elseif current_diagnostics[client].settings[name].value == false then
                current_diagnostics[client].settings[name].value = current_diagnostics[client].settings[name].default
            else
                current_diagnostics[client].settings[name].value = false
            end
            Diagnostics.display_status(name .. " is", current_diagnostics[client].settings[name].value, client)
            Diagnostics.configure_diagnostics({
                [name] = current_diagnostics[client].settings[name].value,
            }, client)
            return current_diagnostics[client].settings[name].value
        else
            print(string.format("The language server %s is not active on this buffer", client))
        end
    end
end

function Diagnostics.toggle_underline(client)
    if client then
        Diagnostics.toggle_diagnostic("underline", client)
    else
        Diagnostics.toggle_diagnostic "underline"
    end
end

function Diagnostics.toggle_signs(client)
    if client then
        Diagnostics.toggle_diagnostic("signs", client)
    else
        Diagnostics.toggle_diagnostic "signs"
    end
end

function Diagnostics.toggle_virtual_text(client)
    if client then
        Diagnostics.toggle_diagnostic("virtual_text", client)
    else
        Diagnostics.toggle_diagnostic "virtual_text"
    end
end

function Diagnostics.toggle_update_in_insert(client)
    if client then
        Diagnostics.toggle_diagnostic("update_in_insert", client)
    else
        Diagnostics.toggle_diagnostic "update_in_insert"
    end
end

function Diagnostics.current_settings(new_settings, client)
    local settings = {}
    for _, setting in pairs(TABLE) do
        settings[setting] = current_diagnostics[client].settings[setting].value
    end
    if not vim.tbl_isempty(new_settings) then
        for setting, value in pairs(new_settings) do
            settings[setting] = value
        end
    end
    return settings
end

function Diagnostics.returnID(client)
    local lang_server = util.get_active_client_by_name(0, client)
    return lang_server.id
end

function Diagnostics.configure_diagnostics(settings, client)
    if not client then
        for id, _ in pairs(current_diagnostics) do
            local conf = Diagnostics.current_settings(settings, id)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                conf
            )
            local client_id = Diagnostics.returnID(id)
            local buffers = lsp.get_buffers_by_client_id(client_id)
            for _, buffer_id in ipairs(buffers) do
                Diagnostics.show(buffer_id, client_id, conf)
            end
        end
    else
        local conf = Diagnostics.current_settings(settings, client)
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            conf
        )
        local client_id = Diagnostics.returnID(client)
        local buffers = lsp.get_buffers_by_client_id(client_id)
        for _, buffer_id in ipairs(buffers) do
            Diagnostics.show(buffer_id, client_id, conf)
        end
    end
end

function Diagnostics.resolve_handler(client, method)
    return client.handlers[method]
end

function Diagnostics.display_status(msg, val, client)
    if not client then
        if val == false then
            vim.api.nvim_echo({ { string.format("%s off", msg) } }, false, {})
        else
            vim.api.nvim_echo({ { string.format("%s on", msg) } }, false, {})
        end
    else
        if val == false then
            vim.api.nvim_echo({ { string.format("%s off for %s", msg, client) } }, false, {})
        else
            vim.api.nvim_echo({ { string.format("%s on for %s", msg, client) } }, false, {})
        end
    end
end

function Diagnostics.dump(client)
    if not client then
        print(vim.inspect(current_diagnostics))
    end
    print(vim.inspect(current_diagnostics[client]))
end

function Diagnostics.tableHasKey(table, key)
    if table[key] ~= nil then
        return true
    end
end

return Diagnostics
