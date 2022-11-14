------------------------------------------------------------------------
--                              Winbar                                --
------------------------------------------------------------------------

local function win_validate(n)
    local win_config = vim.api.nvim_win_get_config(n)
    local win_info = vim.fn.getwininfo(n)[1]

    -- Dont set winbar to quickfix windows, terminals or popups
    if win_config.relative ~= '' or win_info.quickfix ~= 0 or win_info.terminal ~= 0 then
        vim.wo[n].winbar = nil
        return false
    end

    local tabpage = vim.api.nvim_win_get_tabpage(n)
    local list = vim.api.nvim_tabpage_list_wins(tabpage)

    -- No need for winbar if its the only window inside the tab
    if #list <= 1 then
        vim.wo[n].winbar = nil
        return false
    end

    local i = #list
    for _, v in ipairs(list) do
        local b = vim.api.nvim_win_get_buf(v)
        if vim.tbl_contains(require('r.utils.tables').ignoreFiles, vim.bo[b].filetype) or vim.bo[b].buftype ~= '' then
            i = i - 1
        end
    end

    -- Dont set winbars if the other windows are N/A buffers
    if i <= 1 then
        vim.wo[n].winbar = nil
        return false
    end

    return true
end

return function(n)
    if not win_validate(n) then
        return
    end

    local winbar

    -- Dont set winbars for nondescript buffers
    local label = require('r.utils').get_file_label(n, false)
    if label.tail:match 'Empty' then
        vim.wo[n].winbar = ''
        return
    end

    vim.api.nvim_set_hl(0, 'WinBar' .. n, { fg = label.color, cterm = { bold = true } })

    if label.icon then
        winbar = '%=' .. '%#WinBar' .. n .. '# ' .. label.icon .. '%## ' .. label.tail .. '%='
    else
        winbar = '%=' .. label.tail .. '%='
    end

    vim.wo[n].winbar = winbar
end
