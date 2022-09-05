local notify = {}

notify.client_notifs = {}

function notify.get_notif_data(client_id, token)
    if not notify.client_notifs[client_id] then
        notify.client_notifs[client_id] = {}
    end

    if not notify.client_notifs[client_id][token] then
        notify.client_notifs[client_id][token] = {}
    end

    return notify.client_notifs[client_id][token]
end

notify.spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

function notify.update_spinner(client_id, token)
    local notif_data = notify.get_notif_data(client_id, token)

    if notif_data.spinner then
        local new_spinner = (notif_data.spinner + 1) % #notify.spinner_frames
        notif_data.spinner = new_spinner

        notif_data.notification = vim.notify(nil, nil, {
            hide_from_history = true,
            icon = notify.spinner_frames[new_spinner],
            replace = notif_data.notification,
        })

        vim.defer_fn(function()
            notify.update_spinner(client_id, token)
        end, 100)
    end
end

function notify.format_title(title, client_name)
    return client_name .. (#title > 0 and ': ' .. title or '')
end

function notify.format_message(message, percentage)
    return (percentage and percentage .. '%\t' or '') .. (message or '')
end

return notify
