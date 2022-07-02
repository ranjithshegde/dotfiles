local ffi = require "ffi"
local M = {}

local border_shift = { -1, -1, -1, -1 }

local fold_preview = {}

---Open popup window with folded text preview. Also set autocommands to close
---popup window and change its size on scrolling and vim resizing.
function M.show_preview()
    local auid
    ---Current buffer ID
    local curbufnr = vim.api.nvim_get_current_buf()

    fold_preview[curbufnr] = {}

    local fold_start = vim.fn.foldclosed "." -- '.' is the current line
    if fold_start == -1 then
        return
    end

    local fold_end = vim.fn.foldclosedend "."

    ---The number of folded lines.
    local fold_size = fold_end - fold_start + 1

    ---The number of window rows from the current cursor line to the end of the
    ---window. I.e. room below for float window.
    local room_below = vim.api.nvim_win_get_height(0) - vim.fn.winline() + 1

    ---The maximum line length of the folded region.
    local max_line_len = 0

    local folded_lines = vim.api.nvim_buf_get_lines(0, fold_start - 1, fold_end, true)
    local indent = #(folded_lines[1]:match "^%s+" or "")
    for i, line in ipairs(folded_lines) do
        if indent > 0 then
            line = line:sub(indent + 1)
        end
        folded_lines[i] = line
        local line_len = vim.fn.strdisplaywidth(line)
        if line_len > max_line_len then
            max_line_len = line_len
        end
    end

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, folded_lines)
    vim.bo[bufnr].filetype = vim.bo.filetype
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].readonly = true

    ---The width of offset of a window, occupied by line number column,
    ---fold column and sign column.

    ffi.cdef [[
    int curwin_col_off(void);
    ]]

    local gutter_width = ffi.C.curwin_col_off()

    ---The number of columns from the left boundary of the preview window to the
    ---right boundary of the current window.
    local room_right = vim.api.nvim_win_get_width(0) - gutter_width - indent

    local winid = vim.api.nvim_open_win(bufnr, false, {
        border = "double",
        relative = "win",
        bufpos = { -- Zero-indexed, that's why minus one.
            fold_start - 1,
            indent,
        },
        -- The position of the window relative to 'bufos' field.
        row = border_shift[1],
        col = border_shift[4],

        width = max_line_len + 2 < room_right and max_line_len + 1 or room_right - 1,
        height = fold_size < room_below and fold_size or room_below,
        style = "minimal",
        focusable = false,
        noautocmd = true,
    })
    vim.wo[winid].foldenable = false
    vim.wo[winid].signcolumn = "no"

    fold_preview[curbufnr].close = function()
        vim.api.nvim_win_close(winid, false)
        vim.api.nvim_buf_delete(bufnr, { force = true, unload = false })
        fold_preview[curbufnr] = nil
        auid = vim.api.nvim_create_augroup("FoldPreview", { clear = true })
        vim.g.fold_preview = true
    end

    fold_preview[curbufnr].scroll = function()
        room_below = vim.api.nvim_win_get_height(0) - vim.fn.winline() + 1
        vim.api.nvim_win_set_height(winid, fold_size < room_below and fold_size or room_below)
    end

    fold_preview[curbufnr].resize = function()
        room_right = vim.api.nvim_win_get_width(0) - gutter_width - indent
        vim.api.nvim_win_set_width(winid, max_line_len < room_right and max_line_len or room_right)
    end

    if not auid then
        auid = vim.api.nvim_create_augroup("FoldPreview", { clear = true })
    end

    vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "CmdlineEnter", "InsertEnter" }, {
        group = auid,
        buffer = curbufnr,
        callback = function()
            fold_preview[curbufnr].close()
        end,
        once = true,
        desc = "Close preview when on any cursor change",
    })
    vim.api.nvim_create_autocmd("WinScrolled", {
        group = auid,
        buffer = bufnr,
        callback = function()
            fold_preview[curbufnr].scroll()
        end,
        desc = "scroll preview window when main window scrolls",
    })
    vim.api.nvim_create_autocmd("VimResized", {
        group = auid,
        buffer = bufnr,
        callback = function()
            fold_preview[curbufnr].resize()
        end,
        desc = "Resize preview window when main window resizes",
    })
end

function M.keymap_open_close(key)
    if vim.fn.foldclosed "." ~= -1 and vim.g.fold_preview then
        vim.g.fold_preview = false
        M.show_preview()
    elseif vim.fn.foldclosed "." ~= -1 and not vim.g.fold_preview then
        vim.api.nvim_command "normal! zv"
        local bufnr = vim.api.nvim_get_current_buf()
        if fold_preview[bufnr] then
            -- For smoothness to avoid annoying screen flickering.
            vim.fn.timer_start(1, fold_preview[bufnr].close)
        end
    else
        vim.api.nvim_command("normal! " .. vim.v.count1 .. key)
    end
end

function M.keymap_close(key)
    if vim.fn.foldclosed "." ~= -1 and not vim.g.fold_preview then
        vim.api.nvim_command "normal! zv"
        local bufnr = vim.api.nvim_get_current_buf()
        if fold_preview[bufnr] then
            -- For smoothness to avoid annoying screen flickering.
            vim.fn.timer_start(1, fold_preview[bufnr].close)
        end
    elseif vim.fn.foldclosed "." ~= -1 then
        vim.api.nvim_command "normal! zv"
    else
        vim.api.nvim_command("normal! " .. vim.v.count1 .. key)
    end
end

return M
