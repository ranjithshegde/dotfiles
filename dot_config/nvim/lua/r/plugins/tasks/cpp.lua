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

------------------------------------------------------------------------
--                                Cpp    	                          --
------------------------------------------------------------------------

-- Build puredata externals
local function pdBuild()
    local bin = vim.fn.fnamemodify(vim.uv.cwd(), ':t') .. '.pd_linux'
    local dest = '~/.local/lib/pd/extra/'
    vim.cmd.OverseerRunCmd { args = { 'cp', bin, dest } }
end

-- Single file gcc/clang with flags
local function with_flags()
    vim.ui.input({
        prompt = 'Enter compiler flags: ',
    }, function(input)
        require('overseer').run_template { name = 'Compile', params = { flags = vim.split(input, ' ') } }
    end)
end

-- Run make compiled binary with Prime render offload
local function renderOffload(cmd)
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

-- Clean pio directory
local function pio_clean()
    sequencer('pio compiledb', {}, 'pio clean')
end

local tasks = {}

local map = vim.keymap.set

------------------------------------------------------------------------
--                              Arduino                               --
------------------------------------------------------------------------

function tasks.micro(bufnr)
    --Shift F9
    map({ 'n', 't' }, '<F21>', function()
        vim.cmd.stopinsert()
        require('r.extensions').toggleTerm('pio device monitor', 'pio')
    end, { desc = 'Serial monitor toggle' })

    map('n', '<F3>', pio_clean, { buffer = bufnr, desc = 'Regenerate tags' })

    map('n', '<F4>', function()
        require('overseer').run_template { name = 'pio check --skip-packages' }
    end, { buffer = bufnr, desc = 'Verify code' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'pio run' }
    end, { buffer = bufnr, desc = 'Build' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'pio upload' }
    end, { buffer = bufnr, desc = 'Upload' })
end

------------------------------------------------------------------------
--                              OpenFrameworks                        --
------------------------------------------------------------------------

function tasks.oF(bufnr)
    map('n', '<F3>', function()
        require('overseer').run_template { name = [[Build wasm]] }
    end, { buffer = bufnr, desc = 'Compile Emscripten' })

    map('n', '<F4>', function()
        require('overseer').run_template { name = [[Deploy wasm]] }
    end, { buffer = bufnr, desc = 'Run Emscripten' })

    map('n', '<F5>', function()
        renderOffload(true)
    end, { buffer = bufnr, desc = 'Compile and Run Release' })

    map('n', '<F6>', renderOffload, { buffer = bufnr, desc = 'Run Release' })

    -- Shift F5
    map('n', '<F17>', function()
        require('overseer').run_template { name = [[oF Build]], params = { type = 'Debug' } }
    end, { buffer = bufnr, desc = 'Compile Debug' })
end

------------------------------------------------------------------------
--                              General cpp mappings                  --
------------------------------------------------------------------------

-- ******************************** C files ----------------------------
function tasks.ctests(bufnr)
    map('n', '<F4>', with_flags, { buffer = bufnr, desc = 'Make with defined flags' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'Compile' }
    end, { buffer = bufnr, desc = 'Make & launch' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'Run' }
    end, { buffer = bufnr, desc = 'Launch binary' })
end

-- ******************************** Pd externals ------------------------
function tasks.pdc(bufnr)
    map('n', '<F5>', function()
        require('overseer').run_template { name = 'make' }
    end, { buffer = bufnr, desc = 'Build Pd external' })

    map('n', '<F6>', pdBuild, { buffer = bufnr, desc = 'Copy external to PD directory' })
end

------------------------------------------------------------------------
--                              Cmake                                 --
------------------------------------------------------------------------

function tasks.cmake(bufnr)
    map('n', '<F3>', function()
        require('overseer').run_template { name = 'Cmake clean' }
    end, { buffer = bufnr, desc = 'Clean cmake' })

    map('n', '<F4>', function()
        require('overseer').run_template { name = 'Cmake configure', params = { type = 'Debug' } }
    end, { buffer = bufnr, desc = 'Generate Cmake Debug' })

    -- Shift F4
    map('n', '<F16>', function()
        require('overseer').run_template { name = 'Cmake configure', params = { type = 'Release' } }
    end, { buffer = bufnr, desc = 'Generate Cmake Release' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'Cmake Build' }
    end, { buffer = bufnr, desc = 'Make' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'Cmake Run', params = { dGPU = false } }
    end, { buffer = bufnr, desc = 'Launch binary' })
end

function tasks.mayaflux(bufnr)
    map('n', '<F3>', function()
        require('overseer').run_template { name = 'Mayaflux clean' }
    end, { buffer = bufnr, desc = 'Mayaflux: Clean build artifacts' })

    map('n', '<F4>', function()
        require('overseer').run_template {
            name = 'Mayaflux configure',
        }
    end, { buffer = bufnr, desc = 'Mayaflux: Configure (Ninja + MAYAFLUX_DEV=ON)' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'Mayaflux Build' }
    end, { buffer = bufnr, desc = 'Mayaflux: Build (cmake --build --parallel)' })

    map('n', '<F6>', function()
        require('overseer').run_template {
            name = 'Mayaflux Run',
        }
    end, { buffer = bufnr, desc = 'Mayaflux: Run project_launcher' })
end

function tasks.unreal(bufnr)
    map('n', '<F3>', function()
        require('overseer').run_template { name = 'generate compile_commands.json' }
    end, { buffer = bufnr, desc = 'Re/Generate clangd and ccls project files' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'UnrealEditor' }
    end, { buffer = bufnr, desc = 'Launch Unreal Editor for current project' })
end

return tasks
