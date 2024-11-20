local register = {}
local aucmd = vim.api.nvim_create_autocmd

local function task_map(key, task, desc, buf)
    return function()
        vim.keymap.set('n', key, function()
            require('overseer').run_template(task)
        end, { desc = desc, buffer = buf })
    end
end

local function sequencer(name_1, params, name_2)
    require('overseer').run_template({ name = name_1, params = params, autostart = false }, function(task)
        if task then
            task:add_component {
                'dependencies',
                task_names = {
                    name_2,
                },
                sequential = true,
            }
            task:start()
        end
    end)
end

function register.repl(id)
    aucmd('FileType', {
        group = id,
        pattern = { 'java', 'lua', 'python', 'javascript', 'perl' },
        callback = function(args)
            task_map('<F5>', 'Run Single', 'Call native compile command', args.buf)

            vim.keymap.set({ 'n', 't' }, '<F10>', function()
                vim.cmd.stopinsert()
                require('r.extensions').toggleTerm(vim.b.repl, 'repl')
            end, { desc = 'Toggle REPL' })
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

function register.flutter(id)
    aucmd('FileType', {
        group = id,
        pattern = 'dart',
        callback = function(args)
            vim.b.make = 'dart'

            task_map('<F6>', 'Flutter run', 'Run Flutter', args.buf)
            task_map('<F6>', 'Run Single', 'Run single file', args.buf)

            vim.keymap.set('n', '<F5>', function()
                vim.ui.select(
                    { 'aar', 'apk', 'appbundle', 'bundle', 'web' },
                    { prompt = 'Compile flutter for: ' },
                    function(choice)
                        require('overseer').run_template { name = 'Flutter build', params = { env = choice } }
                    end
                )
            end, { desc = 'Build Flutter', buffer = args.buf })
        end,
        desc = 'Initialize build tasks for Dart',
    })
end

local cpp = {}

------------------------------------------------------------------------
--                                Cpp    	                          --
------------------------------------------------------------------------

-- Build puredata externals
function cpp.pdBuild()
    local bin = vim.fn.fnamemodify(vim.uv.cwd(), ':t') .. '.pd_linux'
    local dest = '~/.local/lib/pd/extra/'
    vim.cmd.OverseerRunCmd { args = { 'cp', bin, dest } }
end

-- Single file gcc/clang with flags
function cpp.with_flags()
    vim.ui.input({
        prompt = 'Enter compiler flags: ',
    }, function(input)
        require('overseer').run_template { name = 'Compile', params = { flags = vim.split(input, ' ') } }
    end)
end

-- Run make compiled binary with Prime render offload
function cpp.renderOffload(cmd)
    vim.ui.select({ 'Integrated graphics', 'Dedicated Graphics' }, { prompt = 'Run the binary on: ' }, function(choice)
        local dGPU = false
        if choice ~= 'Integrated graphics' then
            dGPU = true
        end
        if cmd then
            sequencer('oF Run', { dGPU = dGPU }, 'oF Build')
        else
            require('overseer').run_template { name = [[oF Run]], params = { dGPU = dGPU } }
        end
    end)
end

-- Clean and rebuild Release
function cpp.cmake_clean_gen()
    sequencer('Cmake Configure', { type = 'Release' }, 'Cmake clean')
end

-- Clean and rebuild debug
function cpp.cmake_clean_gen_debug()
    sequencer('Cmake Configure', { type = 'Debug' }, 'Cmake clean')
end

-- Clean pio directory
function cpp.pio_clean()
    sequencer('pio compiledb', {}, 'pio clean')
end

-- return cpp
setmetatable(register, { __index = cpp })

return register
