---@diagnostic disable: missing-parameter
local Compiler = {}

local function isFile(file)
    return vim.loop.fs_stat(file) ~= nil
end

local function sequencer(name_1, params, name_2)
    require("overseer").run_template({ name = name_1, params = params, autostart = false }, function(task)
        if task then
            task:add_component {
                "dependencies",
                task_names = {
                    name_2,
                },
                sequential = true,
            }
            task:start()
        end
    end)
end

local function loader(callback, args)
    if not package.loaded.overseer then
        callback(args)
    end
end

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function Compiler.set_ctype()
    if isFile "CMakeLists.txt" then
        require("r.mappings.clang").cmake()
        vim.opt.makeprg = "make"
        vim.b.makeFile = "CMakeLists.txt"
        vim.b.debugBin = "build/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    elseif isFile "Makefile" then
        require("r.mappings.clang").makeC()
        vim.b.makeFile = "Makefile"
        vim.opt.makeprg = "make"
        vim.b.makeBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        vim.b.debugBin = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "_debug"
        vim.b.wasm = "bin/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".html"
    elseif isFile "platformio.ini" then
        vim.opt.makeprg = "pio run"
        require("r.mappings.clang").micro()
        vim.b.makeFile = "platformio.ini"
    elseif isFile "build.gradle" then
        require("r.mappings.clang").makeGradle()
        vim.b.makeFile = "build.gradle"
        vim.opt.makeprg = "./gradlew"
    else
        vim.opt.makeprg = "g++"
        require("r.mappings.clang").ctests()
        vim.b.debugBin = vim.fn.expand "%<"
    end
end

function Compiler.set_type()
    if isFile "Makefile.pdlibbuilder" then
        require("r.mappings.clang").pdc()
    elseif isFile "Makefile" then
        require("r.mappings.clang").makeC()
        vim.opt.makeprg = "make"
        vim.b.makeFile = "Makefile"
    else
        vim.opt.makeprg = "gcc"
        require("r.mappings.clang").ctests()
        vim.b.debugBin = vim.fn.expand "%<"
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

-- Launch debuger
function Compiler.termdebug()
    require("r.debugger").init()
    require("dap").continue()
end

function Compiler.pdBuild()
    local bin = vim.fn.fnamemodify(vim.loop.cwd(), ":t") .. ".pd_linux"
    local dest = "~/.local/lib/pd/extra/"
    if not package.loaded.overseer then
        require("packer").loader "overseer.nvim"
    end
    vim.cmd.OverseerRunCmd { args = { "cp", bin, dest } }
end

function Compiler.with_flags()
    vim.ui.input({
        prompt = "Enter compiler flags: ",
    }, function(input)
        require("overseer").run_template { name = "Compile", params = { flags = vim.split(input, " ") } }
    end)
end

function Compiler.renderOffload(cmd)
    vim.ui.select(
        { "Integrated graphics", "Dedicated (Nvidia) Graphics" },
        { prompt = "Run the binary on: " },
        function(choice)
            local dGPU = false
            if choice ~= "Integrated graphics" then
                dGPU = true
            end
            if cmd then
                sequencer("oF Run", { dGPU = dGPU }, "oF Build")
            else
                require("overseer").run_template { name = [[oF Run]], params = { dGPU = dGPU } }
            end
        end
    )
end

------------------------------------------------------------------------
--                                CMake 	                          --
------------------------------------------------------------------------

-- Clean and rebuild Release
function Compiler.cmake_clean_gen()
    sequencer("Cmake Configure", { type = "Release" }, "Cmake clean")
end

-- Clean and rebuild debug
function Compiler.cmake_clean_gen_debug()
    sequencer("Cmake Configure", { type = "Debug" }, "Cmake clean")
end

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
------------------------------------------------------------------------

-- print serial monitor
function Compiler.monitor()
    local cmd = "pio device monitor"
    require("r.utils.extensions").toggleTerm(cmd, "pio")
end

-- Clean directory
function Compiler.pio_clean()
    sequencer("pio compiledb", {}, "pio clean")
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
