local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opts = { clear = true }
local id = {}

local function ignore_files()
    return vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype)
end

local function ignore_win()
    return ignore_files() or vim.fn.win_gettype() == 'popup'
end

------------------------------------------------------------------------
--                              Formatting and UI                     --
------------------------------------------------------------------------

id.FormatOptions = augroup('FormatOptions', opts)
-- ************** Format options  --------------------------------------
aucmd('FileType', {
    group = id.FormatOptions,
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            - 'a' -- Dont format pasted code
            - 'o' -- O and o don't continue comments
            - 'r' -- Return does not continue comments
            + 't' -- Autowrap respecting textwidth
            + 'c' -- comments respect textwidth
            + 'q' -- Allow formatting comments w/ gq
            + 'n' -- Recognize numbered lists
            + 'j' -- Auto-remove comments if possible.
            + '2' -- Indent according to 2nd line
    end,
    desc = 'Custom formatoptions',
})

-- ************** Decoration defaults  ---------------------------------
aucmd('FileType', {
    group = id.FormatOptions,
    callback = function(args)
        if vim.tbl_contains(require('r.utils.tables').ignoreFiles, args.match) or args.file:find 'noice' then
            vim.o.relativenumber = false
            vim.wo.foldcolumn = '0'
            return
        end
        if vim.bo.buftype == '' then
            vim.o.relativenumber = true
            vim.wo[vim.fn.bufwinid(args.buf)].cursorline = true
        end
    end,
    desc = 'Disable all custom decoration rules for non-language filetypes',
})

-- ************** Selective numbering  ---------------------------------
aucmd({ 'InsertEnter', 'WinLeave', 'FocusLost', 'BufNewFile' }, {
    group = id.FormatOptions,
    callback = function(args)
        if not ignore_win() then
            vim.wo[vim.fn.bufwinid(args.buf)].relativenumber = false
        end
    end,
    desc = 'Dont use relativenumber where it makes no sense',
})
aucmd({ 'InsertLeave', 'WinEnter', 'FocusGained' }, {
    group = id.FormatOptions,
    callback = function(args)
        if not ignore_win() then
            vim.wo[vim.fn.bufwinid(args.buf)].relativenumber = true
        end
    end,
    desc = 'use relativenumber conditionally',
})

-- ************** Selective cursorline  ----------------------------------
aucmd({ 'FocusGained', 'WinEnter', 'BufEnter' }, {
    group = id.FormatOptions,
    callback = function(args)
        if not ignore_win() then
            vim.wo[vim.fn.bufwinid(args.buf)].cursorline = true
            vim.wo[vim.fn.bufwinid(args.buf)].foldcolumn = 'auto'
        end
    end,
    desc = 'use cursorline only on active buffers',
})
aucmd({ 'FocusLost', 'WinLeave' }, {
    group = id.FormatOptions,
    callback = function(args)
        if not ignore_win() then
            vim.wo[vim.fn.bufwinid(args.buf)].cursorline = false
            vim.wo[vim.fn.bufwinid(args.buf)].foldcolumn = '0'
        end
    end,
    desc = 'dont use cursorline on inactive buffers',
})

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
        if args.file:match 'zsh' or args.file:match 'ranger' or args.file:match 'shell' then
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
        if args.file:match 'ranger' then
            vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>', { buffer = true, desc = 'Escape Insert' })

            vim.keymap.set('t', 'q', function()
                vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
            end, { buffer = true, desc = 'Close ranger' })
        elseif vim.bo.filetype ~= 'fzf' then
            vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = true, desc = 'Escape Insert' })
        end
    end,
    desc = 'Special insertexit for ranger windows',
})
aucmd('TermClose', {
    group = id.TermOptions,
    callback = function(args)
        if args.file:match 'zsh' or args.file:match 'ranger' or args.file:match 'shell' then
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
        require('r.mappings.util').move()
    end,
    once = true,
    desc = 'Load mappings for unimparied',
})

------------------------------------------------------------------------
--                              Misc                                  --
------------------------------------------------------------------------

id.TextYank = augroup('TextYank', opts)
-- ************** HighlightOnYank ---------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
    group = id.TextYank,
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
    end,
    desc = 'Highlight yanked text',
})

id.NoVim = augroup('NoVim', opts)
-- ************************ Handle binaries ----------------------------
aucmd('BufEnter', {
    pattern = require('r.utils.tables').ignore_binaries_regex,
    group = id.NoVim,
    callback = function()
        local handle
        handle = vim.uv.spawn('xdg-open', { args = { vim.fn.expand '%:p' } }, function()
            handle:close()
        end)
        vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
    end,
    desc = 'Open non text files with MIME',
})

require('r.utils').register_au_id(id)
