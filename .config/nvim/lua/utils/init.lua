local utils = {}

Api = vim.api
G = vim.g
Var = Api.nvim_set_var
Exec = Api.nvim_command
Op = Api.nvim_get_option
Fn = Api.nvim_call_function
Cmd = vim.cmd

local browser = "qutebrowser"

-- **************Neovim options ---------------------------------------------------------

function utils.UnloadAllModules()
    -- Lua patterns for the modules to unload
    local unload_modules = {
        "^mappings$",
        "^compiler$",
        -- "^plugins$",
        "^settings$",
        "^statusline$",
        "^utils$"
    }
    for k, _ in pairs(package.loaded) do
        for _, v in ipairs(unload_modules) do
            if k:match(v) then
                package.loaded[k] = nil
                break
            end
        end
    end
end

-- Reload Vim configuration
function utils.Reload()
    Cmd("LspStop")
    utils.UnloadAllModules()
    Cmd("source $MYVIMRC")
end

-- Restart Vim without having to close and run again
function utils.Restart()
    utils.Reload()
    Cmd("doautocmd VimEnter")
end

-- ************** Multi AutoCommands ---------------------------------------------------------

function utils.create_bufgroups(definitions)
    for group_name, definition in pairs(definitions) do
        Exec("augroup " .. group_name)
        Exec("autocmd! * <buffer>")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            Exec(command)
        end
        Exec("augroup END")
    end
end

function utils.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        Exec("augroup " .. group_name)
        Exec("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            Exec(command)
        end
        Exec("augroup END")
    end
end

-- ************** Single AutoCommands ---------------------------------------------------------

function utils.create_augroup(autocmds, name)
    Exec("augroup " .. name)
    Exec("autocmd!")
    for _, autocmd in ipairs(autocmds) do
        Exec("autocmd " .. table.concat(autocmd, " "))
    end
    Exec("augroup END")
end

function utils.create_bufgroup(autocmds, name)
    Exec("augroup " .. name)
    Exec("autocmd! * <buffer>")
    for _, autocmd in ipairs(autocmds) do
        Exec("autocmd " .. table.concat(autocmd, " "))
    end
    Exec("augroup END")
end

-- ************** Mappings ---------------------------------------------------------

function utils.bufmaps(mapdict, opts)
    for m = 1, #mapdict do
        local mode = mapdict[m][1]
        local lhs = mapdict[m][2]
        local rhs = mapdict[m][3]
        local buffer = 0

        Api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
    end
end

function utils.maps(mapdict, opts)
    for m = 1, #mapdict do
        local mode = mapdict[m][1]
        local lhs = mapdict[m][2]
        local rhs = mapdict[m][3]

        Api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

-- ************** vim settings  ---------------------------------------------------------

function _G.HighlightOnYank()
    vim.highlight.on_yank {higroup = "IncSearch", timeout = 200}
end

utils.create_augroup({{"TextYankPost", "*", "silent! lua HighlightOnYank()"}}, "YankHighlight")

-- ************** LSP  ---------------------------------------------------------

-- Hover for Clangd
function utils.clang_hover()
    local name = "clangd"
    local clients =
        vim.tbl_filter(
        function(c)
            return c.name == name
        end,
        vim.lsp.get_active_clients()
    )
    local match, client = next(clients)
    assert(match, "No active client found with same name=" .. name)
    client.request("textDocument/hover", vim.lsp.util.make_position_params())
end

-- Peek Definition
function utils.preview_location(location, context, before_context)
    -- location may be LocationLink or Location (more useful for the former)
    context = context or 15
    before_context = before_context or 0
    local uri = location.targetUri or location.uri
    if uri == nil then
        return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
    end
    local range = location.targetRange or location.range
    local contents =
        vim.api.nvim_buf_get_lines(bufnr, range.start.line - before_context, range["end"].line + 1 + context, false)
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    return vim.lsp.util.open_floating_preview(contents, filetype)
end

function utils.preview_location_callback(_, method, result)
    local context = 15
    -- local border = {"double"}
    -- local opts = {context = 15, border = {"double"}}
    if result == nil or vim.tbl_isempty(result) then
        print("No location found: " .. method)
        return nil
    end
    if vim.tbl_islist(result) then
        -- utils.floating_buf, utils.floating_win = vim.lsp.util.preview_location(result[1], opts)
        utils.floating_buf, utils.floating_win = utils.preview_location(result[1], context)
    else
        -- utils.floating_buf, utils.floating_win = vim.lsp.util.preview_location(result,opts)
        utils.floating_buf, utils.floating_win = utils.preview_location(result, context)
    end
end

function utils.peek_definition()
    if vim.tbl_contains(vim.api.nvim_list_wins(), utils.floating_win) then
        vim.api.nvim_set_current_win(utils.floating_win)
    else
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, "textDocument/definition", params, utils.preview_location_callback)
    end
end

-- ************** Custom completion sources  ---------------------------------------------------------

function utils.getCompletionItems(prefix)
    vim.api.nvim_call_function("vimtex#complete#omnifunc", {1, ""})
    local items = vim.api.nvim_call_function("vimtex#complete#omnifunc", {0, prefix})
    return items
end

utils.complete_item = {item = utils.getCompletionItems}

-- ************** Open with browser ---------------------------------------------------------

-- set silent exec option
function utils.silent_shell(cmd)
    Exec("silent exe '!" .. cmd .. " &'")
end

-- set browser
function utils.open_in_browser(url)
    utils.silent_shell(browser .. " " .. url)
end

-- set execute
function utils.exec(cmd)
    Exec(cmd)
end

-- Start Instant server
function utils.Start()
    local id = vim.fn.input("Enter extension: ")
    Exec "PackerLoad instant.nvim"
    utils.exec("InstantStartServer 192.168.178." .. id .. " 8080")
end

-- Start Single session
function utils.Session()
    local id = vim.fn.input("Enter extension: ")
    utils.exec("InstantStartSession 192.168.178." .. id .. " 8080")
end

-- Start Single buffer
function utils.Single()
    local id = vim.fn.input("Enter extension: ")
    utils.exec("InstantStartSingle 192.168.178." .. id .. " 8080")
end

-- Follow a user
function utils.Follow()
    local name = vim.fn.input("User to follow: ")
    utils.exec("InstantFollow " .. name)
end

-- Join Single session
function utils.JoinSession()
    Exec "PackerLoad instant.nvim"
    local id = vim.fn.input("Enter extension: ")
    utils.exec("InstantJoinSession 192.168.178." .. id .. " 8080")
    utils.Follow()
end

-- Join Single buffer
function utils.JoinSingle()
    Exec "PackerLoad instant.nvim"
    local id = vim.fn.input("Enter extension: ")
    utils.exec("InstantJoinSingle 192.168.178." .. id .. " 8080")
    utils.Follow()
end

return utils
