local u = require "utils"

local Compiler = {}

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function Compiler.set_ctype()
    if Compiler.has_Cmake() then
        require("mappings").cmake()
        G.makeFile = "CMakeLists.txt"
        G.debugBin = "build/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    elseif Compiler.has_makefile() then
        require("mappings").makeC()
        G.makeFile = "Makefile"
        G.debugBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "_debug"
    elseif Compiler.has_pio_file() then
        Exec "set makeprg=pio\\ run"
        -- require("settings").smbc()
        require("mappings").smbc()
        G.makeFile = "platformio.ini"
    elseif Compiler.has_gradle() then
        require("mappings").makeGradle()
        G.makeFile = "build.gradle"
        Exec "set makeprg=./gradlew"
        -- G.debugBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "_debug"
    else
        Exec "set makeprg=g++"
        require("mappings").ctests()
        G.debugBin = "%<"
    end
end

function Compiler.set_type()
    if Compiler.has_makefile() then
        require("mappings").pdc()
    else
        Exec "set makeprg=gcc"
        require("mappings").ctests()
        G.debugBin = "%<"
    end
end

-- basic setup for small test files
function Compiler.cpractice()
    local dir = vim.fn.input "enter directory name: "
    vim.fn.execute("!mkdir -p $CWORK/Practice/" .. dir)
    vim.fn.execute("cd $CWORK/Practice/" .. dir)
    local file = vim.fn.input "enter file name: "
    Exec("e " .. file .. ".cpp")
end

function Compiler.cproject()
    local dir = vim.fn.input "enter directory name: "
    vim.fn.execute("!mkdir -p $CWORK/" .. dir)
    vim.fn.execute("cd $CWORK/" .. dir)
    vim.fn.termopen "projectCreate -g"
end

------------------------------------------------------------------------
--                                Cpp Setup	                          --
------------------------------------------------------------------------

-- Search Cplusplus.com for symbol
function Compiler.creference(cmd)
    local url = "https://www.cplusplus.com/search.do?q=" .. cmd
    Exec('!qutebrowser "' .. url .. '" &')
end

-- check if project has a Makefile
function Compiler.has_makefile()
    local name = "Makefile"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Check of its ofAndroid project
function Compiler.has_gradle()
    local name = "build.gradle"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function Compiler.has_pd()
    local name = "Makefile.pdlibbuilder"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end
-- set default make to Dispatch Make
function Compiler.make(cmd)
    Exec("Make " .. cmd)
end

-- set default terminal to Dispatch
function Compiler.terminal(cmd)
    Exec("Dispatch " .. cmd)
end

-- set alternate terminal to native terminal
function Compiler.newTerm(cmd, opencmd)
    Exec(opencmd or "new")
    Exec("terminal " .. cmd)
end

-- open Makefile
function Compiler.makefile(file)
    Exec("tabnew " .. file)
end

-- Launch debuger
function Compiler.termdebug()
    Exec "packadd termdebug"
    require("mappings").debug()
    local cmd = "Termdebug " .. G.debugBin
    Exec(cmd)
end

function Compiler.pdBuild()
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local dest = "~/.local/lib/pd/extra/"
    Compiler.terminal("\\cp " .. bin .. ".pd_linux " .. dest)
end

------------------------------------------------------------------------
--                                CMake 	                          --
------------------------------------------------------------------------

-- Variables
G.extra_cmake_flags = "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
G.cmake_build_dir = "build"
G.compiledb = "ln -s build/compile_commands.json ."

-- check if project has a CMakefile
function Compiler.has_Cmake()
    local name = "CMakeLists.txt"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Cmake generate
function Compiler.cmake_gen()
    Compiler.terminal(
        "mkdir build; cmake -DCMAKE_BUILD_TYPE='Release' "
            .. G.extra_cmake_flags
            .. " -B "
            .. G.cmake_build_dir
            .. " -S ."
            .. ";"
            .. G.compiledb
    )
