local taskmap = {}

local map = vim.keymap.set
local wk = require 'which-key'

------------------------------------------------------------------------
--                              Arduino                               --
------------------------------------------------------------------------

function taskmap.micro()
    map({ 'n', 't' }, '<F8>', function()
        vim.cmd.stopinsert()
        require('r.extensions.cpp').monitor()
    end, { desc = 'Serial monitor toggle' })

    map('n', '<F2>', require('r.plugins.tasks.register').pio_clean, { buffer = true, desc = 'Regenerate tags' })

    map('n', '<F3>', function()
        require('overseer').run_template { name = 'pio check --skip-packages' }
    end, { buffer = true, desc = 'Verify code' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'pio run' }
    end, { buffer = true, desc = 'Build' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'pio upload' }
    end, { buffer = true, desc = 'Upload' })

    map('n', ',ka', function()
        require('r.extensions.cpp').ardRef(vim.fn.expand '<cword>')
    end, { buffer = true, desc = 'Arduino' })

    map('n', ',kt', require('r.extensions.cpp').teensypins, { buffer = true, desc = 'teensy pins' })
    map('n', ',kT', require('r.extensions.cpp').teensyspecs, { buffer = true, desc = 'teensy specs' })

    wk.add {
        { ',k', group = 'Arduino documentation', buffer = 0 },
    }
end

------------------------------------------------------------------------
--                              OpenFrameworks                        --
------------------------------------------------------------------------

function taskmap.oF()
    map('n', '<F2>', function()
        require('overseer').run_template { name = [[Build wasm]] }
    end, { buffer = true, desc = 'Compile Emscripten' })

    map('n', '<F3>', function()
        require('overseer').run_template { name = [[Deploy wasm]] }
    end, { buffer = true, desc = 'Run Emscripten' })

    map('n', '<F4>', function()
        require('overseer').run_template { name = [[oF Build]], params = { type = 'Debug' } }
    end, { buffer = true, desc = 'Compile Debug' })

    map('n', '<F5>', function()
        require('r.plugins.tasks.register').renderOffload(true)
    end, { buffer = true, desc = 'Compile and Run Release' })

    map('n', '<F6>', function()
        require('r.plugins.tasks.register').renderOffload()
    end, { buffer = true, desc = 'Run Release' })
end

------------------------------------------------------------------------
--                              General cpp mappings                  --
------------------------------------------------------------------------

-- ******************************** C files ----------------------------
function taskmap.ctests()
    map('n', '<F4>', function()
        require('r.plugins.tasks.register').with_flags()
    end, { buffer = true, desc = 'Make with defined flags' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'Compile' }
    end, { buffer = true, desc = 'Make & launch' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'Run' }
    end, { buffer = true, desc = 'Launch binary' })
end

-- ******************************** Pd externals ------------------------
function taskmap.pdc()
    map('n', '<F5>', function()
        require('overseer').run_template { name = 'make' }
    end, { buffer = true, desc = 'Build Pd external' })

    map(
        'n',
        '<F6>',
        require('r.plugins.tasks.register').pdBuild,
        { buffer = true, desc = 'Copy external to PD directory' }
    )
end

------------------------------------------------------------------------
--                              Cmake                                 --
------------------------------------------------------------------------

function taskmap.cmake()
    map('n', '<F2>', function()
        require('overseer').run_template { name = 'Cmake clean' }
    end, { buffer = true, desc = 'Clean cmake' })

    map('n', '<F3>', function()
        require('overseer').run_template { name = 'Cmake configure', params = { type = 'Debug' } }
    end, { buffer = true, desc = 'Generate Cmake Debug' })

    map('n', '<F4>', function()
        require('overseer').run_template { name = 'Cmake configure', params = { type = 'Release' } }
    end, { buffer = true, desc = 'Generate Cmake Release' })

    map('n', '<F5>', function()
        require('overseer').run_template { name = 'Cmake Build' }
    end, { buffer = true, desc = 'Make' })

    map('n', '<F6>', function()
        require('overseer').run_template { name = 'Cmake Run', params = { dGPU = false } }
    end, { buffer = true, desc = 'Launch binary' })
end

return taskmap
