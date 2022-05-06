local qf = {}

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

-- 'q': find the quickfix window
-- 'l': find all loclist windows
local function find_qf(type)
    local wininfo = vim.fn.getwininfo()
    local win_tbl = {}
    for _, win in pairs(wininfo) do
        local found = false
        if type == "l" and win["loclist"] == 1 then
            found = true
        end
        -- loclist window has 'quickfix' set, eliminate those
        if type == "q" and win["quickfix"] == 1 and win["loclist"] == 0 then
            found = true
        end
        if found then
            table.insert(win_tbl, { winid = win["winid"], bufnr = win["bufnr"] })
        end
    end
    return win_tbl
end

-- open quickfix if not empty
local function open_qf()
    local qf_name = "quickfix"
    local qf_empty = function()
        return vim.tbl_isempty(vim.fn.getqflist())
    end
    if not qf_empty() then
        vim.cmd "copen"
        vim.cmd "wincmd J"
    else
        print(string.format("%s is empty.", qf_name))
    end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
local function open_loclist_all()
    local wininfo = vim.fn.getwininfo()
    local qf_name = "loclist"
    local qf_empty = function(winnr)
        return vim.tbl_isempty(vim.fn.getloclist(winnr))
    end
    for _, win in pairs(wininfo) do
        if win["quickfix"] == 0 then
            if not qf_empty(win["winnr"]) then
                -- switch active window before ':lopen'
                vim.api.nvim_set_current_win(win["winid"])
                vim.cmd "lopen"
            else
                print(string.format("%s is empty.", qf_name))
            end
        end
    end
end

-- type='*': qf toggle and send to bottom
-- type='l': loclist toggle (all windows)
-- map to ":lua require'utils'.toggle_qf('l')"
function qf.toggle_qf(type)
    local windows = find_qf(type)
    if tablelength(windows) > 0 then
        -- hide all visible windows
        for _, win in pairs(windows) do
            vim.api.nvim_win_hide(win.winid)
        end
    else
        -- no windows are visible, attempt to open
        if type == "l" then
            open_loclist_all()
        else
            open_qf()
        end
    end
end

function qf.delete(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local qfl = vim.fn.getqflist()
    local line = unpack(vim.api.nvim_win_get_cursor(0))

    local mode = vim.api.nvim_get_mode().mode
    if mode == "v" or mode == "V" then
        local startline = unpack(vim.api.nvim_buf_get_mark(0, "<"))
        local endline = unpack(vim.api.nvim_buf_get_mark(0, ">"))
        local result = {}
        for i, item in ipairs(qfl) do
            if i < startline or i > endline then
                table.insert(result, item)
            end
        end
        qfl = result
    else
        table.remove(qfl, line)
    end

    vim.fn.setqflist({}, "r", { items = qfl })
    vim.fn.setpos(".", { bufnr, line, 1, 0 })
end

return qf
