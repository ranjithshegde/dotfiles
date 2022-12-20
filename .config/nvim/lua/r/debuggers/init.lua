local auid = {}

local function makeSidebar(element, width)
    local widgets = require 'dap.ui.widgets'
    return widgets.sidebar(widgets[element], { width = width })
end

local function signs()
    vim.fn.sign_define('DapBreakpoint', { text = '🟥' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '🟦' })
    vim.fn.sign_define('DapStopped', { text = '⭐️' })
end

local Debugger = {}

function Debugger.init()
    signs()

    require('dapui').setup {
        layouts = {
            {
                elements = { 'scopes', 'breakpoints', 'stacks', 'watches' },
                size = 70,
                position = 'left',
            },
            {
                elements = { 'repl', 'console' },
                size = 0.25,
                position = 'bottom',
            },
        },
    }

    require('r.mappings.lsp').debug()
    require('dap.ext.vscode').load_launchjs 'launch.json'
    vim.notify 'Loaded nvim-dap. Bound keymaps'
end

function Debugger.setup()
    local dap = require 'dap'

    Debugger.frames = makeSidebar('frames', 70)
    Debugger.scopes = makeSidebar('scopes', 60)
    Debugger.exp = makeSidebar('expression', 40)
    Debugger.threads = makeSidebar('threads', 40)

    dap.defaults.fallback.terminal_win_cmd = 'tabnew'
    dap.defaults.fallback.external_terminal = {
        command = '/usr/bin/st',
        args = { '-e' },
    }

    dap.adapters = require 'r.debuggers.adapters'
    dap.configurations = require 'r.debuggers.configs'

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

function Debugger.fscopes()
    local widgets = require 'dap.ui.widgets'
    widgets.centered_float(widgets.scopes, { border = 'double' })
end

function Debugger.fthreads()
    local widgets = require 'dap.ui.widgets'
    widgets.centered_float(widgets.threads, { border = 'double' })
end

function Debugger.fframes()
    local widgets = require 'dap.ui.widgets'
    widgets.centered_float(widgets.frames, { border = 'double' })
end

function Debugger.fexp()
    local widgets = require 'dap.ui.widgets'
    widgets.centered_float(widgets.expression, { border = 'double' })
end

return Debugger
