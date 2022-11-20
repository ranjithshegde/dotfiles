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

adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = '/usr/bin/codelldb',
        args = { '--port', '${port}' },
        -- detached = false,
    },
}

adapters.dart = {
    type = 'executable',
    command = 'node',
    args = { vim.env.XDG_DATA_HOME .. '/debug-adapters/Dart-Code/out/dist/debug.js', 'flutter' },
}

adapters.coreclr = {
    type = 'executable',
    command = '/usr/bin/netcodedbg',
    args = { '--interpreter=vscode' },
}

return adapters
