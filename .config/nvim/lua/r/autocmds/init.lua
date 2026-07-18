local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opts = { clear = true }
local id = {}

local window = vim.wo
local option = vim.o

local function is_ignored_filetype()
    return vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype)
end

local function should_ignore_window()
    return is_ignored_filetype() or vim.fn.win_gettype() == 'popup'
end

local function set_window_options(bufnr, options)
    local winid = vim.fn.bufwinid(bufnr)
    for key, value in pairs(options) do
        window[winid][key] = value
    end
end

------------------------------------------------------------------------
--                             Treesitter                             --
------------------------------------------------------------------------

id.treesitter = augroup('treesitter', opts)
aucmd('FileType', {
    group = id.treesitter,
    callback = function(args)
        if is_ignored_filetype() or should_ignore_window() then
            return
        end
        if args.match == 'tex' then
            vim.treesitter.language.register('latex', 'tex')
            pcall(vim.treesitter.start, args.buf, 'latex')
            vim.bo[args.buf].syntax = 'on'
        else
            pcall(vim.treesitter.start, args.buf)
        end
    end,
    desc = 'Start treesitter syntax highlighting',
})

aucmd('VimEnter', {
    group = id.treesitter,
    callback = function()
        vim.treesitter.language.register('c', 'opencl')
        vim.treesitter.language.register('bash', 'zsh')
    end,
    desc = 'Register extra TS parsers',
})

------------------------------------------------------------------------
--                              Formatting and UI                     --
------------------------------------------------------------------------

id.FormatOptions = augroup('FormatOptions', opts)
-- ************** Format options  --------------------------------------
aucmd('FileType', {
    group = id.FormatOptions,
    callback = function()
        --- - 'o' -- O and o don't continue comments
        --- - 'r' -- Return does not continue comments
        --- + 't' -- Autowrap respecting textwidth
        --- + 'c' -- comments respect textwidth
        --- + 'q' -- Allow formatting comments w/ gq
        --- + 'n' -- Recognize numbered lists
        --- + 'j' -- Auto-remove comments if possible.
        --- + '2' -- Indent according to 2nd line
        vim.o.formatoptions = 'tcqnj2'
    end,
    desc = 'Custom formatoptions',
})

-- ************** Decoration defaults  ---------------------------------
aucmd('FileType', {
    group = id.FormatOptions,
    callback = function(args)
        if is_ignored_filetype() or args.file:find 'noice' then
            option.relativenumber = false
            return
        end

        if vim.bo.buftype == '' then
            option.relativenumber = true
            set_window_options(args.buf, { cursorline = true })
        end
    end,
    desc = 'Set decoration rules based on filetype',
})

-- ************** Selective numbering  ---------------------------------
local number_events = {
    disable = { 'InsertEnter', 'WinLeave', 'FocusLost', 'BufNewFile' },
    enable = { 'InsertLeave', 'WinEnter', 'FocusGained' },
}

for state, events in pairs(number_events) do
    aucmd(events, {
        group = id.FormatOptions,
        callback = function(args)
            if not should_ignore_window() then
                set_window_options(args.buf, {
                    relativenumber = state == 'enable',
                })
            end
        end,
        desc = string.format('%s relative numbers conditionally', state),
    })
end

-- ************** Selective cursorline  ----------------------------------
local cursorline_events = {
    enable = { 'FocusGained', 'WinEnter', 'BufEnter' },
    disable = { 'FocusLost', 'WinLeave' },
}

for state, events in pairs(cursorline_events) do
    aucmd(events, {
        group = id.FormatOptions,
        callback = function(args)
            if not should_ignore_window() then
                set_window_options(args.buf, {
                    cursorline = state == 'enable',
                })
            end
        end,
        desc = string.format('%s cursorline for %s buffers', state, state == 'enable' and 'active' or 'inactive'),
    })
end

------------------------------------------------------------------------
--                              LSP                                   --
------------------------------------------------------------------------

