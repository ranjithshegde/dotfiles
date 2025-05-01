local configs = {}

local gdb_path = '/usr/bin/gdb'

if vim.g.is_mac then
    gdb_path = '/opt/homebrew/bin/gdb'
end

local function get_cppdbg_base()
    return {
        type = 'cppdbg',
        request = 'launch',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        showDisplayString = true,
        MIMode = 'gdb',
        setupCommands = {
            { text = '-enable-pretty-printing', description = 'enable pretty printing', ignoreFailures = true },
        },
    }
end

local function get_program_path(prompt, default_var)
    return function()
        if default_var and vim.b[default_var] then
            return vim.b[default_var]
        end
        return vim.fn.input(prompt, vim.fn.getcwd() .. '/', 'file')
    end
end

configs.cpp = {
    vim.tbl_extend('force', get_cppdbg_base(), {
        name = 'Launch vscode-gdb',
        program = get_program_path('Path to executable: ', 'debugBin'),
        miDebuggerPath = gdb_path,
    }),

    vim.tbl_extend('force', get_cppdbg_base(), {
        name = 'Launch vscode-gdb with custom binary',
        program = get_program_path 'Path to executable: ',
        miDebuggerPath = gdb_path,
    }),

    vim.tbl_extend('force', get_cppdbg_base(), {
        name = 'Launch vscode-gdb for test binary',
        program = get_program_path('Path to test executable: ', 'test_bin'),
        miDebuggerPath = gdb_path,
    }),

    vim.tbl_extend('force', get_cppdbg_base(), {
        name = 'Launch vscode-gdb on Nvidia',
        program = get_program_path('Path to executable: ', 'debugBin'),
        miDebuggerPath = '/usr/local/bin/prime-debug',
    }),
    -- lldb-native
    {
        name = 'Launch lldb',
        type = 'lldb',
        request = 'launch',
        program = function()
            if vim.b.debugBin then
                return vim.b.debugBin
            else
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format('%s=%s', k, v))
            end
            return variables
        end,
        runInTerminal = false,
    },
    -- lldb-vscode
    {
        name = 'codelldb',
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

configs.c = configs.cpp

configs.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',

        program = '${file}',
        pythonPath = function()
            local cwd = vim.uv.cwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else
                return '/usr/bin/python'
            end
        end,
    },
}

configs.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.uv.cwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    },
    {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require('dap.utils').pick_process,
    },
}

configs.cs = {
    {
        type = 'coreclr',
        name = 'Dotnet',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}

configs.gdscript = {
    type = 'godot',
    request = 'launch',
    name = 'Launch scene',
    project = '${workspaceFolder}',
}

return configs
