local clang = {}

local function isFile(file)
    return vim.loop.fs_stat(file) ~= nil
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

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function clang.set_ctype()
    local dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    if isFile 'CMakeLists.txt' then
        local unreal_file = dirname .. '.uproject'
        if isFile(unreal_file) then
            vim.b.makeprg = '/opt/unreal-engine/Engine/Build/BatchFiles/Linux/Build.sh'
            vim.b.unreal_dir = dirname
        else
            require('r.mappings.clang').cmake()
            vim.bo.makeprg = 'make'
            vim.b.makeFile = 'CMakeLists.txt'
            vim.b.debugBin = 'build/' .. dirname
        end
    elseif isFile 'Makefile' then
        if isFile(dirname .. '.qbs') or isFile 'config.make' or isFile 'addons.make' then
            require('r.mappings.clang').oF()
            vim.b.makeFile = 'Makefile'
            vim.bo.makeprg = 'make'
            vim.b.makeBin = 'bin/' .. dirname
            vim.b.debugBin = 'bin/' .. dirname .. '_debug'
            vim.b.wasm = 'bin/' .. dirname .. '.html'
        end
    elseif isFile 'platformio.ini' then
        vim.bo.makeprg = 'pio run'
        require('r.mappings.clang').micro()
        vim.b.makeFile = 'platformio.ini'
    elseif isFile 'build.gradle' then
        require('r.mappings.clang').makeGradle()
        vim.b.makeFile = 'build.gradle'
        vim.bo.makeprg = './gradlew'
    else
        if vim.fn.has 'win32' == 1 then
            vim.bo.makeprg = 'clang++'
        else
            vim.bo.makeprg = 'g++'
        end
        require('r.mappings.clang').ctests()
        vim.b.debugBin = vim.fn.expand '%<'
    end
end

function clang.set_type()
    if isFile 'Makefile.pdlibbuilder' then
        require('r.mappings.clang').pdc()
    elseif isFile 'Makefile' then
        require('r.mappings.clang').makeC()
        vim.bo.makeprg = 'make'
        vim.b.makeFile = 'Makefile'
    else
        if vim.fn.has 'win32' == 1 then
            vim.bo.makeprg = 'clang'
        else
            vim.bo.makeprg = 'gcc'
        end
        require('r.mappings.clang').ctests()
        vim.b.debugBin = vim.fn.expand '%<'
    end
end

------------------------------------------------------------------------
--                                Cpp Setup	                          --
------------------------------------------------------------------------

---Search Cplusplus.com for symbol
function clang.creference(cmd)
    local url = 'https://www.cplusplus.com/search.do?q=' .. cmd
    require('r.utils').open_in_browser(url)
end

---Search OpenGL reference manual for symbol
function clang.glRef(cmd)
    local url = 'https://docs.gl/gl4/' .. cmd
    require('r.utils').open_in_browser(url)
end

function clang.unRef(cmd)
    local url = 'https://www.unrealengine.com/en-US/bing-search?x=0&y=0&filter=UE4+Documentation&keyword=' .. cmd
    require('r.utils').open_in_browser(url)
end

-- Launch debuger
function clang.termdebug()
    require('r.debuggers').init()
    require('dap').continue()
end

function clang.pdBuild()
    local bin = vim.fn.fnamemodify(vim.loop.cwd(), ':t') .. '.pd_linux'
    local dest = '~/.local/lib/pd/extra/'
    if not package.loaded.overseer then
        require('packer').loader 'overseer.nvim'
    end
    vim.cmd.OverseerRunCmd { args = { 'cp', bin, dest } }
end

function clang.with_flags()
    vim.ui.input({
        prompt = 'Enter compiler flags: ',
    }, function(input)
        require('overseer').run_template { name = 'Compile', params = { flags = vim.split(input, ' ') } }
    end)
end

function clang.renderOffload(cmd)
    vim.ui.select(
        { 'Integrated graphics', 'Dedicated (Nvidia) Graphics' },
        { prompt = 'Run the binary on: ' },
        function(choice)
            local dGPU = false
            if choice ~= 'Integrated graphics' then
                dGPU = true
            end
            if cmd then
                sequencer('oF Run', { dGPU = dGPU }, 'oF Build')
            else
                require('overseer').run_template { name = [[oF Run]], params = { dGPU = dGPU } }
            end
        end
    )
end

------------------------------------------------------------------------
--                                CMake 	                          --
------------------------------------------------------------------------

-- Clean and rebuild Release
function clang.cmake_clean_gen()
    sequencer('Cmake Configure', { type = 'Release' }, 'Cmake clean')
end

-- Clean and rebuild debug
function clang.cmake_clean_gen_debug()
    sequencer('Cmake Configure', { type = 'Debug' }, 'Cmake clean')
end

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
------------------------------------------------------------------------

-- print serial monitor
function clang.monitor()
    local cmd = 'pio device monitor'
    require('r.utils.extensions').toggleTerm(cmd, 'pio')
end

-- Clean directory
function clang.pio_clean()
    sequencer('pio compiledb', {}, 'pio clean')
end

function clang.teensypins()
    local url = 'https://www.pjrc.com/teensy/pinout.html'
    require('r.utils').open_in_browser(url)
end

function clang.teensyspecs()
    local url = 'https://www.pjrc.com/teensy/techspecs.html'
    require('r.utils').open_in_browser(url)
end

function clang.arduinoref()
    local url = 'https://www.arduino.cc/reference/en/'
    require('r.utils').open_in_browser(url)
end

function clang.ardRef(cmd)
    local url = 'https://search.arduino.cc/search?tab=reference&q=' .. cmd
    require('r.utils').open_in_browser(url)
end

return clang
