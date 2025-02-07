local register = {}
local aucmd = vim.api.nvim_create_autocmd

local function task_map(key, task, desc, buf)
    return function()
        vim.keymap.set('n', key, function()
            require('overseer').run_template(task)
        end, { desc = desc, buffer = buf })
    end
end

function register.repl(id)
    aucmd('FileType', {
        group = id,
        pattern = { 'lua', 'python', 'javascript' },
        callback = function(args)
            task_map('<F5>', 'Run Single', 'Call native compile command', args.buf)
        end,
        desc = 'set compiler and toggleable REPL for capable filetypes',
    })
end

function register.LiveServer(id)
    aucmd('FileType', {
        group = id,
        pattern = { 'css', 'html', 'javascript' },
        callback = function(args)
            task_map('<F6>', 'Live server', 'Launch in browser', args.buf)
        end,
        desc = 'Create Live Server bindings',
    })
end

function register.glow(id)
    aucmd('FileType', {
        group = id,
        pattern = 'markdown',
        callback = function(args)
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

            vim.keymap.set('n', '<F5>', start_task, { buffer = args.buf, desc = 'Run glow' })
        end,
        desc = 'Initialize Glow task for Markdown',
    })
end

function register.cpp(id)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp', 'opencl' },
        group = id,
        callback = function()
            local build_config = require 'r.extensions.project.detection'
            build_config.register_handler('Pio', function(bufnr)
                require('r.plugins.tasks.cpp').micro(bufnr)
            end)

            build_config.register_handler('oF', function(bufnr)
                require('r.plugins.tasks.cpp').oF(bufnr)
            end)

            build_config.register_handler('Single', function(bufnr)
                require('r.plugins.tasks.cpp').ctests(bufnr)
            end)

            build_config.register_handler('PD', function(bufnr)
                require('r.plugins.tasks.cpp').pdc(bufnr)
            end)

            build_config.register_handler('CMake', function(bufnr)
                require('r.plugins.tasks.cpp').cmake(bufnr)
            end)

            build_config.register_handler('Unreal', function(bufnr)
                require('r.plugins.tasks.cpp').unreal(bufnr)
            end)
        end,
    })
end

return register
