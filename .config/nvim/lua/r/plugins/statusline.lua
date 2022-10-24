-- Blank Between Components
local space = ' '
local left_separator = ''
local right_separator = ''

------------------------------------------------------------------------
--                              statusline                            --
------------------------------------------------------------------------

local extensions = require 'el.extensions'
local sections = require 'el.sections'
local subscribe = require 'el.subscribe'
local id = {}
id.StatusLineSetup = vim.api.nvim_create_augroup('StatusLineSetup', { clear = true })

local function reverse_hls(hl1, hl2)
    local cursor_hl = vim.api.nvim_get_hl_by_name(hl1, true)
    vim.api.nvim_set_hl(0, hl2, { fg = cursor_hl.background, bg = cursor_hl.foreground })
end

--*********************************** Basics ----------------------------
local modified = subscribe.buf_autocmd('el_mod', 'BufModifiedSet', function(_, _)
    local status = vim.api.nvim_eval_statusline('%m', {}).str
    if status:find '-' then
        return ''
    elseif status:find '+' then
        return ''
    end
end)

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

--*********************************** File Icon -------------------------
local file_icon = subscribe.buf_autocmd('el_file_icon', 'BufRead,BufWritePost', function(_, buffer)
    local icon, color = require('nvim-web-devicons').get_icon_color(buffer.name, buffer.extension)
    if icon then
        local table = vim.api.nvim_get_hl_by_name('StatusLine', true)
        vim.api.nvim_set_hl(0, 'FileIcon', { bg = table['background'], fg = color, cterm = { bold = true } })
        return icon .. space
    end
    return ''
end)

local file_name = subscribe.buf_autocmd('el_file_name', 'BufRead,BufWritePost', function(_, buffer)
    return vim.fn.fnamemodify(buffer.name, ':t')
end)

--*********************************** Vim Mode --------------------------

