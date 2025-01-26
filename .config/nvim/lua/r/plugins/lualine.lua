local center_sep = '%='

local function sc_status()
    local scstatus = require('scnvim.statusline').get_server_status()
    if scstatus ~= '' then
        scstatus = scstatus:gsub('%%', '%%%%')
        return '📡 [' .. scstatus .. ']'
    end
    return ''
end

local function gps()
    local tsNodes = require('r.utils.tables').tsNodes
    local window = vim.api.nvim_get_current_win()
    local buffer = vim.api.nvim_get_current_buf()
    local fs = vim.bo[buffer].filetype

    local max_width = math.ceil(0.35 * vim.api.nvim_win_get_width(window))

    if not vim.b.gps then
        vim.b.gps = 35
    end

    if vim.b.gps > max_width then
        vim.b.gps = max_width
    end

    local context = require 'r.utils.context' {
        indicator_size = vim.b.gps,
        type_patterns = tsNodes.filetype[fs] or tsNodes.default,
        bufnr = buffer,
    }

    if not context or context == '' then
        return ''
    end

    context = center_sep .. '🇻  ' .. context
    return context
end

local function win_cond()
    local n = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(n)
    local win_info = vim.fn.getwininfo(n)[1]

    -- Dont set winbar to quickfix windows, terminals or popups
    if win_config.relative ~= '' or win_info.quickfix ~= 0 or win_info.terminal ~= 0 then
        return false
    end

    local tabpage = vim.api.nvim_win_get_tabpage(n)
    local list = vim.api.nvim_tabpage_list_wins(tabpage)

    -- No need for winbar if its the only window inside the tab
    if #list <= 1 then
        return false
    end

    local i = #list
    for _, v in ipairs(list) do
        local b = vim.api.nvim_win_get_buf(v)
        if vim.bo[b].buftype ~= '' then
            i = i - 1
        end
    end

    -- Dont set winbars if the other windows are N/A buffers
    if i <= 1 then
        return false
    end

    return true
end

local function rootDir()
    local val = vim.fn.expand '%'
    if string.find(val, 'term://') then
        val = ' ' .. vim.fn.fnamemodify(val, ':p:t')
    -- elseif val ~= '' then
    elseif val then
        val = '🗀 ' .. val
    end
    return val
end

local tab_cond = function()
    return #vim.api.nvim_list_tabpages() > 1
end

------------------------------------------------------------------------
--                  Statusline Winbar Tabline                         --
------------------------------------------------------------------------

return {
    'nvim-lualine/lualine.nvim',
    event = 'UIEnter',
    config = function()
        local lualine = require 'lualine'

        local config = lualine.get_config()

        table.insert(config.sections.lualine_c, {
            sc_status,
            cond = function()
                return vim.bo.filetype == 'supercollider'
            end,
        })

        table.insert(config.sections.lualine_c, {
            gps,
            cond = function()
                local ft = vim.bo.filetype
                return not vim.tbl_contains(require('r.utils.tables').ignoreFiles, ft)
            end,
        })
        config.options.disabled_filetypes.statusline = { 'snacks_dashboard', 'trouble' }

        -- ************** Tabline ----------------------------------------------
        config.tabline = {
            lualine_a = { { 'tabs', cond = tab_cond } },
            lualine_c = { { center_sep, cond = tab_cond, separator = '' }, { 'filename', cond = tab_cond } },
            lualine_z = { { rootDir, cond = tab_cond } },
        }
        config.options.always_show_tabline = false

        -- ************** Winbar -----------------------------------------------
        config.winbar = {
            lualine_c = {
                { center_sep, cond = win_cond, separator = '' },
                { 'filename', cond = win_cond, icons_enabled = true, separator = '' },
                { center_sep, cond = win_cond, separator = '' },
            },
        }
        config.inactive_winbar = config.winbar
        config.options.disabled_filetypes.winbar = require('r.utils.tables').ignoreFiles

        config.extensions = { 'fzf', 'lazy', 'oil', 'overseer', 'fugitive', 'man', 'quickfix' }

        lualine.setup(config)
    end,
}
