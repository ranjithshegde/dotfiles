local adapters = {}

local cpptools_path = '/usr/share/cpptools-debug/bin/OpenDebugAD7'

if vim.g.is_win or vim.g.is_mac then
    local ext_path = vim.fs.normalize '~/.vscode/extensions/'
    local temp_path = vim.fs.find(function(name, _)
        return name:match 'ms%-vscode%.cpptools'
    end, {
        type = 'directory',
        path = ext_path,
    })

    cpptools_path = vim.fs.joinpath(temp_path[1], '/debugAdapters/bin/OpenDebugAD7')
end

adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb',
}

adapters.cppdbg = {
    type = 'executable',
    command = cpptools_path,
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
