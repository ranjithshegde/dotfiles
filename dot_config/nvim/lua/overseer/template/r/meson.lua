local constants = require 'overseer.constants'
local overseer = require 'overseer'
local TAG = constants.TAG
local num_jobs = G._MACHINE and '-j12' or '-j32'

local tmpl = {
    params = {
        args = { type = 'list', delimiter = ' ' },
        buildtype = { type = 'string', optional = true },
        dGPU = { type = 'boolean' },
        save = { type = 'boolean', optional = true },
    },
    builder = function(params)
        local build_table = {}
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end
        if params.buildtype then
            if vim.tbl_contains(cmd, 'setup') then
                table.insert(cmd, '--buildtype=' .. params.buildtype)
            end
        end
        if params.dGPU then
            if G._MACHINE then
                table.insert(cmd, 1, 'prime_run')
            else
                build_table.env = { DRI_PRIME = '1' }
            end
        end
        build_table.cmd = cmd
        build_table.components = { 'default', 'on_output_quickfix', 'unique', { 'r.dispatch', save = params.save } }
        return build_table
    end,
}

return {
    condition = {
        filetype = { 'c', 'cpp' },
        callback = function()
            return vim.b.cpp_type == 'Meson' or vim.fn.filereadable 'meson.build' == 1
        end,
    },
    generator = function(_, cb)
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        local commands = {
            {
                args = { 'rm', '-rf', 'build' },
                tags = { TAG.CLEAN },
                priority = 70,
                dGPU = false,
            },
            -- Setup debug build
            {
                args = { 'meson', 'setup', 'build', '--buildtype=debug' },
                tags = { TAG.BUILD },
                priority = 25,
                save = true,
                dGPU = false,
                buildtype = 'debug',
            },
            -- Setup release build
            {
                args = { 'meson', 'setup', 'build', '--buildtype=release' },
                tags = { TAG.BUILD },
                priority = 25,
                save = true,
                dGPU = false,
                buildtype = 'release',
            },
            -- Compile (debug)
            {
                args = { 'meson', 'compile', '-C', 'build', num_jobs },
                tags = { TAG.BUILD },
                priority = 20,
                save = true,
                dGPU = false,
            },
            -- Run executable
            {
                args = { './build/' .. project_name },
                tags = { TAG.TEST },
                priority = 10,
            },
            -- Run tests
            {
                args = { 'meson', 'test', '-C', 'build' },
                tags = { TAG.TEST },
                priority = 15,
                dGPU = false,
            },
            -- Install
            {
                args = { 'meson', 'install', '-C', 'build' },
                tags = { TAG.DEPLOY },
                priority = 30,
                dGPU = false,
            },
            {
                args = { 'meson', '--reconfigure', 'build' },
                tags = { TAG.BUILD },
                priority = 22,
                save = true,
                dGPU = false,
            },
        }

        local ret = {}
        for _, command in ipairs(commands) do
            local name = 'Meson'
            local desc

            if vim.tbl_contains(command.args, 'rm') then
                name = name .. ' clean'
                desc = 'Remove build directory'
            elseif vim.tbl_contains(command.args, 'setup') and vim.tbl_contains(command.args, 'debug') then
                name = name .. ' setup (debug)'
                desc = 'Configure project for debug build'
            elseif vim.tbl_contains(command.args, 'setup') and vim.tbl_contains(command.args, 'release') then
                name = name .. ' setup (release)'
                desc = 'Configure project for release build'
            elseif vim.tbl_contains(command.args, 'compile') then
                name = name .. ' build'
                desc = 'Compile project binary'
            elseif vim.tbl_contains(command.args, 'test') then
                name = name .. ' test'
                desc = 'Run project tests'
            elseif vim.tbl_contains(command.args, 'install') then
                name = name .. ' install'
                desc = 'Install binary to system prefix'
            elseif vim.tbl_contains(command.args, '--reconfigure') then
                name = name .. ' reconfigure'
                desc = 'Reconfigure build (after adding files)'
            else
                name = name .. ' run'
                desc = 'Run binary for testing'
            end

            if not command.save then
                command.save = false
            end

            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = name,
                    desc = desc,
                    tags = command.tags,
                    priority = command.priority,
                }, {
                    args = command.args,
                    save = command.save,
                    dGPU = command.dGPU,
                    buildtype = command.buildtype,
                })
            )
        end
        cb(ret)
    end,
}
