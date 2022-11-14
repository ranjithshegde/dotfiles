vim.bo.tabstop = 2
vim.o.textwidth = 80

local task = nil
local function start_task()
    if task == nil then
        task = require('overseer').new_task {
            cmd = { 'glow' },
            args = { vim.fn.expand '%' },
            components = { 'default', 'unique' },
        }
    end
    task:start()
end

vim.keymap.set('n', '<F5>', start_task, { buffer = true, desc = 'Run glow' })
