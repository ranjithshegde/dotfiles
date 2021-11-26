local Diagnostics = {
    settings = {
        all = true,
        start_on = true,
        underline = { default = true },
        virtual_text = { default = true },
        signs = { default = true },
        update_in_insert = { default = true },
    },
}

do
    local ok, m = pcall(require, "vim.diagnostic")
    if ok then
        Diagnostics.show = function(b, c, conf)
            m.show(vim.lsp.diagnostic.get_namespace(c), b, nil, conf)
        end
    else
        Diagnostics.show = function(b, c, conf)
            require("vim.lsp.diagnostic").display(nil, b, c, conf)
        end
    end
end

local SETTABLE = { "underline", "virtual_text", "signs", "update_in_insert" }

function Diagnostics.init(userSettings)
    local user_settings = userSettings or {}
    for _, setting in ipairs(SETTABLE) do
        if user_settings[setting] ~= nil then
            Diagnostics.settings[setting].default = user_settings[setting]
        end
        Diagnostics.settings[setting].value = Diagnostics.settings[setting].default
    end
    if user_settings["start_on"] ~= nil and not user_settings["start_on"] then
        Diagnostics.turn_off_diagnostics()
    else
        Diagnostics.configure_diagnostics()
    end
end

function Diagnostics.current_settings(new_settings)
    local settings = {}
    for _, setting in pairs(SETTABLE) do
        settings[setting] = Diagnostics.settings[setting].value
    end
    for setting, value in pairs(new_settings or {}) do
        settings[setting] = value
    end
    return settings
end

function Diagnostics.turn_off_diagnostics()
    Diagnostics.configure_diagnostics {
        underline = false,
        virtual_text = false,
        signs = false,
        update_in_insert = false,
    }
    Diagnostics.settings.all = false
end

function Diagnostics.turn_on_diagnostics_default()
    local settings = {}
    for _, setting in ipairs(SETTABLE) do
        settings[setting] = Diagnostics.settings[setting].default
    end
    Diagnostics.configure_diagnostics(settings)
    Diagnostics.settings.all = true
    vim.api.nvim_echo({ { "all diagnostics are at default" } }, false, {})
end

function Diagnostics.turn_on_diagnostics()
    Diagnostics.configure_diagnostics {
        underline = true,
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    }
    Diagnostics.settings.all = true
end

function Diagnostics.toggle_diagnostics()
    if Diagnostics.settings.all then
        Diagnostics.turn_off_diagnostics()
    else
        Diagnostics.turn_on_diagnostics()
    end
    Diagnostics.display_status("all diagnostics are", Diagnostics.settings.all)
end

function Diagnostics.toggle_diagnostic(name)
    if type(Diagnostics.settings[name].default) == "boolean" then
        Diagnostics.settings[name].value = not Diagnostics.settings[name].value
    elseif Diagnostics.settings[name].value == false then
        Diagnostics.settings[name].value = Diagnostics.settings[name].default
    else
        Diagnostics.settings[name].value = false
    end
    Diagnostics.display_status(name .. " is", Diagnostics.settings[name].value)
    Diagnostics.configure_diagnostics { [name] = Diagnostics.settings[name].value }
    return Diagnostics.settings[name].value
end

function Diagnostics.toggle_underline()
    Diagnostics.toggle_diagnostic "underline"
end
function Diagnostics.toggle_signs()
    Diagnostics.toggle_diagnostic "signs"
end
function Diagnostics.toggle_virtual_text()
    Diagnostics.toggle_diagnostic "virtual_text"
end
function Diagnostics.toggle_update_in_insert()
    Diagnostics.toggle_diagnostic "update_in_insert"
end

function Diagnostics.configure_diagnostics(settings)
    local conf = Diagnostics.current_settings(settings or {})
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, conf)
    local clients = vim.lsp.get_active_clients()
    for client_id, _ in pairs(clients) do
        local buffers = vim.lsp.get_buffers_by_client_id(client_id)
        for _, buffer_id in ipairs(buffers) do
            Diagnostics.show(buffer_id, client_id, conf)
        end
    end
end

function Diagnostics.display_status(msg, val)
    if val == false then
        vim.api.nvim_echo({ { string.format("%s off", msg) } }, false, {})
    else
        vim.api.nvim_echo({ { string.format("%s on", msg) } }, false, {})
    end
end

function Diagnostics.dump()
    print(vim.inspect(Diagnostics))
end

return Diagnostics
