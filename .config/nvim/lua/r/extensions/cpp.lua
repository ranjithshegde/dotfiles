local clang = {}

local function isFile(file)
    return vim.uv.fs_stat(file) ~= nil
end

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function clang.set_cpptype()
    local dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local unreal_file = dirname .. '.uproject'

    if isFile(unreal_file) then
        vim.b.makeprg = '/opt/unreal-engine/Engine/Build/BatchFiles/Linux/Build.sh'
        vim.b.unreal_dir = dirname
        vim.b.cpp_type = 'Unreal'
    elseif isFile 'CMakeLists.txt' then
        require('r.plugins.tasks.mappings').cmake()
        vim.bo.makeprg = 'make'
        vim.b.makeFile = 'CMakeLists.txt'
        vim.b.debugBin = 'build/' .. dirname
        vim.b.cpp_type = 'CMake'
    elseif isFile 'Makefile' then
        vim.b.makeFile = 'Makefile'
        vim.bo.makeprg = 'make'
        if isFile(dirname .. '.qbs') or isFile 'config.make' or isFile 'addons.make' then
            require('r.plugins.tasks.mappings').oF()
            vim.b.makeBin = 'bin/' .. dirname
            vim.b.debugBin = 'bin/' .. dirname .. '_debug'
            vim.b.wasm = 'bin/' .. dirname .. '.html'
            vim.b.cpp_type = 'oF'
        else
            vim.b.cpp_type = 'Make'
        end
    elseif isFile 'platformio.ini' then
        vim.bo.makeprg = 'pio run'
        require('r.plugins.tasks.mappings').micro()
        vim.b.makeFile = 'platformio.ini'
        vim.b.cpp_type = 'Pio'
    elseif isFile 'build.gradle' then
        require('r.plugins.tasks.mappings').makeGradle()
        vim.b.makeFile = 'build.gradle'
        vim.bo.makeprg = './gradlew'
        vim.b.cpp_type = 'CDroid'
    else
        vim.bo.makeprg = vim.g.is_win32 and 'clang++' or 'g++'
        require('r.plugins.tasks.mappings').ctests()
        vim.b.debugBin = vim.fn.expand '%<'
        vim.b.cpp_type = 'Single'
    end
end

function clang.set_ctype()
    if isFile 'Makefile.pdlibbuilder' then
        require('r.plugins.tasks.mappings').pdc()
        vim.b.c_type = 'PD'
    elseif isFile 'Makefile' then
        require('r.plugins.tasks.mappings').makeC()
        vim.bo.makeprg = 'make'
        vim.b.makeFile = 'Makefile'
        vim.b.c_type = 'Make'
    else
        vim.bo.makeprg = vim.g.is_win32 and 'clang' or 'gcc'
        require('r.plugins.tasks.mappings').ctests()
        vim.b.debugBin = vim.fn.expand '%<'
        vim.b.c_type = 'Single'
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

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
------------------------------------------------------------------------

-- print serial monitor
function clang.monitor()
    local cmd = 'pio device monitor'
    require('r.extensions').toggleTerm(cmd, 'pio')
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
