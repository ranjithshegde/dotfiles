local overseer = require "overseer"

local of_tasks = {}

of_tasks.build_release = {
    name = "of_build",
    builder = function(_)
        return {
            cmd = { "make", "Release", "-j12" },
        }
    end,
    desc = "Compile openFrameworks binary for Release",
    tags = { overseer.TAG.BUILD },
    priority = 20,
    params = {},
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            return vim.g.makeFile == "Makefile"
        end,
    },
}

of_tasks.run_release = {
    name = "of_run",
    builder = function(_)
        return {
            cmd = { "make", "RunRelease" },
        }
    end,
    desc = "Run openFrameworks binary",
    tags = { overseer.TAG.BUILD },
    priority = 10,
    params = {},
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            return vim.g.makeFile == "Makefile"
        end,
    },
}

of_tasks.build_debug = {
    name = "of_debug",
    builder = function(_)
        return {
            cmd = { "make", "Debug", "-j12" },
        }
    end,
    desc = "Build openFrameworks binary for debug",
    tags = { overseer.TAG.BUILD },
    priority = 30,
    params = {},
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            return vim.g.makeFile == "Makefile"
        end,
    },
}

of_tasks.build_wasm = {
    name = "of_wasm",
    builder = function(_)
        return {
            cmd = { "emmake", "make", "-j12" },
        }
    end,
    desc = "Build openFrameworks webassembly",
    tags = { overseer.TAG.BUILD },
    priority = 50,
    params = {},
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            return vim.g.makeFile == "Makefile"
        end,
    },
}

of_tasks.run_wasm = {
    name = "of_ems",
    builder = function(_)
        return {
            cmd = { "emrun", "--browser='brave'", vim.g.embin },
        }
    end,
    desc = "Run openFrameworks binary",
    tags = { overseer.TAG.BUILD },
    priority = 40,
    params = {},
    condition = {
        filetype = { "c", "cpp" },
        callback = function()
            return vim.g.makeFile == "Makefile"
        end,
    },
}

-- function of_tasks.bundle()
--     return {
--         of_tasks.build_release,
--         of_tasks.build_debug,
--         of_tasks.build_wasm,
--         of_tasks.run_release,
--         of_tasks.run_wasm,
--     }
-- end

-- return of_tasks

return function()
    for _, v in pairs(of_tasks) do
        overseer.register_template(v)
        -- vim.pretty_print(v)
    end
end
