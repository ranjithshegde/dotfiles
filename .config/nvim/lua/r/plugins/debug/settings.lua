local function makeSidebar(element, width)
    local widgets = require 'dap.ui.widgets'
    return widgets.sidebar(widgets[element], { width = width })
end

local function makeFloat(element)
    local widgets = require 'dap.ui.widgets'
    return function()
        widgets.centered_float(widgets[element], { border = 'double' })
    end
end

local function signs()
    vim.fn.sign_define('DapBreakpoint', { text = '🟥' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '🟦' })
    vim.fn.sign_define('DapStopped', { text = '⭐️' })
end

local Debugger = {}

function Debugger.init()
    local id = {}
    id.dap = vim.api.nvim_create_augroup('dap', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = id.dap,
        pattern = 'dap-repl',
        callback = function()
            require('dap.ext.autocompl').attach()
        end,
        desc = 'Enable autocompletion in REPL windows',
    })
    vim.api.nvim_create_autocmd('FileType', {
        group = id.dap,
        pattern = require('r.utils.tables').debugfiles,
        callback = function(args)
            if not package.loaded.dap then
                require('r.utils').lazy_on_key('n', '<leader>d', 'Debuging', require, 'r.plugins.debug.mappings')
                vim.api.nvim_del_autocmd(args.id)
            end
        end,
    })
    require('r.utils').register_au_id(id)
end

function Debugger.setup()
    local dap = require 'dap'
    signs()

    require('dap.ext.vscode').load_launchjs 'launch.json'

    Debugger.frames = makeSidebar('frames', 70)
    Debugger.scopes = makeSidebar('scopes', 60)
    Debugger.exp = makeSidebar('expression', 40)
    Debugger.threads = makeSidebar('threads', 40)

    Debugger.fframes = makeFloat 'frames'
    Debugger.fscopes = makeFloat 'scopes'
    Debugger.fexp = makeFloat 'expression'
    Debugger.fthreads = makeFloat 'threads'

    dap.defaults.fallback.terminal_win_cmd = 'tabnew'
    dap.defaults.fallback.external_terminal = {
        command = '/usr/bin/st',
        args = { '-e' },
    }

    dap.adapters = require 'r.plugins.debug.adapters'
    dap.configurations = require 'r.plugins.debug.configurations'

    dap.listeners.after.event_initialized['dapui_config'] = function()
        require('dapui').open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
        require('dapui').close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
        require('dapui').close()
    end
end

return Debugger
