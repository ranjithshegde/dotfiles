local Debugger = {}

Debugger.init = function()
    vim.cmd "PackerLoad nvim-dap"
    -- vim.cmd "PackerLoad telescope-dap.nvim"
    require("mappings").debug()
    require("dap.ext.vscode").load_launchjs "launch.json"
    -- require("telescope").load_extension "dap"
    print "Loaded nvim-dap. Bound keymaps"
end

Debugger.setup = function()
    local dap = require "dap"

    dap.defaults.fallback.terminal_win_cmd = "tabnew"
    dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/st",
        args = { "-e" },
    }
    require("debugger").adapters()
    require("debugger").configs()
end

Debugger.adapters = function()
    local dap = require "dap"
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
    }
    dap.adapters.cppdbg = {
        type = "executable",
        command = os.getenv "XDG_DATA_HOME" .. "/debug-adapters/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }
    dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { os.getenv "XDG_DATA_HOME" .. "/debug-adapters/node-debug2/out/src/nodeDebug.js" },
    }
    dap.adapters.codelldb = function(on_adapter)
        local stdout = vim.loop.new_pipe(false)
        local stderr = vim.loop.new_pipe(false)
        local cmd = os.getenv "XDG_DATA_HOME" .. "/debug-adapters/lldb/extension/adapter/codelldb"

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
end

Debugger.configs = function()
    local dap = require "dap"
    dap.configurations.cpp = {
        {
            name = "Launch vscode-gdb",
            type = "cppdbg",
            request = "launch",
            program = function()
                if G.debugBin then
                    return G.debugBin
                else
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end
            end,
            -- externalConsole = true,
            visualizerFile = os.getenv "XDG_DATA_HOME" .. "/debug-adapters/natvis/concurrency.natvis",
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisplayString = true,
            MIMode = "gdb",
            miDebuggerPath = "/usr/bin/gdb",
            setupCommands = {
                { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = true },
            },
        },
        {
            name = "Launch vscode-gdb on Nvidia",
            type = "cppdbg",
            request = "launch",
            program = function()
                if G.debugBin then
                    return G.debugBin
                else
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end
            end,
            -- externalConsole = true,
            visualizerFile = os.getenv "XDG_DATA_HOME" .. "/debug-adapters/natvis/concurrency.natvis",
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisplayString = true,
            MIMode = "gdb",
            miDebuggerPath = "/usr/local/bin/prime-debug",
            setupCommands = {
                { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = true },
            },
        },
        {
            name = "Launch lldb",
            type = "lldb",
            request = "launch",
            program = function()
                if G.debugBin then
                    return G.debugBin
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
                local cwd = vim.fn.getcwd()
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
            cwd = vim.fn.getcwd(),
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
    dap.configurations.java = {
        {
            type = "java",
            request = "attach",
            name = "Debug (Attach) - Remote",
            hostName = "127.0.0.1",
            port = 5005,
        },
    }
end

Debugger.makeSidebar = function(func)
    local widgets = require "dap.ui.widgets"
    if func == "scopes" then
        return widgets.sidebar(widgets.scopes, { width = 40 })
    elseif func == "frames" then
        return widgets.sidebar(widgets.frames, { width = 40 })
    elseif func == "exp" then
        return widgets.sidebar(widgets.expression, { width = 40 })
    end
end

Debugger.scopes = function()
    if not Sscope then
        Sscope = Debugger.makeSidebar "scopes"
    end
    if not Bscope then
        Sscope.open()
        Bscope = true
    else
        Sscope.close()
        Bscope = false
    end
end

Debugger.frames = function()
    if not Sframe then
        Sframe = Debugger.makeSidebar "frames"
    end
    if not Bframe then
        Sframe.open()
        Bframe = true
    else
        Sframe.close()
        Bframe = false
    end
end

Debugger.exp = function()
    if not Sexp then
        Sexp = Debugger.makeSidebar "exp"
    end
    if not Bexp then
        Sexp.open()
        Bexp = true
    else
        Sexp.close()
        Bexp = false
    end
end

Debugger.fscopes = function()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.scopes, { border = "double" })
end

Debugger.fframes = function()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.frames, { border = "double" })
end

Debugger.fexp = function()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.expression, { border = "double" })
end

return Debugger
