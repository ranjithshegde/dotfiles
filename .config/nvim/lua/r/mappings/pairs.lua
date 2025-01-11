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
    },
    ['['] = {
        name = 'Unimpaired previous',
        e = {
            function()
                move('--', vim.v.count1 - 1)
            end,
            'Move current line above to the specified count',
        },
    },
}

return require('which-key').add(require('r.utils.maps').convert_maps(maps))
