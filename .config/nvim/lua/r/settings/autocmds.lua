---@diagnostic disable: missing-parameter
local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local auexec = vim.api.nvim_exec_autocmds
local auclear = vim.api.nvim_clear_autocmds
local opts = { clear = true }

local id = {}

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
        if vim.tbl_contains(require('r.utils.tables').ignoreFiles, args.match) then
            vim.opt.relativenumber = false
            vim.opt_local.cursorline = false
            vim.wo.foldcolumn = '0'
            vim.wo.winbar = nil
            return
        end
        vim.opt.relativenumber = true
        vim.opt_local.cursorline = true
    end,
    desc = 'Disable all custom decoration rules for non-language filetypes',
})

-- ************** Selective numbering  ---------------------------------
aucmd({ 'InsertEnter', 'WinLeave', 'FocusLost', 'BufNewFile' }, {
    group = id.FormatOptions,
    callback = function()
        if
            vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype)
            or vim.fn.win_gettype() == 'popup'
        then
            return
        end
        vim.opt.relativenumber = false
    end,
    desc = 'Dont use relativenumber where it makes no sense',
})
aucmd({ 'InsertLeave', 'WinEnter', 'FocusGained' }, {
    group = id.FormatOptions,
    callback = function()
        if
            vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype)
            or vim.api.nvim_win_get_height(vim.api.nvim_get_current_win()) <= 15
            or vim.fn.win_gettype() == 'popup'
        then
            return
        end
        vim.opt.relativenumber = true
    end,
    desc = 'use relativenumber conditionally',
})

-- ************** Selective cursorline  ----------------------------------
aucmd({ 'FocusGained', 'WinEnter', 'BufEnter' }, {
    group = id.FormatOptions,
    callback = function()
        if
            vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype)
            or vim.api.nvim_win_get_height(vim.api.nvim_get_current_win()) <= 15
            or vim.fn.win_gettype() == 'popup'
        then
            return
        end
        vim.opt_local.cursorline = true
        vim.wo.foldcolumn = 'auto'
    end,
    desc = 'use cursorline only on active buffers',
})
aucmd({ 'FocusLost', 'WinLeave' }, {
    group = id.FormatOptions,
    callback = function()
        if
            vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo.filetype)
            or vim.fn.win_gettype() == 'popup'
        then
            return
        end
        vim.opt_local.cursorline = false
        vim.wo.foldcolumn = '0'
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
        if args.match == '' or args.file == '' then
            return
        end
        require 'r.settings.winbar'(vim.api.nvim_get_current_win())
    end,
    desc = 'Winbar on tabpages with more than one window',
})

-- ************** Tabline ----------------------------------------------
aucmd({ 'TabNewEntered', 'TabEnter' }, {
    group = id.Decorations,
    callback = function()
        vim.opt.tabline = require 'r.settings.tabline'()
    end,
    desc = 'Dynamically set tablines',
})
aucmd({ 'WinEnter', 'BufEnter' }, {
    group = id.Decorations,
    callback = function(args)
        if args.match == '' or args.file == '' then
            return
        end
        local tabline = vim.opt.tabline:get()
        if not tabline or tabline == '' then
            return
        end
        vim.opt.tabline = require 'r.settings.tabline'()
    end,
    desc = 'Update Tabline on WinChange or BufChange',
})

id.Statusline = augroup('Statusline', opts)
aucmd('BufEnter', {
    group = id.Statusline,
    callback = function(args)
        if args.match == '' or args.file == '' then
            return
        end
        auexec('User', { pattern = 'ScStatus' })
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
        require('r.lsp').settings()
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
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require('r.lsp').attach(client, bufnr)
    end,
    desc = 'Call attach function on event LspAttach',
})
aucmd('LspDetach', {
    group = id.LspSettings,
    callback = function(args)
        vim.notify(string.format('Client with id %d detached', args.data.client_id))
        auclear { group = vim.g.au_id['LspAutoFormat_' .. args.data.client_id], buffer = args.buf }
        auclear { group = vim.g.au_id['lsp_signature_help_' .. args.data.client_id .. '_' .. args.buf] }
        auclear { group = vim.g.au_id['lsp_signature_snip_' .. args.data.client_id .. '_' .. args.buf] }
        auclear {
            group = vim.g.au_id['LspHighlightSymbols_' .. args.data.client_id],
            buffer = args.buf,
        }
    end,
    desc = 'Clear AUGroups when LSP detaches',
})

-- ************** Compilers and REPL  ----------------------------------
id.Compiler = augroup('Compiler', opts)
aucmd('FileType', {
    group = id.Compiler,
    pattern = { 'java', 'lua', 'python', 'javascript', 'perl' },
    nested = true,
    callback = function()
        vim.keymap.set('n', '<F5>', function()
            require('overseer').run_template { name = 'Run Single' }
        end, { buffer = true, desc = 'Call native compile command' })

        vim.keymap.set({ 'n', 't' }, '<F10>', function()
            vim.cmd.stopinsert()
            require('r.utils.extensions').toggleTerm(vim.b.repl, 'repl')
        end, { desc = 'Toggle REPL' })
    end,
    desc = 'set compiler and toggleable REPL for capable filetypes',
})

------------------------------------------------------------------------
--                              Plugin loading                        --
------------------------------------------------------------------------
id.PluginLoad = augroup('PluginLoad', opts)
-- ************** Packer compile ---------------------------------------
aucmd('BufWritePost', {
    group = id.PluginLoad,
    pattern = 'plugins.lua',
    callback = function()
        vim.cmd.source '<afile>'
        require('packer').compile()
    end,
    desc = 'Autocompile packer',
})
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
-- ************** Load matchit  ----------------------------------------
aucmd('BufReadPost', {
    group = id.PluginLoad,
    callback = function()
        vim.cmd.packadd 'matchit'
    end,
    once = true,
    desc = 'Conditionally load matchit',
})
-- ************** Load decoration plugins ------------------------------
aucmd('FileType', {
    group = id.PluginLoad,
    callback = function()
        if
            not require('nvim-treesitter.parsers').has_parser()
            or (package.loaded.ufo and package.loaded.indent_blankline)
        then
            return
        end
        require('packer').loader('nvim-ufo', 'indent-blankline.nvim')
    end,
    desc = 'Load nvim-ufo and indent_blankline on relevant filetypes',
})
-- ************** Load harpoon maps ------------------------------------
vim.api.nvim_create_autocmd('FileType', {
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
    desc = 'Start terminals in insert mode',
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
    desc = 'Especial insertexit for ranger windows',
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
aucmd('CmdlineEnter', {
    pattern = [[/,\?]],
    group = id.TermOptions,
    callback = function()
        vim.o.hlsearch = true
    end,
    desc = 'Use hlsearch when searching',
})
aucmd('CmdlineLeave', {
    pattern = [[/,\?]],
    group = id.TermOptions,
    callback = function()
        vim.o.hlsearch = false
    end,
    desc = 'Disable hlsearch on search exit',
})

------------------------------------------------------------------------
--                              Misc                                  --
------------------------------------------------------------------------
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
            require('r.utils.extensions').ranger(args.file, 'e ')
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
        --TODO
        vim.cmd 'let &ft = &ft'
    end,
    desc = 'Open non text files with MIME',
})

require('r.utils').register_au_id(id)
