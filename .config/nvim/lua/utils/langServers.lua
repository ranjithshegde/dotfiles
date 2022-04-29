local langSettings = {}

langSettings.getClientNames = function()
    local buf_clients = vim.lsp.buf_get_clients()

    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
    end
    return buf_client_names
end

------------------------------------------------------------------------
--                              Capabilities                          --
------------------------------------------------------------------------

langSettings.lsp_capabilities = function()
    local buf_clients = vim.lsp.buf_get_clients()
    local windows = require "lspconfig/ui/windows"
    local win_info = windows.percentage_range_window(0.8, 0.7)
    local bufnr = win_info.bufnr

    local buf_lines = {}

    local function available_capabilities(server_capabilities)
        return vim.tbl_filter(function(key)
            return server_capabilities[key] == true
        end, vim.tbl_keys(server_capabilities))
    end

    local function make_client_info(client)
        return {
            "Client: " .. client.name .. " (id " .. tostring(client.id) .. ")",
            "resolved: \t" .. table.concat(available_capabilities(client.server_capabilities or {}), ", "),
            "raw: \t" .. table.concat(vim.tbl_keys(client.server_capabilities or {}), ", "),
        }
    end

    for _, client in ipairs(buf_clients) do
        vim.list_extend(buf_lines, make_client_info(client))
        vim.list_extend(buf_lines, { "" })
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "lspinfo")
    local configs_pattern = [[\%(]] .. table.concat(langSettings.getClientNames(), [[\|]]) .. [[\)]]
    vim.cmd([[syntax match Title /\%(Client\):.*\zs]] .. configs_pattern .. "/")
    vim.keymap.set("n", "<esc>", "<cmd>bd<CR>", { buffer = bufnr })
    vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = bufnr })
end

------------------------------------------------------------------------
--                              TexLab                                --
------------------------------------------------------------------------

---Return word count for the tex document
function langSettings.TexWordCount()
    local count = vim.api.nvim_exec([[silent !texcount -inc -sum -1 %]], true)
    print(count)
end

------------------------------------------------------------------------
--                              TSStatusLine                          --
------------------------------------------------------------------------

-- get current node
function langSettings.get_line_for_node(node, type_patterns, transform_fn, bufnr)
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
        return ""
    end
    local line = transform_fn(vim.trim(vim.treesitter.query.get_node_text(node, bufnr) or ""))

    for index, value in pairs(require("utils.tables").tsNodeSymbols) do
        index = index:gsub("%[", "")
        index = index:gsub("%]", "")
        if index == "section" and line:find "*" then
            line = line:gsub("*", "")
        end

        if index == i then
            line = value .. line
        end
        if line:find(index) then
            if line:find(value) then
                line = line:gsub(index, "")
            else
                line = line:gsub(index, value)
            end
        end
    end
    -- Escape % to avoid statusline to evaluate content as expression
    return line:gsub("%%", "%%%%")
end

return langSettings
