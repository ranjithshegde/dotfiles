local Compiler = {}
local exec = vim.api.nvim_command

local function isFile(file)
    if vim.loop.fs_stat(file) ~= nil then
        return true
    else
        return false
    end
end

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function Compiler.set_ctype()
    if isFile "CMakeLists.txt" then
        require("mappings.clang").cmake()
        vim.opt.makeprg = "make"
        vim.g.makeFile = "CMakeLists.txt"
        vim.g.debugBin = "build/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.g.cmakeBin = "./build/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.g.cfiles = "src/* include/*"
    elseif isFile "Makefile" then
        require("mappings.clang").makeC()
        vim.g.makeFile = "Makefile"
        vim.g.debugBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "_debug"
        vim.g.cfiles = "src/*"
    elseif isFile "platformio.ini" then
        vim.opt.makeprg = "pio run"
        require("mappings.clang").micro()
        vim.g.makeFile = "platformio.ini"
    elseif isFile "build.gradle" then
        require("mappings.clang").makeGradle()
        vim.g.makeFile = "build.gradle"
        vim.opt.makeprg = "./gradlew"
        -- vim.g.debugBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "_debug"
    else
        vim.opt.makeprg = "g++"
        require("mappings.clang").ctests()
        vim.g.debugBin = vim.fn.expand "%<"
        vim.g.cfiles = "%"
    end
end

function Compiler.set_type()
    if isFile "Makefile" then
        require("mappings.clang").pdc()
    else
        vim.opt.makeprg = "gcc"
        require("mappings.clang").ctests()
        vim.g.debugBin = vim.fn.expand "%<"
    end
end

------------------------------------------------------------------------
--                                Cpp Setup	                          --
------------------------------------------------------------------------

-- Search Cplusplus.com for symbol
function Compiler.creference(cmd)
    local url = "https://www.cplusplus.com/search.do?q=" .. cmd
    require("utils").open_in_browser(url)
end

function Compiler.glRef(cmd)
    local url = "https://docs.gl/gl4/" .. cmd
    require("utils").open_in_browser(url)
end

function Compiler.has_pd()
    return isFile "Makefile.pdlibbuilder"
end
-- set default make to Dispatch Make
function Compiler.make(cmd)
    exec("Make " .. cmd)
end

-- set default terminal to Dispatch
function Compiler.terminal(cmd)
    exec("Dispatch " .. cmd)
end

-- open Makefile
function Compiler.makefile(file)
    exec("tabnew " .. file)
end

-- Launch debuger
function Compiler.termdebug()
    require("debugger").init()
    require("dap").continue()
end

function Compiler.ctags(files)
    local cmd = "ctagInc"
    Compiler.terminal(cmd .. " " .. files)
end

function Compiler.pdBuild()
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local dest = "~/.local/lib/pd/extra/"
    Compiler.terminal("\\cp " .. bin .. ".pd_linux " .. dest)
end

function Compiler.with_flags()
    local flags = vim.fn.input "Enter compiler flags: "
    Compiler.make("-g -o %< " .. flags .. " %")
end

function Compiler.renderOffload(dispatch, cmd, toSave)
    if toSave then
        vim.cmd "redraw"
        vim.cmd "w"
    end
    vim.ui.select(
        { "Integrated graphics", "Dedicated (Nvidia) Graphics" },
        { prompt = "Run the binary on: " },
        function(choice)
            if choice == "Integrated graphics" then
                if cmd then
                    vim.cmd(cmd .. " && " .. dispatch)
                else
                    Compiler.terminal(dispatch)
                end
            else
                if cmd then
                    vim.cmd(cmd .. " && prime-run " .. dispatch)
                else
                    Compiler.terminal("prime-run " .. dispatch)
                end
            end
        end
    )
end
------------------------------------------------------------------------
--                                CMake 	                          --
------------------------------------------------------------------------

-- Variables
vim.g.extra_cmake_flags = "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
vim.g.cmake_build_dir = "build"
vim.g.compiledb = "ln -s build/compile_commands.json ."

-- Cmake generate
function Compiler.cmake_gen()
    Compiler.terminal(
        "mkdir build; cmake -DCMAKE_BUILD_TYPE='Release' "
            .. vim.g.extra_cmake_flags
            .. " -B "
            .. vim.g.cmake_build_dir
            .. " -S ."
            .. ";"
            .. vim.g.compiledb
    )
end

-- Cmake generate debug
function Compiler.cmake_gen_debug()
    Compiler.terminal(
        "mkdir build; cmake -DCMAKE_BUILD_TYPE='Debug' "
            .. vim.g.extra_cmake_flags
            .. " -B "
            .. vim.g.cmake_build_dir
            .. " -S ."
            .. ";"
            .. vim.g.compiledb
    )
end

-- Clean amd remove build dir
function Compiler.cmake_clean()
    Compiler.terminal("rm -r " .. vim.g.cmake_build_dir .. ";" .. "rm compile_commands.json")
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
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    Compiler.terminal("./build/" .. bin)
end

-- Cmake Install
function Compiler.cmake_install()
    Compiler.terminal("cmake --build " .. vim.g.cmake_build_dir .. " --config Release --target install")
end

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
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
    require("utils").silent_shell(link_cmd)
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
    require("utils").toggleTerm(cmd, "pio")
end

-- Clean directory
function Compiler.pio_clean()
    local cmd = "pio run -t clean"
    Compiler.terminal(cmd)
    Compiler.compiletags()
end

-- check directory
function Compiler.pio_check()
    local cmd = "pio check --skip-packages"
    Compiler.terminal(cmd)
end

function Compiler.teensypins()
    local url = "https://www.pjrc.com/teensy/pinout.html"
    require("utils").open_in_browser(url)
end

function Compiler.teensyspecs()
    local url = "https://www.pjrc.com/teensy/techspecs.html"
    require("utils").open_in_browser(url)
end

function Compiler.arduinoref()
    local url = "https://www.arduino.cc/reference/en/"
    require("utils").open_in_browser(url)
end

function Compiler.ardRef(cmd)
    local url = "https://search.arduino.cc/search?tab=reference&q=" .. cmd
    require("utils").open_in_browser(url)
end

return Compiler
