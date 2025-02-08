local center_sep = '%='

local function sc_status()
    local scstatus = tostring(require('scnvim.statusline').get_server_status())
    if scstatus ~= '' then
        scstatus = scstatus:gsub('%%', '%%%%')
        return '📡 [' .. scstatus .. ']'
    end
    return ''
end

local function rootDir()
    local val = vim.fn.expand '%'
    if string.find(val, 'term://') then
        val = ' ' .. vim.fn.fnamemodify(val, ':p:t')
    elseif val then
        val = '🗀 ' .. vim.fs.dirname(val)
    end
    return val
end

local tab_cond = function()
    return #vim.api.nvim_list_tabpages() > 1
end

------------------------------------------------------------------------
--                  Statusline Winbar Tabline                         --
------------------------------------------------------------------------
local sections = {
    lualine_a = { 'mode' },
    lualine_b = {
        'branch',
        {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
        },
    },
    lualine_c = {
        center_sep,
        'diagnostics',
        {
            sc_status,
            cond = function()
                return vim.bo.filetype == 'supercollider'
            end,
        },
        {
            'filename',
            newfile_status = true,
            symbols = {
                readonly = '🔒',
                modified = '✏️',
                unnamed = '📄',
                newfile = '🗎',
            },
        },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
}

return {
    'nvim-lualine/lualine.nvim',
    event = 'UIEnter',
    config = function()
        local lualine = require 'lualine'

        local config = lualine.get_config()

        config.sections = sections
        config.options.disabled_filetypes.statusline = { 'snacks_dashboard', 'trouble' }

        config.options.section_separators = { right = '', left = '' }
        config.options.component_separators = ''

        -- ************** Tabline ----------------------------------------------
        config.tabline = {
            lualine_a = { { 'tabs', cond = tab_cond } },
            lualine_c = { { 'buffers', cond = tab_cond } },
            lualine_z = { { rootDir, cond = tab_cond } },
        }
        config.options.always_show_tabline = false

        config.options.disabled_filetypes.winbar = require('r.utils.tables').ignoreFiles

        config.extensions = { 'fzf', 'lazy', 'oil', 'overseer', 'man', 'quickfix' }

        lualine.setup(config)
    end,
}
