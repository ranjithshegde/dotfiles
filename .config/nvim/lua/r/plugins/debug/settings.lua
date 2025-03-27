local function makeSidebar(element, width)
    local widgets = require 'dap.ui.widgets'
    return widgets.sidebar(widgets[element], { width = width })
end

local function makeFloat(element)
    local widgets = require 'dap.ui.widgets'
    return function()
        widgets.cursor_float(widgets[element], { border = 'double' })
    end
end

local function signs()
    vim.fn.sign_define('DapBreakpoint', { text = '🟥' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '🟦' })
    vim.fn.sign_define('DapStopped', { text = '⭐️' })
end

local Debugger = {}

function Debugger.init()
    local id = { dap = vim.api.nvim_create_augroup('dap', { clear = true }) }
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
        pattern = 'dap-float',
        callback = function(args)
            vim.keymap.set('n', 'q', function()
                vim.api.nvim_win_close(vim.fn.bufwinid(args.buf), true)
            end, { desc = 'Close dap view', buffer = args.buf })
        end,
        desc = 'Close DAP Floating window',
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

    require('dap.ext.vscode').getconfigs()

    Debugger.exp = makeSidebar('expression', 40)
    Debugger.frames = makeSidebar('frames', 70)
    Debugger.scopes = makeSidebar('scopes', 60)
    Debugger.threads = makeSidebar('threads', 40)

    Debugger.fexp = makeFloat 'expression'
    Debugger.fframes = makeFloat 'frames'
    Debugger.fscopes = makeFloat 'scopes'
    Debugger.fthreads = makeFloat 'threads'

    dap.defaults.fallback.external_terminal = {
        command = '/usr/bin/ghostty',
        args = { '-e' },
    }

    dap.adapters = require 'r.plugins.debug.adapters'
    dap.configurations = require 'r.plugins.debug.configurations'

    local dv = require 'dap-view'
    dap.listeners.before.attach['dap-view-config'] = function()
        dv.open()
    end
    dap.listeners.before.launch['dap-view-config'] = function()
        dv.open()
    end

    dap.listeners.after.event_initialized['dap-view-config'] = function(session)
        session.on_close['dap-view-config'] = function()
            dv.close()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname:find '%[dap%-terminal%]' then
                    local winnr = vim.fn.bufwinid(buf)
                    vim.api.nvim_win_close(winnr, true)
                end
            end
        end
    end
end

return Debugger
