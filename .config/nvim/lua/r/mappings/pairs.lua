local function exec_move(cmd)
    local old_fold = vim.opt_local.foldmethod:get()
    if old_fold ~= "manual" then
        vim.opt_local.foldmethod = "manual"
    end
    vim.cmd.normal { args = { "m`" }, bang = true }
    vim.cmd(cmd)
    vim.cmd.normal { args = { "``" }, bang = true }
    if old_fold ~= "manual" then
        vim.opt_local.foldmethod = old_fold
    end
end

local function blank(count, orient)
    local space = {}
    for i = 1, count, 1 do
        table.insert(space, 1, "")
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, cursor[1] + orient, cursor[1] + orient, true, space)
    vim.api.nvim_win_set_cursor(0, { orient ~= 0 and cursor[1] + count or cursor[1], cursor[2] })
end

local function move(cmd, count)
    exec_move { cmd = "move", args = { cmd, tostring(count) } }
end

local function call_cmd(cmd)
    return function()
        if vim.v.count > 1 then
            if not pcall(vim.cmd, tostring(vim.v.count1) .. cmd) then
                print "No more results"
            end
        else
            if not pcall(vim.cmd, cmd) then
                print "No more results"
            end
        end
    end
end

return require("which-key").register({
    ["]"] = {
        name = "Unimpaired next",
        a = { call_cmd "next", "Switch to next file in argument list" },
        b = { call_cmd "bnext", "Switch to next buffer" },
        q = { call_cmd "cnext", "Switch to next Quickfix entry" },
        l = { call_cmd "lnext", "Switch to next locationList entry" },
        e = {
            function()
                move("+", vim.v.count1 - 1)
            end,
            "Move current line below to the specified count",
        },
        ["<Space>"] = {
            function()
                blank(vim.v.count1, 0)
            end,
            "Add [count] spaces below current line",
        },
        o = {
            name = "Vim options",
            c = { require("r.utils").cycle_colors, "Cycle nightfox colorschemes" },
            v = { require("r.utils").toggle_vi, "Toggle vi decoration mode" },
        },
    },
    ["["] = {
        name = "Unimpaired previous",
        a = { call_cmd "previous", "Switch to next file in argument list" },
        b = { call_cmd "bprevious", "Switch to previous buffer" },
        q = { call_cmd "cprevious", "Switch to previous Quickfix entry" },
        l = { call_cmd "lprevious", "Switch to previous locationList entry" },
        e = {
            function()
                move("--", vim.v.count1 - 1)
            end,
            "Move current line above to the specified count",
        },
        ["<Space>"] = {
            function()
                blank(vim.v.count1, -1)
            end,
            "Add [count] spaces above current line",
        },
    },
}, {})
