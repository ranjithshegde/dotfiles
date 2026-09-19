local ui2 = require 'vim._core.ui2'
local cmd_win_saved = nil
local original_pos = nil
local cmdline_type = nil
local wrapped = false

local ignored_modes = { '/', '?' }
local configured_width = 0.6
local min_width = 40
local max_width = 120
local menu_offset = 3

local function get_cmd_win()
    local win = ui2.wins and ui2.wins.cmd
    return (win and vim.api.nvim_win_is_valid(win)) and win or nil
end

local function set_cmdheight_0()
    vim._with({ noautocmd = true }, function()
        vim.o.cmdheight = 0
    end)
end

local function geometry(content_height)
    local cols = vim.o.columns
    local lines = vim.o.lines
    local b = 1
    local width = math.max(min_width, math.min(max_width, math.floor(cols * configured_width)))
    width = math.min(width, cols - 4)
    local row = math.max(0, math.floor((lines - content_height - b * 2) * 0.3))
    local col = math.max(0, math.floor((cols - width - b * 2) / 2))
    return width, row, col, b
end

local function reposition()
    local win = get_cmd_win()
    if not win then
        return
    end

    local content_height = math.max(1, vim.api.nvim_win_get_height(win))

    if vim.tbl_contains(ignored_modes, cmdline_type) then
        pcall(vim.api.nvim_win_set_config, win, {
            relative = 'editor',
            row = math.max(0, vim.o.lines - content_height - menu_offset),
            col = 0,
            width = vim.o.columns,
            border = 'rounded',
        })
        vim.g.ui_cmdline_pos = original_pos
        return
    end

    if not cmd_win_saved then
        local cfg = vim.api.nvim_win_get_config(win)
        cmd_win_saved = {
            relative = cfg.relative,
            anchor = cfg.anchor,
            col = cfg.col,
            row = cfg.row,
            width = cfg.width,
            border = cfg.border,
        }
    end

    local width, row, col, b = geometry(content_height)
    pcall(vim.api.nvim_win_set_config, win, {
        relative = 'editor',
        row = row,
        col = col,
        width = width,
        border = 'rounded',
    })
    vim.g.ui_cmdline_pos = { row + content_height + b * 2, col + b + menu_offset }
end

local function wrap_cmdline_show()
    if wrapped then
        return
    end
    local ok, cmdline = pcall(require, 'vim._core.ui2.cmdline')
    if not ok then
        return
    end
    local orig = cmdline.cmdline_show
    cmdline.cmdline_show = function(...)
        local r = orig(...)
        set_cmdheight_0()
        reposition()
        return r
    end
    wrapped = true
end

return function()
    local id = {
        FloatingCmdline = vim.api.nvim_create_augroup('FloatingCmdline', { clear = true }),
    }

    require('vim._core.ui2').enable { enable = true }
    original_pos = vim.g.ui_cmdline_pos

    vim.api.nvim_create_autocmd('CmdlineEnter', {
        group = id.FloatingCmdline,
        callback = function()
            cmdline_type = vim.fn.getcmdtype()
        end,
    })

    vim.api.nvim_create_autocmd('CmdlineLeave', {
        group = id.FloatingCmdline,
        callback = function()
            local win = get_cmd_win()
            if win and cmd_win_saved then
                pcall(vim.api.nvim_win_set_config, win, cmd_win_saved)
            end
            cmd_win_saved = nil
            cmdline_type = nil
            vim.g.ui_cmdline_pos = original_pos
        end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = id.FloatingCmdline,
        pattern = 'cmd',
        callback = function()
            vim.schedule(function()
                local win = get_cmd_win()
                if win then
                    vim.wo[win].number = false
                    vim.wo[win].relativenumber = false
                    vim.wo[win].signcolumn = 'no'
                    vim.wo[win].winbar = ''
                end
                wrap_cmdline_show()
                reposition()
            end)
        end,
    })

    vim.api.nvim_create_autocmd({ 'VimResized', 'TabEnter' }, {
        group = id.FloatingCmdline,
        callback = function()
            vim.schedule(reposition)
        end,
    })

    require('r.utils').register_au_id(id)

    vim.schedule(function()
        wrap_cmdline_show()
        reposition()
    end)
end
