local ls = {}

ls.getClientNames = function()
    local buf_clients = vim.lsp.get_active_clients()

    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
    end
    return buf_client_names
end

------------------------------------------------------------------------
--                              Capabilities                          --
------------------------------------------------------------------------

local config = {
    relative = "cursor",
    style = "minimal",
    width = 70,
    height = 25,
    row = 0,
    col = 0,
    border = "double",
}

local function available_capabilities(server_capabilities)
    return vim.tbl_filter(function(key)
        if type(server_capabilities[key]) == "table" then
            return not vim.tbl_isempty(server_capabilities[key])
        else
            return server_capabilities[key] == true
        end
    end, vim.tbl_keys(server_capabilities))
end

ls.lsp_capabilities = function()
    local init_buf = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_active_clients { bufnr = init_buf }
    local bufnr = vim.api.nvim_create_buf(false, true)

    local buf_lines = {}

    local function make_client_info(client)
        local info = client.name .. " (id " .. tostring(client.id) .. ")"
        local capabils = { "## Capabilities:", "```json" }
        if client.server_capabilities then
            local all = client.server_capabilities
            local cap_resolved = available_capabilities(client.server_capabilities)
            local cap_raw = vim.tbl_keys(client.server_capabilities)

            for _, value in ipairs(cap_raw) do
                if vim.tbl_contains(cap_resolved, value) then
                    if type(all[value]) == "table" then
                        local k1 = vim.tbl_keys(all[value])
                        table.insert(capabils, "\t " .. value .. " = {")
                        for _, val in pairs(k1) do
                            if type(all[value][val]) == "table" then
                                local k2 = vim.tbl_keys(all[value][val])
                                table.insert(capabils, "\t\t " .. val .. " = {")
                                local sub = {}
                                for _, v in pairs(k2) do
                                    local s = all[value][val][v]
                                    if s then
                                        if type(s) == "table" then
                                            table.insert(capabils, "\t\t\t " .. table.concat(s, ", "))
                                        elseif type(s) == "string" then
                                            local ss = string.gsub(s, "\n", "\\n")
                                            table.insert(sub, ss)
                                        else
                                            table.insert(capabils, "\t\t\t " .. tostring(s))
                                        end
                                    end
                                end
                                if not vim.tbl_isempty(sub) then
                                    table.insert(capabils, "\t\t\t " .. table.concat(sub, ", "))
                                end
                                table.insert(capabils, "\t\t }")
                            else
                                table.insert(capabils, "\t\t " .. val .. [[ = "true",]])
                            end
                        end
                        table.insert(capabils, "\t },")
                    else
                        table.insert(capabils, "\t " .. value .. [[ = "true",]])
                    end
                else
                    table.insert(capabils, "\t " .. value .. [[ = "false",]])
                end
            end
        end
        return {
            "# Client: " .. info,
            capabils,
        }
    end

    for _, client in ipairs(buf_clients) do
        local newlines = make_client_info(client)
        vim.list_extend(buf_lines, { newlines[1] })
        vim.list_extend(buf_lines, newlines[2])
        vim.list_extend(buf_lines, { "```" })
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
    vim.bo[bufnr].modifiable = false
    vim.keymap.set("n", "<esc>", "<cmd>bd<CR>", { buffer = bufnr })
    vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = bufnr })
    vim.api.nvim_open_win(bufnr, true, config)
    vim.bo[bufnr].filetype = "markdown"
end

------------------------------------------------------------------------
--                              Notification                          --
------------------------------------------------------------------------

function ls.lsp_progress()
    local notice = require "r.settings.notify"

    vim.lsp.handlers["$/progress"] = function(_, result, ctx)
        local client_id = ctx.client_id
        local name = vim.lsp.get_client_by_id(client_id).name
        if name == "null-ls" then
            return
        end

        local val = result.value

        if not val.kind then
            return
        end

        local notif_data = notice.get_notif_data(client_id, result.token)

        if val.kind == "begin" then
            local message = notice.format_message(val.message, val.percentage)

            notif_data.notification = vim.notify(message, "info", {
                title = notice.format_title(val.title, name),
                icon = notice.spinner_frames[1],
                timeout = false,
                hide_from_history = false,
            })

            notif_data.spinner = 1
            notice.update_spinner(client_id, result.token)
        elseif val.kind == "report" and notif_data then
            notif_data.notification = vim.notify(notice.format_message(val.message, val.percentage), "info", {
                replace = notif_data.notification,
                hide_from_history = false,
            })
        elseif val.kind == "end" and notif_data then
            notif_data.notification =
                vim.notify(val.message and notice.format_message(val.message) or "Complete", "info", {
                    icon = "",
                    replace = notif_data.notification,
                    timeout = 3000,
                })

            notif_data.spinner = nil
        end
    end
end

-- table from lsp severity to vim severity.
local severity = {
    "error",
    "warn",
    "info",
    "info", -- map both hint and info to info?
}

function ls.lsp_messages()
    vim.notify = require "notify"
    vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
        vim.notify(method.message, severity[params.type])
    end
end

------------------------------------------------------------------------
--                              TexLab                                --
------------------------------------------------------------------------

---Return word count for the tex document
function ls.TexWordCount()
    local Job = require "plenary.job"
    Job:new({
        command = "texcount",
        args = { "-inc", "-sum", "-1", vim.fn.expand "%" },
        on_exit = function(j, return_val)
            vim.pretty_print(return_val)
            vim.pretty_print(j:result())
        end,
    }):sync()
end

------------------------------------------------------------------------
--                              Null-ls                               --
------------------------------------------------------------------------

function ls.glsl()
    local null_ls = require "null-ls"

    return {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "glsl" },
        generator = null_ls.generator {
            command = "glslangValidator",
            args = { "--stdin", "-S", "$FILEEXT" },
            to_stdin = true,
            from_stderr = true,
            format = "raw",
            check_exit_code = function(code, stderr)
                local success = code <= 1
                if not success then
                    print(stderr)
                end

                return success
            end,
            on_output = function(params, done)
                if params and params.output then
                    local diagnostics = {}
                    local lines = vim.split(params.output, "\n")
                    local sever, col, row, message = string.match(lines[2], "(%u+):%s(%d+):(%d+):.*:%s+(.*)")

                    table.insert(diagnostics, {
                        row = row,
                        col = col + 1,
                        end_col = col + 2,
                        source = "GLSLang",
                        message = message,
                        severity = require("null-ls.helpers").diagnostics.severities[vim.fn.tolower(sever)],
                    })
                    done(diagnostics)
                else
                    done()
                end
            end,
        },
    }
end

return ls