local map = {
    ['n'] = 'NORMAL',
    ['no'] = 'O-PENDING',
    ['nov'] = 'O-PENDING',
    ['noV'] = 'O-PENDING',
    ['no\22'] = 'O-PENDING',
    ['niI'] = 'NORMAL',
    ['niR'] = 'NORMAL',
    ['niV'] = 'NORMAL',
    ['nt'] = 'NORMAL',
    ['ntT'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['vs'] = 'VISUAL',
    ['V'] = 'V-LINE',
    ['Vs'] = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    ['\22s'] = 'V-BLOCK',
    ['s'] = 'SELECT',
    ['S'] = 'S-LINE',
    ['\19'] = 'S-BLOCK',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['ix'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rc'] = 'REPLACE',
    ['Rx'] = 'REPLACE',
    ['Rv'] = 'V-REPLACE',
    ['Rvc'] = 'V-REPLACE',
    ['Rvx'] = 'V-REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'EX',
    ['ce'] = 'EX',
    ['r'] = 'REPLACE',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
}

---@return string current mode name
local function get_mode()
    local mode_code = vim.api.nvim_get_mode().mode
    if map[mode_code] == nil then
        return mode_code
    end
    return map[mode_code]
end

local mode_to_highlight = {
    ['VISUAL'] = 'MiniStatuslineModeVisual',
    ['V-BLOCK'] = 'MiniStatuslineModeVisual',
    ['V-LINE'] = 'MiniStatuslineModeVisual',
    ['SELECT'] = 'MiniStatuslineModeVisual',
    ['S-LINE'] = 'MiniStatuslineModeVisual',
    ['S-BLOCK'] = 'MiniStatuslineModeVisual',
    ['REPLACE'] = 'MiniStatuslineModeReplace',
    ['V-REPLACE'] = 'MiniStatuslineModeReplace',
    ['INSERT'] = 'MiniStatuslineModeInsert',
    ['COMMAND'] = 'MiniStatuslineModeCommand',
    ['EX'] = 'MiniStatuslineModeCommand',
    ['MORE'] = 'MiniStatuslineModeCommand',
    ['CONFIRM'] = 'MiniStatuslineModeCommand',
    ['TERMINAL'] = 'MiniStatuslineModeOther',
    ['NORMAL'] = 'MiniStatuslineModeNormal',
}

local mode = subscribe.buf_autocmd('el_mode', 'ModeChanged', function()
    local current_mode = get_mode()
    local current_hl = mode_to_highlight[current_mode]
    if current_hl then
        reverse_hls(current_hl, 'ModeSep')
        current_hl = '%#' .. current_hl .. '# '
        return current_hl .. current_mode .. ' %#ModeSep#' .. right_separator .. ' %##'
    end
end)

--*********************************** Scroll & position -------------------
local scroll = subscribe.buf_autocmd('el_scroll', 'CursorMoved,CursorMovedI', function(_, _)
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.fn.line '$'
    local chars = {
        '_',
        '▁',
        '▂',
        '▃',
        '▄',
        '▅',
        '▆',
        '▇',
        '█',
    }
    local index = 1

    if current_line == 1 then
        index = 1
    elseif current_line == total_lines then
        index = #chars
    else
        local line_no_fraction = vim.fn.floor(current_line) / vim.fn.floor(total_lines)
        index = vim.fn.float2nr(line_no_fraction * #chars)
        if index == 0 then
            index = 1
        end
    end
    return '%3p' .. chars[index]
end)

local cursor = subscribe.buf_autocmd('el_cursor', 'CursorMoved,CursorMovedI', function(_, _)
    local line = '%-l'
    local column = '%-c'
    return '%#ScrollSep#' .. left_separator .. '%#MiniStatuslineModeVisual#' .. line .. ':' .. column .. space .. '%##'
end)

--*********************************** SuperCollider ---------------------
local scnvim = subscribe.user_autocmd('el_scnvim', 'ScStatus', function(_)
    local ft = vim.bo.filetype
    if ft == 'supercollider' then
        local scstatus = require('scnvim.statusline').get_server_status()
        if scstatus ~= '' then
            return '📡 [' .. scstatus .. ']'
        end
    end
    return ''
end)

--*********************************** Git branch ------------------------
local git_branch = subscribe.buf_autocmd('el_git_branch', 'BufReadPre', function(window, buffer)
    local ft = vim.bo[buffer.bufnr].filetype
    if ft == 'TelescopePrompt' then
        return
    end
    local branch = extensions.git_branch(window, buffer)
    if branch then
        require('packer').loader 'gitsigns.nvim'
        return space .. extensions.git_icon() .. space .. branch
    end
end)

--*********************************** Git sign changes ------------------
local function git_changes(_, _)
    local st = vim.b.gitsigns_status
    if not st then
        return ''
    end
    local result = ''
    local add = st:match '+%d*'
    if add then
        add = add:gsub('+', ' ')
        result = result .. '%#GitGutterAdd# ' .. add
    end
    local change = st:match '~%d*'
    if change then
        change = change:gsub('~', ' ')
        result = result .. '%#GitGutterChange# ' .. change
    end
    local cut = st:match '-%d*'
    if cut then
        cut = cut:gsub('-', ' ')
        result = result .. '%#GitGutterDelete# ' .. cut
    end
    return result .. '%##'
end

--*********************************** Lsp status  -----------------------
local diagnostics = require('el.diagnostic').make_buffer(require('r.extensions.diagnostics.format').formatter)

local tsNodes = require('r.utils.tables').tsNodes

local gps = subscribe.buf_autocmd('el_gps', 'CursorMoved,CursorMovedI,BufEnter', function(window, buffer)
    local fs = vim.bo[buffer.bufnr].filetype
    if vim.tbl_contains(require('r.utils.tables').ignoreFiles, fs) then
        return ''
    end

    local max_width = math.ceil(0.35 * vim.api.nvim_win_get_width(window and window.win_id or 0))

    if not vim.b.gps then
        vim.b.gps = 35
    end

    if vim.b.gps > max_width then
        vim.b.gps = max_width
    end

    local context = require('r.plugins.treesitter').statusline {
        indicator_size = vim.b.gps,
        type_patterns = tsNodes.filetype[fs] or tsNodes.default,
        bufnr = buffer.bufnr,
    }
    if not context or context == '' then
        return ''
    end
    context = '🇻  ' .. context
    return context
end)

--*********************************** Status config ---------------------
return function()
    require('el').reset_windows()
    require('r.extensions.diagnostics.format').sethl(
        'DiagnosticError',
        'DiagnosticWarn',
        'DiagnosticHint',
        'DiagnosticInfo'
    )

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = id.StatusLineSetup,
        callback = function()
            reverse_hls('MiniStatuslineModeVisual', 'ScrollSep')
            require('el').reset_windows()
        end,
    })
    require('r.utils').register_au_id(id)

    require('el').setup {
        generator = function(_, _)
            return {
                mode,
                sections.highlight('DiagnosticWarn', git_branch),
                git_changes,
                sections.split,
                diagnostics,
                sections.collapse_builtin { scnvim, space, gps },
                sections.split,
                sections.collapse_builtin {
                    sections.highlight('DevIconHtml', readonly),
                    space,
                    sections.highlight('DevIconMarkdown', help),
                    space,
                    sections.highlight('FileIcon', file_icon),
                    sections.highlight('StatusLine', file_name),
                    space,
                    modified,
                    space,
                    cursor,
                },
                space,
                sections.highlight('DiagnosticWarn', scroll),
                space,
            }
        end,
    }
end
