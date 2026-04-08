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
                local cmake_file = vim.fn.getcwd() .. '/CMakeLists.txt'
                local is_maya_flux = false
                local lines = vim.fn.readfile(cmake_file)
                for _, line in ipairs(lines) do
                    local cleaned = line:gsub('#.*', ''):gsub('%s+', ' ')
                    local proj = cleaned:match 'project%s*%(%s*([%w_]+)'
                    if proj and proj:lower() == 'mayaflux' then
                        is_maya_flux = true
                        break
                    end
                end

                if is_maya_flux then
                    require('r.plugins.tasks.cpp').mayaflux(bufnr)
                else
                    require('r.plugins.tasks.cpp').cmake(bufnr)
                end
            end)

            build_config.register_handler('Unreal', function(bufnr)
                require('r.plugins.tasks.cpp').unreal(bufnr)
            end)
        end,
    })
end

function register.init()
    local map = vim.keymap.set
    local id = { Overseer = vim.api.nvim_create_augroup('Overseer', { clear = true }) }

    require('r.plugins.tasks.register').cpp(id.Overseer)
    require('r.plugins.tasks.register').repl(id.Overseer)
    require('r.plugins.tasks.register').LiveServer(id.Overseer)
    require('r.plugins.tasks.register').glow(id.Overseer)

    local cached_ft = nil
    local get_ft = function()
        if cached_ft then
            return cached_ft
        end
        cached_ft = require('r.utils.tables').lspfiles
        table.insert(cached_ft, 'OverseerList')
        return cached_ft
    end

    vim.api.nvim_create_autocmd('FileType', {
        group = id.Overseer,
        pattern = get_ft(),
        callback = function(args)
            map('n', '<F1>', function()
                require('overseer').window.toggle { enter = false, direction = 'left' }
            end, { desc = 'Open Task panel', buffer = args.buf })
        end,
    })

    require('r.utils').register_au_id(id)

    map('n', '<leader>c', function()
        require('overseer').run_template()
    end, { desc = 'Run task  with Overseer' })

    map('n', '<leader>C', function()
        require('overseer').run_template { name = 'shell' }
    end, { desc = 'Run quick command with Overseer' })
end

return register
