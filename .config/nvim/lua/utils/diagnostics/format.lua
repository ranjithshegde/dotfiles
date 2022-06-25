local format = {}
------------------------------------------------------------------------
--                              Diagnostic format                     --
------------------------------------------------------------------------

local highlights = {
    error = "",
    warn = "",
    info = "",
    hint = "",
}

function format.sethl(error, warn, hint, info)
    if error then
        highlights.error = "%#" .. error .. "#"
    end

    if warn then
        highlights.warn = "%#" .. warn .. "#"
    end

    if info then
        highlights.info = "%#" .. info .. "#"
    end

    if hint then
        highlights.hint = "%#" .. hint .. "#"
    end
end

function format.formatter(_, _, counts)
    if not vim.b.hasLsp then
        return ""
    end
    local items = {}
    if counts.errors > 0 then
        table.insert(items, string.format("%s %s", highlights.error, counts.errors))
    end

    if counts.warnings > 0 then
        table.insert(items, string.format("%s %s", highlights.warn, counts.warnings))
    end

    if counts.infos > 0 then
        table.insert(items, string.format("%s  %s", highlights.info, counts.infos))
    end

    if counts.hints > 0 then
        table.insert(items, string.format("%s  %s", highlights.hint, counts.hints))
    end

    if vim.tbl_isempty(items) then
        return " "
    end
    return table.concat(items, " ") .. " %##"
end

return format
