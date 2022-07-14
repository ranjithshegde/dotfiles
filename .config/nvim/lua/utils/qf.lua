local qf = {}

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
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd "copen"
        vim.cmd "wincmd J"
    else
        vim.notify "qflist is empty."
    end
end

-- loclist on current window where not empty
local function open_loclist()
    if not vim.tbl_isempty(vim.fn.getloclist(0)) then
        vim.cmd "lopen"
    else
        vim.notify "loclist is empty."
    end
end

--- type='*': qf toggle and send to bottom
--- type='l': loclist toggle (all windows)
--- map to ":lua require'utils'.toggle_qf('l')"
function qf.toggle_qf(type)
    local windows = find_qf(type)
    if not vim.tbl_isempty(windows) then
        -- hide all visible windows
        for _, win in pairs(windows) do
            vim.api.nvim_win_hide(win.winid)
        end
    else
        -- no windows are visible, attempt to open
        if type == "l" then
            open_loclist()
        else
            open_qf()
        end
    end
end

function qf.delete(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local qfl = vim.fn.getqflist()
    local line = unpack(vim.api.nvim_win_get_cursor(0))

    table.remove(qfl, line)

    vim.fn.setqflist({}, "r", { items = qfl })
    vim.fn.setpos(".", { bufnr, line, 1, 0 })
end

return qf
