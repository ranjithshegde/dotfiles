local constants = require 'overseer.constants'
local TAG = constants.TAG

-- Configuration
local DEBUG_FLAGS = {
    'WITH_EDITOR=1',
    'UE_EDITOR=1',
}

local ENGINE_INCLUDES = {
    '/Engine/Source/Runtime/Core/Public',
    '/Engine/Source/Runtime/Core/Private',
    '/Engine/Source/Runtime/Engine/Classes',
    '/Engine/Source/Runtime/Engine/Public',
    '/Engine/Source/Runtime/Engine/Private',
}

local function generate_clangd_content(cwd, project_name)
    local content = { 'CompileFlags:', '\tAdd: [' }

    for _, flag in ipairs(DEBUG_FLAGS) do
        table.insert(content, string.format('\t\t"-D%s",', flag))
    end

    for _, path in ipairs(ENGINE_INCLUDES) do
        table.insert(content, string.format('\t\t"-I%s%s",', vim.g.ue_path, path))
    end

    local project_include = string.format('%s/Intermediate/Build/Linux/UnrealEditor/Inc/%s/UHT', cwd, project_name)
    table.insert(content, string.format('\t\t"-I%s",', project_include))

    local editor_include = string.format('%s/Intermediate/Build/Linux/UnrealEditor/Inc/%sEditor/UHT', cwd, project_name)
    table.insert(content, string.format('\t\t"-I%s",', editor_include))

    table.insert(content, '\t]')
    return table.concat(content, '\n')
end

---@type overseer.TemplateFileDefinition
return {
    name = 'generate clangd',
    desc = 'Generate .clangd file for current Unreal project',
    priority = 50,
    tags = { TAG.BUILD },
    condition = {
        filetype = { 'cpp', 'c' },
        callback = function()
            return vim.b.cpp_type == 'Unreal'
        end,
    },
    builder = function()
        local cwd = vim.fn.getcwd()
        local project_name = vim.b.project_name
        local content = generate_clangd_content(cwd, project_name)

        local file, err = io.open(cwd .. '/.clangd', 'w')
        if not file then
            vim.notify(string.format('Failed to write .clangd: %s', err), vim.log.levels.ERROR)
            return nil
        end
        file:write(content)
        file:close()

        return {
            cmd = { 'true' },
            components = {
                'default',
                { 'on_complete_notify' },
                {
                    'restart_on_save',
                    mode = 'uv',
                    paths = {
                        string.format('%s/Intermediate/Build/Linux/UnrealEditor/Inc', cwd),
                    },
                },
            },
        }
    end,
}
