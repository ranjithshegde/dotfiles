local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auexec = vim.api.nvim_exec_autocmds
local auclear = vim.api.nvim_clear_autocmds
local opts = { clear = true }

local id = {}

local function ignore_files()
    return vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype) or vim.fn.win_gettype() == 'popup'
end

local function ignore_win()
    return ignore_files() or vim.fn.win_gettype() == 'popup'
end

local function ignore_empty(args)
    return args.match == '' or args.file == ''
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
            vim.wo.winbar = nil
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
        if not ignore_files() then
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
        if not ignore_files() then
            vim.wo[vim.fn.bufwinid(args.buf)].cursorline = false
            vim.wo[vim.fn.bufwinid(args.buf)].foldcolumn = '0'
        end
    end,
    desc = 'dont use cursorline on inactive buffers',
})

------------------------------------------------------------------------
--                  Statusline Winbar Tabline                         --
------------------------------------------------------------------------
id.Decorations = augroup('Decorations', opts)

-- ************** Winbar -----------------------------------------------
aucmd({ 'BufEnter', 'WinEnter' }, {
    group = id.Decorations,
    callback = function(args)
        if not ignore_empty(args) then
            require 'r.settings.winbar'(vim.api.nvim_get_current_win())
        end
    end,
    desc = 'Set Winbar on BufEnter',
})

-- ************** Tabline ----------------------------------------------
aucmd({ 'TabNewEntered', 'TabEnter' }, {
    group = id.Decorations,
    callback = function()
        vim.o.tabline = require 'r.settings.tabline'()
    end,
    desc = 'Dynamically set tablines',
})
aucmd({ 'WinEnter', 'BufEnter' }, {
    group = id.Decorations,
    callback = function(args)
        if ignore_empty(args) then
            return
        end
        local tabline = vim.o.tabline
        if not tabline or tabline == '' then
            return
        end
        vim.o.tabline = require 'r.settings.tabline'()
    end,
    desc = 'Update Tabline on WinChange or BufChange',
})

id.Statusline = augroup('Statusline', opts)
aucmd('BufEnter', {
    group = id.Statusline,
    callback = function(args)
        if not ignore_empty(args) then
            auexec('User', { pattern = 'ScStatus' })
        end
    end,
    desc = 'Load ScStatus only for supercollider',
})

------------------------------------------------------------------------
--                              LSP                                   --
------------------------------------------------------------------------

id.LspSettings = augroup('LspSettings', opts)
-- ************** Lsp Configuration loading  ----------------------------
aucmd('FileType', {
    group = id.LspSettings,
    pattern = require('r.utils.tables').lspfiles,
    callback = function()
        require('r.lsp').servers()
        require('r.lsp').lintFormat()
        auexec('FileType', { group = 'lspconfig' })
    end,
    once = true,
    desc = 'Initialize lsp settings, AuGroups and server configurations',
})
aucmd('FileType', {
    group = id.LspSettings,
    pattern = 'opencl',
    callback = function()
        require('r.mappings.clang').clang()
    end,
    desc = 'OpenCL filetype to handle C++ lsp',
})

-- ************** Lsp attach --------------------------------------------
aucmd('LspAttach', {
    group = id.LspSettings,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require('r.lsp').attach(client, args.buf)
    end,
    desc = 'Call attach function on event LspAttach',
})
aucmd('LspDetach', {
    group = id.LspSettings,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        vim.notify(string.format('Server %s detached from %d', client.name, args.buf))
        auclear { group = vim.g.au_id['LspAutoFormat_' .. client.name .. '_' .. args.buf], buffer = args.buf }
        auclear { group = vim.g.au_id['LspHighlightSymbols_' .. client.name .. '_' .. args.buf], buffer = args.buf }
    end,
    desc = 'Clear AUGroups when LSP detaches',
})

