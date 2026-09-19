local constants = require 'overseer.constants'
local TAG = constants.TAG

---@type overseer.TemplateFileDefinition
return {
    name = 'generate compile_commands.json',
    desc = "Generates compile_commands.json by parsing the project's VSCode compileCommands file and using jq",
    priority = 50,
    tags = { TAG.BUILD },
    condition = {
        filetype = { 'cpp', 'c' },
        callback = function()
            return vim.b.cpp_type == 'Unreal' and vim.fn.executable 'UnrealEditor'
        end,
    },
    builder = function()
        local cwd = vim.fn.getcwd()
        local project_name = vim.b.project_name

        local project_compile_commands_path =
            vim.fs.joinpath(cwd, '.vscode/compileCommands_' .. project_name .. '.json')
        local output_path = vim.fs.joinpath(cwd, 'compile_commands.json')

        local function file_exists(path)
            local file = io.open(path, 'r')
            if file then
                file:close()
                return true
            end
            return false
        end

        if not file_exists(project_compile_commands_path) then
            vim.notify(
                'Project compileCommands file not found: ' .. project_compile_commands_path,
                vim.log.levels.ERROR
            )
            return
        end

        local compile_flags = {
            '-std=c++20',
            '-ferror-limit=0',
            '-Wall',
            '-Wextra',
            '-Wpedantic',
            '-Wshadow-all',
            '-Wno-unused-parameter',
        }

        local flags = table.concat(compile_flags, ' ')
        flags = ' ' .. flags

        return {
            cmd = {
                'jq',
                '--monochrome-output',
                'map(.arguments = ["clang++ ' .. flags .. ' " + .file + " " + .arguments[1]])',
                project_compile_commands_path,
            },
            components = {
                'default',
                {
                    'on_output_write_file',
                    filename = output_path,
                },
                {
                    'restart_on_save',
                    mode = 'uv',
                    paths = {
                        cwd .. '/.vscode',
                    },
                },
                {
                    'dependencies',
                    task_names = { 'generate clangd' },
                    sequential = true,
                },
            },
        }
    end,
}
