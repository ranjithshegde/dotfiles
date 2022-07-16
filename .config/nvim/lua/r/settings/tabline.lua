local space = " "

--*********************************** File path ------------------------
local function rootDir()
    local val = vim.fn.expand "%"
    if string.find(val, "term://") ~= nil then
        val = " " .. vim.fn.fnamemodify(val, ":p:t")
    elseif val ~= "" then
        val = "🗀 " .. val
    end
    return val
end

------------------------------------------------------------------------
--                              TabLine                               --
------------------------------------------------------------------------
return function()
    local tabline = ""
    local tab_list = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_get_current_tabpage()
    for _, val in ipairs(tab_list) do
        local name = require("r.utils").get_file_label(val, true)
        if val == current_tab then
            if name.icon then
                tabline = tabline .. "%#IconColor#" .. space .. name.icon .. "%#TabLineSel# " .. name.tail .. space
            else
                tabline = tabline .. space .. "%#TabLineSel# " .. name.tail .. space
            end
        else
            tabline = tabline .. space .. "%#TabLine# " .. name.tail .. space
        end
    end
    tabline = tabline .. "%#TabLineFill#" .. "%="
    tabline = tabline .. "%#TabLineSel# " .. rootDir() .. space
    return tabline
end