-- ************** Diagnostics ------------------------------------------
id.DiagnosticList = augroup('DiagnosticList', opts)
aucmd('DiagnosticChanged', {
    group = id.DiagnosticList,
    callback = function()
        vim.diagnostic.setloclist { open = false }
    end,
    desc = 'Send diagnostics to loclist on new errors',
})

------------------------------------------------------------------------
--                              Terminal management                   --
------------------------------------------------------------------------

id.TermOptions = augroup('TermOptions', opts)
-- ************************ Terminal autinsert--------------------------
aucmd({ 'BufEnter', 'BufWinEnter', 'TermOpen' }, {
    group = id.TermOptions,
    pattern = { 'term://*', 'shell' },
    callback = function(args)
        if args.file:match 'zsh' or args.file:match 'yazi' or args.file:match 'shell' then
            vim.cmd.startinsert()
        end
    end,
    desc = 'Start relevant terminals in insert mode',
})
aucmd('TermEnter', { group = id.TermOptions, command = 'startinsert', desc = 'Start terminals in insert mode' })

-- ************************ Terminal autoescape --------------------------
aucmd('TermEnter', {
    group = id.TermOptions,
    callback = function(args)
        if args.file:match 'yazi' then
            vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>', { buffer = true, desc = 'Escape Insert' })

            vim.keymap.set('t', 'q', function()
                local job_id = vim.b.yazi_id
                if job_id then
                    local win = vim.api.nvim_get_current_win()
                    vim.fn.jobstop(job_id)
                    local winid = vim.fn.win_getid(win)
                    vim.api.nvim_buf_delete(vim.fn.winbufnr(winid), { force = true })
                end
            end, { buffer = true, desc = 'Close Yazi' })
        elseif vim.bo.filetype ~= 'fzf' then
            vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = true, desc = 'Escape Insert' })
        end
    end,
    desc = 'Special insertexit for Yazi windows',
})
aucmd('TermClose', {
    group = id.TermOptions,
    callback = function(args)
        if args.file:match 'zsh' or args.file:match 'yazi' or args.file:match 'shell' then
            if vim.fn.mode() == 't' then
                vim.api.nvim_input '<CR>'
            end
        end
    end,
    desc = 'Remove the annoying [exited] termexit prompt',
})

------------------------------------------------------------------------
--                              Plugin loading                        --
------------------------------------------------------------------------
id.PluginLoad = augroup('PluginLoad', opts)
-- ************** Load mappings  ---------------------------------------
aucmd('BufReadPost', {
    group = id.PluginLoad,
    callback = function()
        require('r.extensions.mappings').move()
    end,
    once = true,
    desc = 'Load mappings for unimparied',
})

------------------------------------------------------------------------
--                              Misc                                  --
------------------------------------------------------------------------

id.TextYank = augroup('TextYank', opts)
-- ************** HighlightOnYank ---------------------------------------------------------
vim.api.nvim_create_autocmd({ 'TextYankPost', 'TextPutPost' }, {
    group = id.TextYank,
    callback = function()
        vim.hl.hl_op { higroup = 'IncSearch', timeout = 200 }
    end,
    desc = 'Highlight yanked text',
})

id.NoVim = augroup('NoVim', opts)
-- ************************ Handle binaries ----------------------------
aucmd('BufEnter', {
    pattern = require('r.utils.tables').ignore_binaries_regex,
    group = id.NoVim,
    callback = function()
        vim.system { 'xdg-open', vim.fn.expand '%:p' }
        vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
    end,
    desc = 'Open non text files with MIME',
})

id.NoRTP = augroup('NoRTP', opts)

aucmd('VimEnter', {
    group = id.NoRTP,
    callback = function()
        for _, name in ipairs(require('r.utils.tables').rtp) do
            if name == 'tohtml' then
                name = '2html_plugin'
            end
            vim.g['loaded_' .. name] = 1
        end
    end,
    desc = 'Disable defualt runtimepath plugins',
})

require 'r.autocmds.filetype'(id)

require('r.utils').register_au_id(id)
