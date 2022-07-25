local function makeSidebar(element, width)
    local widgets = require "dap.ui.widgets"
    if element == "scopes" then
        return widgets.sidebar(widgets.scopes, { width = width })
    elseif element == "frames" then
        return widgets.sidebar(widgets.frames, { width = width })
    elseif element == "threads" then
        return widgets.sidebar(widgets.threads, { width = width })
    elseif element == "exp" then
        return widgets.sidebar(widgets.expression, { width = width })
    end
end

local function adapters()
    local dap = require "dap"
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
    }
    dap.adapters.cppdbg = {
        type = "executable",
        command = vim.env.XDG_DATA_HOME .. "/debug-adapters/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }
    dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { vim.env.XDG_DATA_HOME .. "/debug-adapters/node-debug2/out/src/nodeDebug.js" },
    }
    dap.adapters.codelldb = function(on_adapter)
        local stdout = vim.loop.new_pipe(false)
        local stderr = vim.loop.new_pipe(false)
        local cmd = vim.env.XDG_DATA_HOME .. "/debug-adapters/lldb/extension/adapter/codelldb"

        local handle, pid_or_err
        local opts = {
            stdio = { nil, stdout, stderr },
            detached = true,
        }
        handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
            stdout:close()
            stderr:close()
            handle:close()
            if code ~= 0 then
                print("codelldb exited with code", code)
            end
        end)
        assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
        stdout:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                local port = chunk:match "Listening on port (%d+)"
                if port then
                    vim.schedule(function()
                        on_adapter {
                            type = "server",
                            host = "127.0.0.1",
                            port = port,
                        }
                    end)
                else
                    vim.schedule(function()
                        require("dap.repl").append(chunk)
                    end)
                end
            end
        end)
        stderr:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                vim.schedule(function()
                    require("dap.repl").append(chunk)
                end)
            end
        end)
    end
    dap.adapters.dart = {
        type = "executable",
        command = "node",
        args = { vim.env.XDG_DATA_HOME .. "/debug-adapters/Dart-Code/out/dist/debug.js", "flutter" },
    }
end

local function configs()
    local dap = require "dap"
    dap.configurations.cpp = {
        -- cpptools with gdb
        {
            name = "Launch vscode-gdb",
            type = "cppdbg",
            request = "launch",
            program = function()
                if vim.g.debugBin then
                    return vim.g.debugBin
                else
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end
            end,
            -- externalConsole = true,
            visualizerFile = vim.env.XDG_DATA_HOME .. "/debug-adapters/natvis/concurrency.natvis",
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisplayString = true,
            MIMode = "gdb",
            miDebuggerPath = "/usr/bin/gdb",
            setupCommands = {
                { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = true },
            },
        },
        -- cpptools with gdb on nVidia
        {
            name = "Launch vscode-gdb on Nvidia",
            type = "cppdbg",
            request = "launch",
            program = function()
                if vim.g.debugBin then
                    return vim.g.debugBin
                else
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end
            end,
            -- externalConsole = true,
            visualizerFile = vim.env.XDG_DATA_HOME .. "/debug-adapters/natvis/concurrency.natvis",
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisplayString = true,
            MIMode = "gdb",
            miDebuggerPath = "/usr/local/bin/prime-debug",
            setupCommands = {
                { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = true },
            },
        },
        -- lldb-native
        {
            name = "Launch lldb",
            type = "lldb",
            request = "launch",
            program = function()
                if vim.g.debugBin then
                    return vim.g.debugBin
                else
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            env = function()
                local variables = {}
                for k, v in pairs(vim.fn.environ()) do
                    table.insert(variables, string.format("%s=%s", k, v))
                end
                return variables
            end,
            runInTerminal = false,
        },
        -- lldb-vscode
        {
            name = "codelldb",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",

            program = "${file}",
            pythonPath = function()
                local cwd = vim.loop.cwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                    return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                    return cwd .. "/.venv/bin/python"
                else
                    return "/usr/bin/python"
                end
            end,
        },
    }
    dap.configurations.javascript = {
        {
            name = "Launch",
            type = "node2",
            request = "launch",
            program = "${file}",
            cwd = vim.loop.cwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
        {
            -- For this to work you need to make sure the node process is started with the `--inspect` flag.
            name = "Attach to process",
            type = "node2",
            request = "attach",
            processId = require("dap.utils").pick_process,
        },
    }
    dap.configurations.dart = {
        {
            type = "dart",
            request = "launch",
            name = "Launch flutter",
            dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/",
            flutterSdkPath = "/opt/flutter/",
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
        },
    }
end

local function signs()
    vim.fn.sign_define("DapBreakpoint", { text = "🟥" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "🟦" })
    vim.fn.sign_define("DapStopped", { text = "⭐️" })
end

local function notify()
    local dap = require "dap"
    local note = require "r.settings.notify"

    dap.listeners.before["event_progressStart"]["progress-notifications"] = function(session, body)
        local notif_data = note.get_notif_data("dap", body.progressId)

        local message = note.format_message(body.message, body.percentage)
        notif_data.notification = vim.notify(message, "info", {
            title = note.format_title(body.title, session.config.type),
            icon = note.spinner_frames[1],
            timeout = false,
            hide_from_history = false,
        })

        notif_data.notification.spinner = 1, note.update_spinner("dap", body.progressId)
    end

    dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(session, body)
        local notif_data = note.get_notif_data("dap", body.progressId)
        notif_data.notification = vim.notify(note.format_message(body.message, body.percentage), "info", {
            replace = notif_data.notification,
            hide_from_history = false,
        })
    end

    dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(session, body)
        local notif_data = note.client_notifs["dap"][body.progressId]
        notif_data.notification = vim.notify(body.message and note.format_message(body.message) or "Complete", "info", {
            icon = "",
            replace = notif_data.notification,
            timeout = 3000,
        })
        notif_data.spinner = nil
    end
end

local Debugger = {}

function Debugger.init()
    require("packer").loader "nvim-dap"
    signs()

    require("dapui").setup {
        layouts = {
            {
                elements = { "scopes", "breakpoints", "stacks", "watches" },
                size = 70,
                position = "left",
            },
            {
                elements = { "repl", "console" },
                size = 0.25,
                position = "bottom",
            },
        },
    }

    require("r.mappings.lsp").debug()
    require("dap.ext.vscode").load_launchjs "launch.json"
    vim.notify "Loaded nvim-dap. Bound keymaps"
end

function Debugger.setup()
    local dap = require "dap"

    Debugger.frames = makeSidebar("frames", 70)
    Debugger.scopes = makeSidebar("scopes", 60)
    Debugger.exp = makeSidebar("exp", 40)
    Debugger.threads = makeSidebar("threads", 40)

    dap.defaults.fallback.terminal_win_cmd = "tabnew"
    dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/st",
        args = { "-e" },
    }
    adapters()
    configs()

    dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
    end

    notify()

    local dap_repl = vim.api.nvim_create_augroup("dap-repl", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = dap_repl,
        pattern = "dap-repl",
        callback = function()
            require("dap.ext.autocompl").attach()
        end,
    })

    require("r.utils").register_au_id(dap_repl)
end

function Debugger.fscopes()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.scopes, { border = "double" })
end

function Debugger.fthreads()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.threads, { border = "double" })
end

function Debugger.fframes()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.frames, { border = "double" })
end

function Debugger.fexp()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.expression, { border = "double" })
end

return Debugger