end

-- Cmake generate debug
function Compiler.cmake_gen_debug()
    Compiler.terminal(
        "mkdir build; cmake -DCMAKE_BUILD_TYPE='Debug' "
            .. G.extra_cmake_flags
            .. " -B "
            .. G.cmake_build_dir
            .. " -S ."
            .. ";"
            .. G.compiledb
    )
end

-- Clean amd remove build dir
function Compiler.cmake_clean()
    Compiler.terminal("rm -r " .. G.cmake_build_dir .. ";" .. "rm compile_commands.json")
end

-- Clean and rebuild Release
function Compiler.cmake_clean_gen()
    Compiler.cmake_clean()
    Compiler.cmake_gen()
end

-- Clean and rebuild debug
function Compiler.cmake_clean_gen_debug()
    Compiler.cmake_clean()
    Compiler.cmake_gen_debug()
end

-- Run the binary
function Compiler.cmake_run()
    -- local bin = Api.nvim_call_function('fnamemodify', {'.', ":p:h:t"})
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    Compiler.terminal("./build/" .. bin)
end

-- Cmake Install
function Compiler.cmake_install()
    Compiler.newTerm("cmake --build " .. G.cmake_build_dir .. " --config Release --target install")
end

-----------------------------------------------------------------------
--                                SMBC  	                          --
------------------------------------------------------------------------

function Compiler.compiletags()
    local create_tags_cmd = "-t compiledb"
    local controllers = Compiler.pio_env()
    Compiler.make(create_tags_cmd)
    -- Just choose the first controller in environment list
    Compiler.linktags(controllers[1])
end

-- This is a dirty hack for LSP. There must be a nicer way of doing this. Right?
function Compiler.linktags(microcontroller)
    local board = microcontroller or "teensy31"
    local link_cmd = "ln -sf .pio/build/" .. board .. "/compile_commands.json ."
    u.silent_shell(link_cmd)
end

-- Check if there is a platformio init file in root
function Compiler.has_pio_file()
    local name = "platformio.ini"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function Compiler.lines_from(file)
    if not Compiler.has_pio_file() then
        return {}
    end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- Found out which controllers are defined in the pio file
function Compiler.pio_env()
    -- lua match pattern for the pattern [env:name_of_controller] pattern
    local search_pattern = "%[env:%w*%]"
    local result = {}
    -- Check for platformio.ini file in root
    if Compiler.has_pio_file() then
        local lines = Compiler.lines_from "platformio.ini"
        for i = 1, #lines do
            local search = lines[i]:match(search_pattern)
            if search ~= nil then
                -- Remove beginning of tag
                search = string.gsub(search, "%[env:", "")
                -- Remove end of tag
                search = string.gsub(search, "%]", "")
                -- Leaving only a word:
                result[#result + 1] = search
            end
        end

        return result
    end
end

-- print the board being compiled for
function Compiler.print_env()
    local env = Compiler.pio_env()
    print "Controllers defined in this platformio project:"
    for name = 1, #env do
        print(env[name])
    end
end

-- print serial monitor
function Compiler.monitor()
    local cmd = "pio device monitor"
    u.toggleTerm(cmd, "pio", 0)
end

-- Clean directory
function Compiler.pio_clean()
    local cmd = "pio -t clean"
    Compiler.terminal(cmd)
end

-- check directory
function Compiler.pio_check()
    local cmd = "pio check --skip-packages"
    Compiler.terminal(cmd)
end

function Compiler.teensypins()
    local url = "https://www.pjrc.com/teensy/pinout.html"
    u.open_in_browser(url)
end

function Compiler.teensyspecs()
    local url = "https://www.pjrc.com/teensy/techspecs.html"
    u.open_in_browser(url)
end

function Compiler.arduinoref()
    local url = "https://www.arduino.cc/reference/en/"
    u.open_in_browser(url)
end

return Compiler
