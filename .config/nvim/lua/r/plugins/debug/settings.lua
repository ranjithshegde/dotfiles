local auid = {}

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
    signs()
    require 'r.plugins.debug.mappings'()
    require('dap.ext.vscode').load_launchjs 'launch.json'
    vim.notify 'Loaded nvim-dap. Bound keymaps'
end

function Debugger.setup()
    local dap = require 'dap'

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

    auid.dap_repl = vim.api.nvim_create_augroup('dap_repl', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = auid.dap_repl,
        pattern = 'dap-repl',
        callback = function()
            require('dap.ext.autocompl').attach()
        end,
        desc = 'Enable autocompletion in REPL windows',
    })
    require('r.utils').register_au_id(auid)
end

return Debugger
