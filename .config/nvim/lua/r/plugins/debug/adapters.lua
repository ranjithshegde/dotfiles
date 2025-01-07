local adapters = {}

adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb',
}

local cpp_tools = nil

if vim.fn.has 'win32' == 1 then
    cpp_tools =
        vim.fs.normalize '~/.vscode/extensions/ms-vscode.cpptools-1.13.6-win32-x64/debugAdapters/bin/OpenDebugAD7'
elseif vim.env.MACHINE_TYPE and vim.env.MACHINE_TYPE == 'laptop' then
    cpp_tools = vim.env.XDG_DATA_HOME .. '/debug-adapters/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
else
    cpp_tools = '/usr/share/cpptools-debug/bin/OpenDebugAD7'
end

adapters.cppdbg = {
    type = 'executable',
    command = cpp_tools,
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
    command = '/usr/bin/netcoredbg',
    args = { '--interpreter=vscode' },
}

adapters.godot = {
    type = 'server',
    host = '127.0.0.1',
    port = 6006,
}

return adapters
