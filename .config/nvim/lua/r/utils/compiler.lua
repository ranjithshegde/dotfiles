---@diagnostic disable: missing-parameter
local Compiler = {}

local function isFile(file)
    return vim.loop.fs_stat(file) ~= nil
end

-- set default make to Dispatch Make
local function make(args)
    vim.cmd.Make { args = args }
end

-- set default terminal to Dispatch
local function terminal(args)
    vim.cmd.Dispatch { args = args }
end

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function Compiler.set_ctype()
    if isFile "CMakeLists.txt" then
        require("r.mappings.clang").cmake()
        vim.opt.makeprg = "make"
        vim.g.makeFile = "CMakeLists.txt"
        vim.g.debugBin = "build/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.g.cmakeBin = "./build/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.g.cfiles = "src/* include/*"
    elseif isFile "Makefile" then
        require("r.mappings.clang").makeC()
        vim.g.makeFile = "Makefile"
        vim.opt.makeprg = "make"
        vim.g.debugBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "_debug"
        vim.g.embin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".html"
        vim.g.cfiles = "src/*"
    elseif isFile "platformio.ini" then
        vim.opt.makeprg = "pio run"
        require("r.mappings.clang").micro()
        vim.g.makeFile = "platformio.ini"
    elseif isFile "build.gradle" then
        require("r.mappings.clang").makeGradle()
        vim.g.makeFile = "build.gradle"
        vim.opt.makeprg = "./gradlew"
    else
        vim.opt.makeprg = "g++"
        require("r.mappings.clang").ctests()
        vim.g.debugBin = vim.fn.expand "%<"
        vim.g.cfiles = "%"
    end
end

function Compiler.set_type()
    if isFile "Makefile.pdlibbuilder" then
        require("r.mappings.clang").pdc()
    elseif isFile "Makefile" then
        require("r.mappings.clang").makeC()
        vim.opt.makeprg = "make"
        vim.g.makeFile = "Makefile"
    else
        vim.opt.makeprg = "gcc"
        require("r.mappings.clang").ctests()
        vim.g.debugBin = vim.fn.expand "%<"
    end
end

------------------------------------------------------------------------
--                                Cpp Setup	                          --
------------------------------------------------------------------------

---Search Cplusplus.com for symbol
function Compiler.creference(cmd)
    local url = "https://www.cplusplus.com/search.do?q=" .. cmd
    require("r.utils").open_in_browser(url)
end

---Search OpenGL reference manual for symbol
function Compiler.glRef(cmd)
    local url = "https://docs.gl/gl4/" .. cmd
    require("r.utils").open_in_browser(url)
end

-- open Makefile
function Compiler.makefile(file)
    vim.cmd.tabnew(file)
end

-- Launch debuger
function Compiler.termdebug()
    require("r.debugger").init()
    require("dap").continue()
end

function Compiler.ctags(files)
    terminal { "ctagInc", files }
end

function Compiler.pdBuild()
    local bin = vim.fn.fnamemodify(vim.loop.cwd(), ":t") .. ".pd_linux"
    local dest = "~/.local/lib/pd/extra/"
    terminal { "cp", bin, dest }
end

function Compiler.with_flags()
    vim.ui.input({
        prompt = "Enter compiler flags: ",
    }, function(input)
        local cmd = { "-g", "-o", "%<", "%" }
        if input and input ~= "" then
            local flags = vim.split(input, " ")
            for i, v in ipairs(flags) do
                flags[i] = "-l" .. v
            end
            vim.list_extend(cmd, flags)
        end
        make(cmd)
    end)
end

function Compiler.renderOffload(dispatch, cmd, toSave)
    if toSave then
        vim.cmd.redraw()
        vim.cmd.write()
    end
    vim.ui.select(
        { "Integrated graphics", "Dedicated (Nvidia) Graphics" },
        { prompt = "Run the binary on: " },
        function(choice)
            if choice ~= "Integrated graphics" then
                table.insert(dispatch, 1, "prime-run")
            end
            if cmd then
                table.insert(dispatch, 1, "&&")
                table.insert(dispatch, 1, cmd)
                make(dispatch)
            else
                terminal(dispatch)
            end
        end
    )
