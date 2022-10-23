local adapters = {}

adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb',
}

adapters.cppdbg = {
    type = 'executable',
    command = vim.env.XDG_DATA_HOME .. '/debug-adapters/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

adapters.python = {
    type = 'executable',
    command = 'python',
    args = { '-m', 'debugpy.adapter' },
}

adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { vim.env.XDG_DATA_HOME .. '/debug-adapters/node-debug2/out/src/nodeDebug.js' },
}

adapters.codelldb = function(on_adapter)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local cmd = vim.env.XDG_DATA_HOME .. '/debug-adapters/lldb/extension/adapter/codelldb'

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
            print('codelldb exited with code', code)
        end
    end)
    assert(handle, 'Error running codelldb: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            local port = chunk:match 'Listening on port (%d+)'
            if port then
                vim.schedule(function()
                    on_adapter {
                        type = 'server',
                        host = '127.0.0.1',
                        port = port,
                    }
                end)
            else
                vim.schedule(function()
                    require('dap.repl').append(chunk)
                end)
            end
        end
    end)
    stderr:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function()
                require('dap.repl').append(chunk)
            end)
        end
    end)
end

adapters.dart = {
    type = 'executable',
    command = 'node',
    args = { vim.env.XDG_DATA_HOME .. '/debug-adapters/Dart-Code/out/dist/debug.js', 'flutter' },
}

return adapters