-- ************** Diagnostics ------------------------------------------
id.DiagnosticList = augroup('DiagnosticList', opts)
aucmd('DiagnosticChanged', {
    group = id.DiagnosticList,
    callback = function()
        pcall(vim.diagnostic.setloclist, { open = false })
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

-- ************************ Terminal autoecape --------------------------
aucmd('TermEnter', {
    group = id.TermOptions,
    callback = function(args)
        if args.file:match 'ranger' then
            vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>', { buffer = true, desc = 'Escape Insert' })
        else
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
        require 'r.mappings.pairs'
        require 'r.mappings.treesitter'()
    end,
    once = true,
    desc = 'Load mappings for unimparied and treesiiter after reading buffer',
})
-- -- ************** Load matchit  ----------------------------------------
--  aucmd('BufReadPost', {
--      group = id.PluginLoad,
--      callback = function()
--          vim.cmd.packadd 'matchit'
--      end,
--      once = true,
--      desc = 'Conditionally load matchit',
--  })
-- -- ************** Load decoration plugins ------------------------------
aucmd('FileType', {
    group = id.PluginLoad,
    callback = function(args)
        if
            vim.tbl_contains(require('r.utils.tables').ignoreFiles, args.match)
            or not require('nvim-treesitter.parsers').has_parser()
            or (package.loaded.ufo and package.loaded.indent_blankline)
        then
            return
        end
        require('lazy').load 'nvim-ufo'
        require('lazy').load 'indent-blankline.nvim'
    end,
    desc = 'Load nvim-ufo and indent_blankline on relevant filetypes',
})
-- ************** Load harpoon maps ------------------------------------
aucmd('FileType', {
    pattern = 'harpoon',
    group = id.PluginLoad,
    callback = function()
        vim.keymap.set('n', '<C-v>', function()
            local curline = vim.api.nvim_get_current_line()
            local working_directory = vim.fn.getcwd() .. '/'
            vim.cmd 'vs'
            vim.cmd('e ' .. working_directory .. curline)
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<C-t>', function()
            local curline = vim.api.nvim_get_current_line()
            local working_directory = vim.fn.getcwd() .. '/'
            vim.cmd 'tabnew'
            vim.cmd('e ' .. working_directory .. curline)
        end, { noremap = true, silent = true })
    end,
    desc = 'Make harpoon open in splits',
})
-- ************** Load autocompletion
aucmd('InsertEnter', {
    group = id.PluginLoad,
    callback = function(args)
        if not ignore_files() then
            vim.api.nvim_input '<Esc>'
            -- require('r.plugins.completion').init()
            require('lazy').load 'nvim-cmp'
            vim.api.nvim_del_autocmd(args.id)
            vim.api.nvim_input 'i'
        end
    end,
    desc = 'Initialize completion framework only when entering relevant buffers',
})

------------------------------------------------------------------------
--                              Misc                                  --
------------------------------------------------------------------------

-- ************** Compilers and REPL  ----------------------------------
id.Overseer = augroup('Overseer', opts)
aucmd('FileType', {
    group = id.Overseer,
    pattern = { 'java', 'lua', 'python', 'javascript', 'perl' },
    nested = true,
    callback = function()
        vim.keymap.set('n', '<F5>', function()
            require('overseer').run_template { name = 'Run Single' }
        end, { buffer = true, desc = 'Call native compile command' })

        vim.keymap.set({ 'n', 't' }, '<F10>', function()
            vim.cmd.stopinsert()
            require('r.extensions').toggleTerm(vim.b.repl, 'repl')
        end, { desc = 'Toggle REPL' })
    end,
    desc = 'set compiler and toggleable REPL for capable filetypes',
})

id.ProjectDrawer = augroup('ProjectDrawer', opts)
-- ************************ Handle netrw -------------------------------
aucmd('BufEnter', {
    group = id.ProjectDrawer,
    callback = function(args)
        local fs = vim.loop.fs_stat(args.file)
        if not fs then
            return
        end
        if fs.type == 'directory' then
            if package.loaded.telescope and package.loaded.telescope.extensions.file_browser then
                return
            end
            vim.cmd.bd()
            require('r.extensions').ranger(args.file, 'e ')
        end
    end,
    desc = 'Hijack netrw with ranger or telescope',
})

id.NoVim = augroup('NoVim', opts)
-- ************************ Handle binaries ----------------------------
aucmd('BufEnter', {
    pattern = require('r.utils.tables').ignore_binaries_regex,
    group = id.NoVim,
    callback = function()
        local handle
        handle = vim.loop.spawn('xdg-open', { args = { vim.fn.expand '%:p' } }, function()
            handle:close()
        end)
        vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
    end,
    desc = 'Open non text files with MIME',
})

require('r.utils').register_au_id(id)
