------------------------------------------------------------------------
--                              Capabilities                          --
------------------------------------------------------------------------

local config = {
    relative = 'editor',
    style = 'minimal',
    width = 70,
    height = 25,
    row = 0,
    col = 0,
    border = 'double',
}

local function available_capabilities(server_capabilities)
    return vim.tbl_filter(function(key)
        if type(server_capabilities[key]) == 'table' then
            return not vim.tbl_isempty(server_capabilities[key])
        else
            return server_capabilities[key] == true
        end
    end, vim.tbl_keys(server_capabilities))
end

return function()
    local init_buf = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_active_clients { bufnr = init_buf }
    local bufnr = vim.api.nvim_create_buf(false, true)

    local buf_lines = {}

    local function make_client_info(client)
        local info = client.name .. ' (id ' .. tostring(client.id) .. ')'
        local capabils = { '## Capabilities:', '```lua' }
        if client.server_capabilities then
            local all = client.server_capabilities
            local cap_resolved = available_capabilities(client.server_capabilities)
            local cap_raw = vim.tbl_keys(client.server_capabilities)

            for _, value in ipairs(cap_raw) do
                if vim.tbl_contains(cap_resolved, value) then
                    if type(all[value]) == 'table' then
                        local k1 = vim.tbl_keys(all[value])
                        table.insert(capabils, '\t ' .. value .. ' = {')
                        for _, val in pairs(k1) do
                            if type(all[value][val]) == 'table' then
                                local k2 = vim.tbl_keys(all[value][val])
                                table.insert(capabils, '\t\t ' .. val .. ' = {')
                                local sub = {}
                                for _, v in pairs(k2) do
                                    local s = all[value][val][v]
                                    if s then
                                        if type(s) == 'table' then
                                            table.insert(capabils, '\t\t\t ' .. table.concat(s, ', '))
                                        elseif type(s) == 'string' then
                                            local ss = string.gsub(s, '\n', '\\n')
                                            table.insert(sub, ss)
                                        else
                                            table.insert(capabils, '\t\t\t ' .. tostring(s))
                                        end
                                    end
                                end
                                if not vim.tbl_isempty(sub) then
                                    table.insert(capabils, '\t\t\t ' .. table.concat(sub, ', '))
                                end
                                table.insert(capabils, '\t\t }')
                            else
                                table.insert(capabils, '\t\t ' .. val .. '= true,')
                            end
                        end
                        table.insert(capabils, '\t },')
                    else
                        table.insert(capabils, '\t ' .. value .. '= true,')
                    end
                else
                    table.insert(capabils, '\t ' .. value .. '= false,')
                end
            end
        end
        return {
            '# Client: ' .. info,
            capabils,
        }
    end

    for _, client in ipairs(buf_clients) do
        local newlines = make_client_info(client)
        vim.list_extend(buf_lines, { newlines[1] })
        vim.list_extend(buf_lines, newlines[2])
        vim.list_extend(buf_lines, { '```' })
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
    vim.bo[bufnr].modifiable = false
    vim.keymap.set('n', '<esc>', vim.cmd.bd, { buffer = bufnr })
    vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = bufnr })
    vim.api.nvim_open_win(bufnr, true, config)
    vim.bo[bufnr].filetype = 'LspCapabilities'
    vim.cmd.normal { args = { 'zx' }, bang = true }
end
