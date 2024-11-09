local function blank(count, orient)
    local space = {}
    for i = 1, count, 1 do
        table.insert(space, i, '')
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, cursor[1] + orient, cursor[1] + orient, true, space)
    vim.api.nvim_win_set_cursor(0, { orient ~= 0 and cursor[1] + count or cursor[1], cursor[2] })
end

local function move(cmd, count)
    local old_fold = vim.wo.foldmethod
    if old_fold ~= 'manual' then
        vim.wo.foldmethod = 'manual'
    end
    vim.cmd.normal { args = { 'm`' }, bang = true }
    vim.cmd.move { args = { cmd, tostring(count) } }
    vim.cmd.normal { args = { '``' }, bang = true }
    if old_fold ~= 'manual' then
        vim.wo.foldmethod = old_fold
    end
end

local maps = {
    [']'] = {
        name = 'Unimpaired next',
        e = {
            function()
                move('+', vim.v.count1 - 1)
            end,
            'Move current line below to the specified count',
        },
        ['<Space>'] = {
            function()
                blank(vim.v.count1, 0)
            end,
            'Add [count] spaces below current line',
        },
    },
    ['['] = {
        name = 'Unimpaired previous',
        e = {
            function()
                move('--', vim.v.count1 - 1)
            end,
            'Move current line above to the specified count',
        },
        ['<Space>'] = {
            function()
                blank(vim.v.count1, -1)
            end,
            'Add [count] spaces above current line',
        },
    },
}

return require('which-key').register(maps)
