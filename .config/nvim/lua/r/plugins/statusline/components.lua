local components = {}

local space = ' '
local left_separator = ''
local right_separator = ''

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

---@return string current mode name
local function get_mode()
    local mode_code = vim.api.nvim_get_mode().mode
    if map[mode_code] == nil then
        return mode_code
    end
    return map[mode_code]
end

------------------------------------------------------------------------
--                              components                            --
------------------------------------------------------------------------

function components.modified(_, buffer)
    if
        buffer.name ~= '' and not vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo[buffer.bufnr].filetype)
    then
        local status = vim.api.nvim_eval_statusline('%m', {}).str
        if status:find '-' then
            return ''
        elseif status:find '+' then
            return ''
        end
    end
end

--*********************************** Vim Mode --------------------------
function components.mode()
    local current_mode = get_mode()
    local current_hl = mode_to_highlight[current_mode]
    if current_hl then
        require('r.utils').switch_highlight(current_hl, 'ModeSep')
        current_hl = '%#' .. current_hl .. '# '
        return current_hl .. current_mode .. ' %#ModeSep#' .. right_separator .. ' %##'
    end
end

--*********************************** Scroll & position -------------------
function components.scroll()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.fn.line '$'
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
end

function components.cursor()
    local line = '%-l'
    local column = '%-c'
    return '%#ScrollSep#' .. left_separator .. '%#MiniStatuslineModeVisual#' .. line .. ':' .. column .. space .. '%##'
end

--*********************************** File Icon -------------------------
function components.file_icon(_, buffer)
    local icon, color = require('nvim-web-devicons').get_icon_color(buffer.name, buffer.extension)
    if icon then
        local table = vim.api.nvim_get_hl_by_name('StatusLine', true)
        vim.api.nvim_set_hl(0, 'FileIcon', { bg = table['background'], fg = color, cterm = { bold = true } })
        return icon .. space
    end
    return ''
end

--*********************************** Git sign changes ------------------
function components.git_changes()
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

--*********************************** SuperCollider ---------------------
function components.sc_status()
    local ft = vim.bo.filetype
    if ft == 'supercollider' then
        local scstatus = require('scnvim.statusline').get_server_status()
        if scstatus ~= '' then
            return '📡 [' .. scstatus .. ']'
        end
    end
    return ''
end

--*********************************** Lsp status  -----------------------
local tsNodes = require('r.utils.tables').tsNodes
function components.gps(window, buffer)
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

    local context = require 'r.utils.context' {
        indicator_size = vim.b.gps,
        type_patterns = tsNodes.filetype[fs] or tsNodes.default,
        bufnr = buffer.bufnr,
    }
    if not context or context == '' then
        return ''
    end
    context = '🇻  ' .. context
    return context
end

return components
