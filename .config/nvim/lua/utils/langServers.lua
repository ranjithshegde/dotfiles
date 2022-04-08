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

    local function available_capabilities(resolved_capabilities)
        -- these are the capabilities that might be interesting to the user
        local display_keys = {
            "call_hierarchy",
            "code_action",
            "code_lens",
            "completion",
            "declaration",
            "document_formatting",
            "document_highlight",
            "document_range_formatting",
            "document_symbol",
            "execute_command",
            "find_references",
            "goto_definition",
            "hover",
            "implementation",
            "rename",
            "signature_help",
            "type_definition",
        }
        return vim.tbl_filter(function(key)
            -- keep only the capabilities that are interesting & available
            return vim.tbl_contains(display_keys, key) and resolved_capabilities[key] == true
        end, vim.tbl_keys(resolved_capabilities))
    end

    local function make_client_info(client)
        return {
            "Client: " .. client.name .. " (id " .. tostring(client.id) .. ")",
            "resolved: \t" .. table.concat(available_capabilities(client.resolved_capabilities or {}), ", "),
            "raw: \t" .. table.concat(vim.tbl_keys(client.server_capabilities or {}), ", "),
        }
    end

    for _, client in ipairs(buf_clients) do
        vim.list_extend(buf_lines, make_client_info(client))
        vim.list_extend(buf_lines, { "" })
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "lspcapabilities")
    local configs_pattern = [[\%(]] .. table.concat(langSettings.getClientNames(), [[\|]]) .. [[\)]]
    vim.cmd([[syntax match Title /\%(Client\):.*\zs]] .. configs_pattern .. "/")
    vim.keymap.set("n", "<esc>", "<cmd>bd<CR>", { buffer = bufnr })
    vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = bufnr })
end

------------------------------------------------------------------------
--                              TexLab                                --
------------------------------------------------------------------------

-- Count tex words
function langSettings.TexWordCount()
    local count = vim.api.nvim_exec([[silent !texcount -inc -sum -1 %]], true)
    print(count)
end

------------------------------------------------------------------------
--                              CompletionKind                        --
------------------------------------------------------------------------

langSettings.kind_symbols = {
    Text = "",
    Method = "ƒ",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "ﰮ",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "了",
    Keyword = "",
    Snippet = "﬌",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

------------------------------------------------------------------------
--                              TSStatusLine                          --
------------------------------------------------------------------------

local ts_utils = require "nvim-treesitter.ts_utils"

-- associate icons with nodes
local tree_symbol = {
    ["class"] = " ",
    ["function"] = " ",
    ["function_definition"] = " ",
    ["method"] = "ƒ ",
    ["struct"] = " ",
    ["table_constructor"] = " ",
    ["enum"] = "了 ",
    ["interface"] = "ﰮ ",
    ["module"] = " ",
    ["require"] = " ",
    ["type_spec"] = " ",
    ["chapter"] = " ",
    ["subsection"] = " ",
    ["section"] = " ",
    ["linkage_specification"] = " ",
}

-- Trim spaces and opening brackets from end
function langSettings.transform_line(line)
    return line:gsub("%s*[%[%(%{]*%s*$", "")
end

-- get current node
function langSettings.get_line_for_node(node, type_patterns, transform_fn)
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
    local line = transform_fn(vim.trim(ts_utils.get_node_text(node)[1] or ""))

    for index, value in pairs(tree_symbol) do
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

------------------------------------------------------------------------
--                              Chain completion                      --
------------------------------------------------------------------------

local chainList = {
    filetype = {
        glsl = {
            "<C-x><C-u>",
        },
    },
}

langSettings.chainIndex = {
    function()
        local ok, cmp = pcall(require, "cmp")
        if ok then
            cmp.setup.buffer {
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
            }
            cmp.complete()
        end
    end,

    function()
        require("utils").feedkey("<C-x><C-p>", "n")
    end,

    function()
        local ft = vim.api.nvim_buf_get_option(0, "filetype")
        if chainList.filetype[ft] then
            for _, v in pairs(chainList.filetype[ft]) do
                require("utils").feedkey(v, "n")
            end
        else
            require("utils").feedkey("<C-x><C-n>", "n")
        end
    end,

    function()
        local ok, cmp = pcall(require, "cmp")
        if ok then
            cmp.setup.buffer {
                sources = {
                    { name = "path" },
                },
            }
            cmp.complete()
        end
    end,
}

langSettings.index = 1

langSettings.next = function()
    if langSettings.index ~= #langSettings.chainIndex then
        langSettings.index = langSettings.index + 1
    else
        langSettings.index = 1
    end
    return langSettings.chainIndex[langSettings.index]()
end

langSettings.prev = function()
    if langSettings.index ~= 1 then
        langSettings.index = langSettings.index - 1
    else
        langSettings.index = #langSettings.chainIndex
    end
    return langSettings.chainIndex[langSettings.index]()
end

return langSettings
