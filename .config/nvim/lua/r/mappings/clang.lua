local cmaps = {}
local wk = require "which-key"
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Arduino                               --
------------------------------------------------------------------------

function cmaps.micro()
    map({ "n", "t" }, "<F8>", function()
        vim.cmd.stopinsert()
        require("r.utils.compiler").monitor()
    end, { desc = "Serial monitor toggle" })
    map("n", "<F2>", require("r.utils.compiler").pio_clean, { buffer = true, desc = "Regenerate tags" })
    map("n", "<F3>", require("r.utils.compiler").pio_check, { buffer = true, desc = "Verify code" })
    map("n", "<F5>", function()
        vim.cmd.w()
        vim.cmd.Make()
    end, { buffer = true, desc = "Build" })
    map("n", "<F6>", function()
        vim.cmd.w()
        vim.cmd.Make "--target upload"
    end, { buffer = true, desc = "Upload" })
    map("n", ",ka", function()
        require("r.utils.compiler").ardRef(vim.fn.expand "<cword>")
    end, { buffer = true, desc = "Arduino" })
    map("n", ",kt", require("r.utils.compiler").teensypins, { buffer = true, desc = "teensy pins" })
    map("n", ",kT", require("r.utils.compiler").teensyspecs, { buffer = true, desc = "teensy specs" })

    wk.register {
        [","] = { k = { "Arduino documentation", buffer = 0 } },
    }
end

------------------------------------------------------------------------
--                              OpenFrameworks                        --
------------------------------------------------------------------------

function cmaps.makeC()
    map("n", "<F2>", require("r.utils.compiler").emmake, { buffer = true, desc = "Compile Emscripten" })
    map("n", "<F3>", require("r.utils.compiler").emrun, { buffer = true, desc = "Run Emscripten" })
    map("n", "<F4>", function()
        vim.cmd.w()
        vim.cmd.Make "Debug -j12"
    end, { buffer = true, desc = "Compile Debug" })
    map("n", "<F5>", function()
        require("r.utils.compiler").renderOffload({ "make", "RunRelease" }, "-j12", true)
    end, { buffer = true, desc = "Compile and Run Release" })
    map("n", "<F6>", function()
        require("r.utils.compiler").renderOffload { "make", "RunRelease" }
    end, { buffer = true, desc = "Run Release" })
end

------------------------------------------------------------------------
--                              General cpp mappings                  --
------------------------------------------------------------------------

-- ******************************** C files ----------------------------
function cmaps.ctests()
    map("n", "<F3>", function()
        vim.cmd.w()
        require("r.utils").ex_cmd("Dispatch", { "gcc", "%", "-lm", "-o", "%<" }, { silent = true }, { file = true })
    end, { buffer = true, desc = "Use gcc" })

    map("n", "<F4>", function()
        vim.cmd.w()
        vim.cmd.redraw()
        require("r.utils.compiler").with_flags()
    end, { buffer = true, desc = "Make with defined flags" })

    map("n", "<F5>", function()
        vim.cmd.w()
        require("r.utils").ex_cmd("Make", { "-g", "%", "-o", "%<", "&&", "./%<" }, { silent = true }, { file = true })
    end, { buffer = true, desc = "Make & launch" })

    map("n", "<F6>", function()
        require("r.utils.compiler").renderOffload { "./%<" }
    end, { buffer = true, desc = "Launch binary" })
end

-- ******************************** Pd externals ------------------------
function cmaps.pdc()
    map("n", "<F5>", function()
        vim.cmd.w()
        vim.cmd.Make()
    end, { buffer = true, desc = "Build Pd external" })
    map("n", "<F6>", function()
        vim.cmd.w()
        vim.cmd.redraw()
        require("r.utils.compiler").pdBuild()
    end, { buffer = true, desc = "Copy external to PD directory" })
end

-- ******************************** Clang Lsp----------------------------

function cmaps.clang()
    wk.register({
        [";"] = {
            b = { vim.cmd.CclsBase, "Base function" },
            c = { vim.cmd.CclsCallers, "Callers" },
            C = { vim.cmd.CclsCallees, "Callees" },
            d = { vim.cmd.CclsDerived, "Derived functions" },
            m = { "<cmd>CclsMemberHierarchy -float<CR>", "Member variables" },
            f = { "<cmd>CclsMemberFunctionHierarchy -float<CR>", "Member functions" },
            t = { "<cmd>CclsMemberTypeHierarchy -float<CR>", "Member classes" },
            v = { vim.cmd.CclsVars, "Variables in function" },
            h = {
                name = "heirarchy",
                b = { "<cmd>CclsBaseHierarchy -float<CR>", "Base function" },
                c = { "<cmd>CclsCallHierarchy -float<CR>", "Caller" },
                C = { "<cmd>CclsCalleeHierarchy -float<CR>", "Callee" },
                d = { "<cmd>CclsDerivedHierarchy -float<CR>", "Derived functions" },
            },
            r = {
                name = "Refactor Cpp",
                f = { "<cmd>TSCppDefineClassFunc<CR>", "function definition from declaration", mode = "v" },
                c = { "<cmd>TSCppMakeConcreteClass<CR>", "Convert virtual class to concrete class", mode = "v" },
                C = { "<cmd>TSCppRuleOf3<CR>", "Add Constructor, destructor and copy", mode = "v" },
                m = { "<cmd>TSCppRuleOf5<CR>", "Add move Constructor", mode = "v" },
            },
        },
        [","] = {
            k = {
                name = "Online help",
                c = {
                    function()
                        require("r.utils.compiler").creference(vim.fn.expand "<cword>")
                    end,
                    "C++ std reference",
                },
                g = {
                    function()
                        require("r.utils.compiler").glRef(vim.fn.expand "<cword>")
                    end,
                    "OpenGL reference",
                },
            },
            h = {
                function()
                    require("clangd_extensions.inlay_hints").toggle_inlay_hints()
                end,
                "Toggle hints",
            },
        },
        ["<leader>"] = {
            s = { vim.cmd.ClangdSwitchSourceHeader, "Switch to Header/Source" },
            m = {
                function()
                    require("r.utils.compiler").makefile(vim.g.makeFile)
                end,
                "Open Makefile",
            },
            c = {
                function()
                    require("r.utils.compiler").ctags(vim.g.cfiles)
                end,
                "generate Ctags with includes",
            },
        },
    }, { buffer = 0 })
end

------------------------------------------------------------------------
--                              Cmake                                 --
------------------------------------------------------------------------

function cmaps.cmake()
    map("n", "<F2>", require("r.utils.compiler").cmake_clean, { buffer = true, desc = "Clean cmake" })
    map("n", "<F3>", function()
        vim.cmd.w()
        vim.cmd.redraw()
        require("r.utils.compiler").cmake_gen "Debug"
    end, { buffer = true, desc = "Generate Cmake Debug" })
    map("n", "<F4>", function()
        vim.cmd.w()
        vim.cmd.redraw()
        require("r.utils.compiler").cmake_gen "Release"
    end, { buffer = true, desc = "Generate Cmake Release" })
    map("n", "<F5>", function()
        vim.cmd.w()
        require("r.utils").ex_cmd("Make", { "-j12", "-C", "build" }, { silent = true })
    end, { buffer = true, desc = "Make" })
    map("n", "<F6>", function()
        require("r.utils.compiler").renderOffload { vim.g.cmakeBin }
    end, { buffer = true, desc = "Launch binary" })
end

return cmaps
