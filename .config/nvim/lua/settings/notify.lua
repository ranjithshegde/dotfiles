local notify = {}

vim.notify = require "notify"
local client_notifs = {}

function notify.init()
    require("notify").setup {
        stages = "fade",
        -- on_open = function()
        --     return { opacity = 10 }
        -- end,
    }
end

local function get(client_id, token)
    if not client_notifs[client_id] then
        client_notifs[client_id] = {}
    end

    if not client_notifs[client_id][token] then
        client_notifs[client_id][token] = {}
    end

    return client_notifs[client_id][token]
end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
    local notif_data = get(client_id, token)

    if notif_data.spinner then
        local new_spinner = (notif_data.spinner + 1) % #spinner_frames
        notif_data.spinner = new_spinner

        notif_data.notification = vim.notify(nil, nil, {
            hide_from_history = true,
            icon = spinner_frames[new_spinner],
            replace = notif_data.notification,
        })

        vim.defer_fn(function()
            update_spinner(client_id, token)
        end, 100)
    end
end

local function format_title(title, client_name)
    return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
    return (percentage and percentage .. "%\t" or "") .. (message or "")
end

function notify.lsp()
    vim.lsp.handlers["$/progress"] = function(_, result, ctx)
        local client_id = ctx.client_id
        local val = result.value

        if not val.kind then
            return
        end

        local notif_data = get(client_id, result.token)

        if val.kind == "begin" then
            local message = format_message(val.message, val.percentage)

            notif_data.notification = vim.notify(message, "info", {
                title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
                icon = spinner_frames[1],
                timeout = false,
                hide_from_history = false,
            })

            notif_data.spinner = 1
            update_spinner(client_id, result.token)
        elseif val.kind == "report" and notif_data then
            notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
                replace = notif_data.notification,
                hide_from_history = false,
            })
        elseif val.kind == "end" and notif_data then
            notif_data.notification = vim.notify(val.message and format_message(val.message) or "Complete", "info", {
                icon = "",
                replace = notif_data.notification,
                timeout = 3000,
            })

            notif_data.spinner = nil
        end
    end
end

function notify.dap()
    local ok, dap = pcall(require, "dap")
    if not ok then
        print "DAP not loaded"
        return
    end

    dap.listeners.before["event_progressStart"]["progress-notifications"] = function(session, body)
        local notif_data = get("dap", body.progressId)

        local message = format_message(body.message, body.percentage)
        notif_data.notification = vim.notify(message, "info", {
            title = format_title(body.title, session.config.type),
            icon = spinner_frames[1],
            timeout = false,
            hide_form_history = false,
        })

        notif_data.notification.spinner = 1
        update_spinner("dap", body.progressId)
    end

    dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(session, body)
        local notif_data = get("dap", body.progressId)
        notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
            replace = notif_data.notification,
            hide_form_history = false,
        })
    end

    dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(session, body)
        local notif_data = client_notifs["dap"][body.progressId]
        notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
            icon = "",
            replace = notif_data.notification,
            timeout = 3000,
        })
        notif_data.spinner = nil
    end
end

return notify
