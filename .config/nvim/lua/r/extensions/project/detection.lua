local M = {}

M.state = {
    buffers = {},
    type_handlers = {},
}

local function get_dirname()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

local function get_unreal_proj()
    return get_dirname() .. '.uproject'
end

-- Detection rules for different project types
local project_types = {
    unreal = {
        detect = function()
            return vim.fn.filereadable(get_unreal_proj()) == 1
        end,
        config = function()
            return {
                type_name = 'Unreal',
                makeprg = '/opt/unreal-engine/Engine/Build/BatchFiles/Linux/Build.sh',
                project_conf = get_unreal_proj(),
                project_name = get_dirname(),
            }
        end,
    },
    cmake = {
        detect = function()
            return vim.fn.filereadable 'CMakeLists.txt' == 1
        end,
        config = function()
            local dirname = get_dirname()
            return {
                type_name = 'CMake',
                makeprg = 'make',
                makefile = 'CMakeLists.txt',
                debug_bin = 'build/' .. dirname,
            }
        end,
    },
    openframeworks = {
        detect = function()
            local dirname = get_dirname()
            return vim.fn.filereadable 'Makefile' == 1
                and (
                    vim.fn.filereadable(dirname .. '.qbs') == 1
                    or vim.fn.filereadable 'config.make' == 1
                    or vim.fn.filereadable 'addons.make' == 1
                )
        end,
        config = function()
            local dirname = get_dirname()
            return {
                type_name = 'oF',
                makeprg = 'make',
                makefile = 'Makefile',
                make_bin = 'bin/' .. dirname,
                debug_bin = 'bin/' .. dirname .. '_debug',
                wasm_bin = 'bin/' .. dirname .. '.html',
            }
        end,
    },
    platformio = {
        detect = function()
            return vim.fn.filereadable 'platformio.ini' == 1
        end,
        config = function()
            return {
                type_name = 'Pio',
                makeprg = 'pio run',
                makefile = 'platformio.ini',
            }
        end,
    },
    gradle = {
        detect = function()
            return vim.fn.filereadable 'build.gradle' == 1
        end,
        config = function()
            return {
                type_name = 'CDroid',
                makeprg = './gradlew',
                makefile = 'build.gradle',
            }
        end,
    },
    pd = {
        detect = function()
            return vim.fn.filereadable 'Makefile.pdlibbuilder' == 1
        end,
        config = function()
            return {
                type_name = 'PD',
                makeprg = 'make',
                makefile = 'Makefile.pdlibbuilder',
            }
        end,
    },
}

-- Default configurations for single file projects
local default_configs = {
    cpp = {
        type_name = 'Single',
        makeprg = vim.g.is_win32 and 'clang++' or 'g++',
        debug_bin = vim.fn.expand '%<',
    },
    c = {
        type_name = 'Single',
        makeprg = vim.g.is_win32 and 'clang' or 'gcc',
        debug_bin = vim.fn.expand '%<',
    },
}

-- Detect project type and store configuration
function M.detect_project_type(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    -- Check if we already detected type for this buffer
    if M.state.buffers[bufnr] then
        return M.state.buffers[bufnr]
    end

    local config = nil
    for _, proj_type in pairs(project_types) do
        if proj_type.detect() then
            config = proj_type.config()
            break
        end
    end

    -- Always start with default config based on filetype
    local ft = vim.bo[bufnr].filetype
    local base_config = vim.tbl_extend('force', {}, default_configs[ft] or {})

    -- If we found a project-specific config, merge it on top of defaults
    if config then
        config = vim.tbl_extend('force', base_config, config)
    else
        config = base_config
    end

    -- Store the configuration
    M.state.buffers[bufnr] = config
    return config
end

-- Check if any buffer is of the given project type
function M.has_project_type(type_name)
    for _, config in pairs(M.state.buffers) do
        if config.type_name == type_name then
            return true
        end
    end
    return false
end

-- Get project type for a buffer
function M.get_project_type(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local config = M.state.buffers[bufnr]
    return config and config.type_name
end

-- Register a handler for a project type
function M.register_handler(type_name, handler)
    -- Only register if we have a buffer of this project type
    if not M.has_project_type(type_name) then
        return false
    end

    if not M.state.type_handlers[type_name] then
        M.state.type_handlers[type_name] = {}
    end
    table.insert(M.state.type_handlers[type_name], handler)

    -- Apply handler to existing buffers of this type
    for _, config in pairs(M.state.buffers) do
        if config.type_name == type_name then
            -- TODO: Fix temporary workaround for DAP
            -- if package.loaded['dap'] then
            handler(0, config)
            -- else
            --     handler(bufnr, config)
            -- end
        end
    end

    return true
end

-- Apply configuration to buffer
function M.apply_config(config, bufnr)
    if not config then
        return
    end
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    -- Set buffer/window variables
    if config.type_name then
        vim.b[bufnr].cpp_type = config.type_name
    end
    if config.makeprg then
        vim.bo[bufnr].makeprg = config.makeprg
    end
    if config.makefile then
        vim.b[bufnr].makeFile = config.makefile
    end
    if config.make_bin then
        vim.b[bufnr].makeBin = config.make_bin
    end
    if config.debug_bin then
        vim.b[bufnr].debugBin = config.debug_bin
    end
    if config.wasm_bin then
        vim.b[bufnr].wasm = config.wasm_bin
    end

    if config.project_name then
        vim.b[bufnr].project_name = config.project_name
    end

    if config.project_conf then
        vim.b[bufnr].project_conf = config.project_conf
    end

    -- Run any registered handlers for this type
    local handlers = M.state.type_handlers[config.type_name]
    if handlers then
        for _, handler in ipairs(handlers) do
            handler(bufnr, config)
        end
    end
end

-- Main setup function
function M.setup(buffer)
    if not buffer then
        return
    end
    if M.state.buffers[buffer] then
        return
    end
    local config = M.detect_project_type(buffer)
    M.apply_config(config, buffer)
end

return M
