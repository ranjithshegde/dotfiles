local statusline = {
    'ranjithshegde/express_line.nvim',
    dev = true,
    event = 'UIEnter',
    branch = '0.7',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
}

local space = ' '

------------------------------------------------------------------------
--                              statusline                            --
------------------------------------------------------------------------

function statusline.init()
    local id = {}

    id.StatusLineSetup = vim.api.nvim_create_augroup('StatusLineSetup', { clear = true })
    id.Statusline = vim.api.nvim_create_augroup('Statusline', { clear = true })
    vim.api.nvim_create_autocmd('BufEnter', {
        group = id.Statusline,
        callback = function(args)
            if not args.match ~= '' or args.file ~= '' then
                vim.api.nvim_exec_autocmds('User', { pattern = 'ScStatus' })
            end
        end,
        desc = 'Load ScStatus only for supercollider',
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = id.StatusLineSetup,
        callback = function()
            require('r.utils').switch_highlight('MiniStatuslineModeVisual', 'ScrollSep')
            require('el').reset_windows()
        end,
    })

    require('r.utils').register_au_id(id)
end

statusline.config = function()
    local extensions = require 'el.extensions'
    local sections = require 'el.sections'
    local subscribe = require 'el.subscribe'

    --*********************************** Basics ----------------------------
    local help = subscribe.buf_autocmd('el_help', 'BufRead', function(_, _)
        local value = vim.api.nvim_eval_statusline('%H', {}).str
        if value ~= '' then
            return require('nvim-web-devicons').get_icon 'h'
        end
    end)

    local readonly = subscribe.buf_autocmd('el_read', 'BufRead', function(_, buffer)
        if vim.bo[buffer.bufnr].readonly then
            return require('nvim-web-devicons').get_icon 'lock'
        end
    end)

    local file_name = subscribe.buf_autocmd('el_file_name', 'BufRead,BufWritePost', function(_, buffer)
        return vim.fn.fnamemodify(buffer.name, ':t')
    end)

    --*********************************** Git branch ------------------------
    local git_branch = subscribe.buf_autocmd('el_git_branch', 'BufReadPre', function(window, buffer)
        local ft = vim.bo[buffer.bufnr].filetype
        if ft == 'TelescopePrompt' then
            return
        end
        local branch = extensions.git_branch(window, buffer)
        if branch then
            return space .. extensions.git_icon() .. space .. branch
        end
    end)

    local diagnostics = require('el.diagnostic').make_buffer(require('r.extensions.diagnostics.format').formatter)

    --*********************************** Status config ---------------------
    local components = require 'r.plugins.statusline.components'
    require('el').reset_windows()
    require('r.extensions.diagnostics.format').sethl(
        'DiagnosticError',
        'DiagnosticWarn',
        'DiagnosticHint',
        'DiagnosticInfo'
    )

    require('el').setup {
        generator = function(_, _)
            return {
                --*********************************** Vim Mode --------------------------
                subscribe.buf_autocmd('el_mode', 'ModeChanged', components.mode),

                --*********************************** Git --------------------------------
                sections.highlight('DiagnosticWarn', git_branch),
                components.git_changes,
                sections.split,

                --*********************************** Lsp status  -----------------------
                diagnostics,
                sections.collapse_builtin {
                    subscribe.user_autocmd('el_scnvim', 'ScStatus', components.sc_status),
                    space,
                    subscribe.buf_autocmd('el_gps', 'CursorMoved,CursorMovedI,BufEnter', components.gps),
                },
                sections.split,

                --*********************************** File status -----------------------
                sections.collapse_builtin {
                    sections.highlight('DevIconHtml', readonly),
                    space,
                    sections.highlight('DevIconMarkdown', help),
                    space,
                    sections.highlight(
                        'FileIcon',
                        subscribe.buf_autocmd('el_file_icon', 'BufRead,BufWritePost', components.file_icon)
                    ),
                    sections.highlight('StatusLine', file_name),
                    space,
                    subscribe.buf_autocmd('el_mod', 'BufModifiedSet', components.modified),
                    space,
                },
                space,

                --*********************************** Cursor position -------------------
                subscribe.buf_autocmd('el_cursor', 'CursorMoved,CursorMovedI', components.cursor),
                space,

                --*********************************** Scroll ------------------------------
                sections.highlight(
                    'DiagnosticWarn',
                    subscribe.buf_autocmd('el_scroll', 'CursorMoved,CursorMovedI', components.scroll)
                ),
                space,
            }
        end,
    }
end

return statusline
