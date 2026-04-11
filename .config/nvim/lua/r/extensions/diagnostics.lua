------------------------------------------------------------------------
--                              General functions                     --
------------------------------------------------------------------------

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

local float_conf = {
    show_header = true,
    source = 'always',
    format = function(diagnostic)
        if diagnostic.code then
            return ('[%s] %s'):format(diagnostic.code, diagnostic.message)
        end
        return diagnostic.message
    end,
}

local lines_conf = { current_line = true }

local on_jump = function(diagnostic, _)
    if not diagnostic then
        return
    end
    vim.schedule(vim.diagnostic.open_float)
end

local default_settings = {
    underline = false,
    virtual_text = false,
    signs = sign_conf,
    update_in_insert = false,
    float = float_conf,
    jump = { on_jump = on_jump },
    virtual_lines = lines_conf,
}

local client_diagnostics = {}

local function get_namespace(client)
    if not client_diagnostics[client.id] then
        client_diagnostics[client.id] = {
            ns = vim.lsp.diagnostic.get_namespace(client.id),
            config = vim.deepcopy(default_settings),
        }
    end
    return client_diagnostics[client.id].ns
end

local function get_config(client)
    return client_diagnostics[client.id] and client_diagnostics[client.id].config or vim.deepcopy(default_settings)
end

local function apply_initial_settings(client)
    local ns = get_namespace(client)
    vim.diagnostic.config(get_config(client), ns)
end

local function toggle_setting(setting, client_name)
    local clients = client_name and { vim.lsp.get_clients({ name = client_name })[1] } or vim.lsp.get_clients()

    if not clients or #clients == 0 then
        vim.notify('No active clients found', vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        local ns = get_namespace(client)
        local config = get_config(client)

        if setting == 'signs' then
            if config.signs == false then
                config.signs = sign_conf
            else
                config.signs = false
            end
        elseif setting == 'virtual_lines' then
            if config.virtual_lines == false then
                config.virtual_lines = lines_conf
            else
                config.virtual_lines = false
            end
        else
            config[setting] = not config[setting]
        end

        vim.diagnostic.config(config, ns)
    end
end

------------------------------------------------------------------------
--                              Diagnostic Toggle                     --
------------------------------------------------------------------------

local Diagnostics = {}

function Diagnostics.attach(client, bufnr, settings)
    if settings then
        client_diagnostics[client.id] = client_diagnostics[client.id] or {}
        client_diagnostics[client.id].config = vim.tbl_deep_extend('force', get_config(client), settings)
    end
    apply_initial_settings(client)

    Diagnostics.commands(bufnr)
end

function Diagnostics.toggle_underline(client_name)
    toggle_setting('underline', client_name)
end

function Diagnostics.toggle_virtual_text(client_name)
    toggle_setting('virtual_text', client_name)
end

function Diagnostics.toggle_lines(client_name)
    toggle_setting('virtual_lines', client_name)
end

function Diagnostics.toggle_signs(client_name)
    toggle_setting('signs', client_name)
end

function Diagnostics.toggle_update_in_insert(client_name)
    toggle_setting('update_in_insert', client_name)
end

function Diagnostics.enable_all(client_name)
    local clients = client_name and { vim.lsp.get_clients({ name = client_name })[1] } or vim.lsp.get_clients()

    if not clients or #clients == 0 then
        vim.notify('No active clients found', vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        local ns = get_namespace(client)
        client_diagnostics[client.id].config = vim.deepcopy(default_settings)
        vim.diagnostic.config(client_diagnostics[client.id].config, ns)
    end
end

function Diagnostics.disable_all(client_name)
    local clients = client_name and { vim.lsp.get_clients({ name = client_name })[1] } or vim.lsp.get_clients()

    if not clients or #clients == 0 then
        vim.notify('No active clients found', vim.log.levels.WARN)
        return
    end

    for _, client in ipairs(clients) do
        local ns = get_namespace(client)
        local config = get_config(client)

        for key, _ in pairs(default_settings) do
            if key == 'signs' then
                config.signs = false
            else
                config[key] = false
            end
        end

        vim.diagnostic.config(config, ns)
    end
end

------------------------------------------------------------------------
--                          User commands                             --
------------------------------------------------------------------------

function Diagnostics.commands(bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local complete = function()
        return require('r.utils').get_client_names()
    end

    cmd(bufnr, 'ToggleVirtual', function(opts)
        Diagnostics.toggle_virtual_text(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Toggle diagnostic virtual text for a client' })

    cmd(bufnr, 'ToggleLines', function(opts)
        Diagnostics.toggle_lines(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Toggle diagnostic lines for a client' })

    cmd(bufnr, 'ToggleSigns', function(opts)
        Diagnostics.toggle_signs(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Toggle diagnostic signs for a client' })

    cmd(bufnr, 'ToggleUnderline', function(opts)
        Diagnostics.toggle_underline(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Toggle diagnostic underlines for a client' })

    cmd(bufnr, 'DisableDiagnostics', function(opts)
        Diagnostics.disable_all(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Disable all diagnostic options for a client' })

    cmd(bufnr, 'EnableDiagnostics', function(opts)
        Diagnostics.enable_all(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Enable all diagnostic options for a client' })

    cmd(bufnr, 'DefaultDiagnostics', function(opts)
        Diagnostics.turn_on_diagnostics_default(opts.args)
    end, { nargs = '*', complete = complete, desc = 'Enable default diagnostic options for a client' })
end

return Diagnostics
