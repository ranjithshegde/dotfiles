local sclsp = {}

local util = require 'lspconfig.util'

sclsp.run_cmd = {
    '/usr/bin/nvim',
    '-l',
    '/home/ranjith/Workspaces/lua/Scratch/Supercollider/sclsp.lua',
}

sclsp.py_cmd = {
    '/usr/bin/python',
    '/home/ranjith/.local/share/SuperCollider/downloaded-quarks/LanguageServer.quark/lsp_runner/lsp_runner/main.py',
    '--sc-lang-path',
    '/usr/bin/sclang',
    '--sc-config-path',
    '/home/ranjith/.config/SuperCollider/sclang_lsp_conf.yaml',
}

sclsp.script = { vim.env.HOME .. '/.local/bin/scripts/sclsp.sh' }

sclsp.lspconfig = {
    default_config = {
        name = 'supercollider',
        cmd = sclsp.script,
        root_dir = util.root_pattern('.git', 'supercollider.yaml') or vim.uv.cwd,
        filetypes = { 'supercollider' },
        settings = {},
        docs = {
            description = [[
https://github.com/supercollider/supercollider
Language Server for SuperCollider
    ]],
            default_config = {
                root_dir = [[root_pattern(".git") or root_pattern("supercollider.yaml")]],
            },
        },
    },
}

sclsp.server = {
    name = 'supercollider',
    cmd = sclsp.script,
    root_dir = vim.fs.root(0, { 'supercollider.yaml', '.git' }) or vim.uv.cwd,
    filetypes = { 'supercollider' },
}

sclsp.sclua = {
    default_config = {
        name = 'supercollider',
        cmd = sclsp.run_cmd,
        root_dir = util.root_pattern('.git', 'supercollider.yaml') or vim.uv.cwd,
        filetypes = { 'supercollider' },
        settings = {},
        docs = {
            description = [[
https://github.com/supercollider/supercollider
Language Server for SuperCollider
    ]],
            default_config = {
                root_dir = [[root_pattern(".git") or root_pattern("supercollider.yaml")]],
            },
        },
    },
}
sclsp.handle = nil

sclsp.start_process = function()
    vim.print 'Starting process'
    sclsp.handle = vim.uv.spawn('/usr/bin/sclang', {
        args = {
            '-i',
            'vscode',
            '-l',
            vim.env.HOME .. '/.config/Supercollider/sclang_lsp_conf.yaml',
        },
        exit_cb = function(code, signal)
            vim.schedule(function()
                vim.lsp.buf_detach_client(0)
                handle:close()
                print('SuperCollider language server exited with code ' .. code .. ' and signal ' .. signal)
            end)
        end,
    })
end

sclsp.connect = function(port, start_process)
    if start_process then
        sclsp.start_process()
    end
    vim.lsp.start {
        name = 'supercollider',
        cmd = vim.lsp.rpc.connect('127.0.0.1', port and port or 57211),
        -- cmd = function(...)
        --     local args = { ... }
        --     vim.print(args)
        --     vim.print 'Calling Start'
        --     return vim.lsp.rpc.connect('localhost', 57210)
        -- end,

        root_dir = vim.fs.root(0, { 'supercollider.yaml', '.git' }) or vim.uv.cwd(),
        filetypes = { 'supercollider' },
    }
end

return sclsp
