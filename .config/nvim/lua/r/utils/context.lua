------------------------------------------------------------------------
--                             Treesitter Statusline                  --
------------------------------------------------------------------------

-- get current node
local function get_line_for_node(node, type_patterns, transform_fn, bufnr)
    local node_type = node:type()
    local is_valid = false
    local i
    for _, rgx in ipairs(type_patterns) do
        if node_type:find(rgx) then
            is_valid = true
            i = rgx
            break
        end
    end
    if not is_valid then
        return ''
    end
    local line = transform_fn(vim.trim(vim.treesitter.get_node_text(node, bufnr) or ''))

    for index, value in pairs(require('r.utils.tables').tsNodeSymbols) do
        index = index:gsub('%[', ''):gsub('%]', '')
        if index == 'section' and line:find '*' then
            line = line:gsub('*', '')
        end

        if index == i then
            line = value .. line
        end
        if line:find(index) then
            if line:find(value) then
                line = line:gsub(index, '')
            else
                line = line:gsub(index, value)
            end
        end
    end
    -- Escape % to avoid statusline to evaluate content as expression
    return line:gsub('%%', '%%%%')
end

-- Trim spaces and opening brackets from end
local function transform_line(line)
    line = line:sub(1, line:find '\n')
    return line:gsub('%s*[%[%(%{]*%s*$', '')
end

return function(opts)
    if not vim.treesitter.language.get_lang(vim.bo.filetype) then
        return
    end

    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ''
    end

    local lines = {}
    local separator = ' -> '

    while current_node do
        local line = get_line_for_node(current_node, opts.type_patterns, transform_line, opts.bufnr)
        if line ~= '' and not vim.tbl_contains(lines, line) then
            table.insert(lines, 1, line)
        end
        current_node = current_node:parent()
    end

    local text = table.concat(lines, separator)
    local text_len = #text
    if text_len > opts.indicator_size then
        text_len = text:find(' ', opts.indicator_size)
        return text:sub(1, text_len) .. '...'
    end

    return text
end