end

-- Get gcc libs for completion
function Compiler.gcc_libs(arg)
    local comp = {}

    for _, v in ipairs(vim.split(tostring(vim.env.LIBRARY_PATH), ":")) do
        local files = vim.split(vim.fn.system("ls " .. v), "\n")
        local libs = {}
        for _, c in ipairs(files) do
            if string.find(c, "%.so.*") then
                local temp = string.gsub(c, "lib", ""):gsub("%..*", "")
                table.insert(libs, temp)
            end
        end
        vim.list_extend(comp, libs)
    end

    local arg_comp = {}
    for _, v in ipairs(comp) do
        if string.match(v, arg) then
            table.insert(arg_comp, v)
        end
    end

    if vim.tbl_isempty(arg_comp) then
        return arg_comp
    end
    return comp
end

function Compiler.emmake()
    terminal { "emmake", "make", "-j12" }
end

function Compiler.emrun()
    terminal { "emrun", "--browser", "brave", vim.g.embin }
end
------------------------------------------------------------------------
--                                CMake 	                          --
------------------------------------------------------------------------

-- Variables
vim.g.cmake_flags_extra = "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
vim.g.cmake_vcpkg_args = "-DCMAKE_TOOLCHAIN_FILE='/opt/vcpkg/scripts/buildsystems/vcpkg.cmake'"
vim.g.cmake_build_dir = "build"
vim.g.compiledb = { "ln", "-s", "build/compile_commands.json", "." }

-- Cmake generate
function Compiler.cmake_gen(type)
    if not type then
        type = "Release"
    end
    terminal {
        "cmake",
        "-DCMAKE_BUILD_TYPE=" .. type,
        vim.g.cmake_flags_extra,
        vim.g.cmake_vcpkg_args,
        "-B",
        vim.g.cmake_build_dir,
        "-S",
        ".",
        ";",
        unpack(vim.g.compiledb),
    }
end

-- Clean amd remove build dir
function Compiler.cmake_clean()
    require("r.utils").silent_shell { "rm", "-r", vim.g.cmake_build_dir }
    require("r.utils").silent_shell { "rm", "compile_commands.json" }
end

-- Clean and rebuild Release
function Compiler.cmake_clean_gen()
    Compiler.cmake_clean()
    Compiler.cmake_gen "Release"
end

-- Clean and rebuild debug
function Compiler.cmake_clean_gen_debug()
    Compiler.cmake_clean()
    Compiler.cmake_gen "Debug"
end

-- Run the binary
function Compiler.cmake_run()
    local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    terminal { "./build/" .. bin }
end

-- Cmake Install
function Compiler.cmake_install()
    terminal { "cmake", "--build", vim.g.cmake_build_dir, "--config", "Release", "--target", "install" }
end

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
------------------------------------------------------------------------

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function Compiler.lines_from(file)
    if not isFile(file) then
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
    require("r.utils.extensions").toggleTerm(cmd, "pio")
end

-- Clean directory
function Compiler.pio_clean()
    make { "-t", "clean" }
    make { "-t", "compiledb" }
end

-- check directory
function Compiler.pio_check()
    terminal { "pio", "check", "--skip-packages" }
end

function Compiler.teensypins()
    local url = "https://www.pjrc.com/teensy/pinout.html"
    require("r.utils").open_in_browser(url)
end

function Compiler.teensyspecs()
    local url = "https://www.pjrc.com/teensy/techspecs.html"
    require("r.utils").open_in_browser(url)
end

function Compiler.arduinoref()
    local url = "https://www.arduino.cc/reference/en/"
    require("r.utils").open_in_browser(url)
end

function Compiler.ardRef(cmd)
    local url = "https://search.arduino.cc/search?tab=reference&q=" .. cmd
    require("r.utils").open_in_browser(url)
end

return Compiler
