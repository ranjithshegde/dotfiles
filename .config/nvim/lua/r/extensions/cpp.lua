local clang = {}

local function isFile(file)
    return vim.uv.fs_stat(file) ~= nil
end

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
function clang.set_cpptype()
    local dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local unreal_file = dirname .. '.uproject'

    if isFile(unreal_file) then
        vim.b.makeprg = '/opt/unreal-engine/Engine/Build/BatchFiles/Linux/Build.sh'
        vim.b.unreal_dir = dirname
        vim.b.cpp_type = 'Unreal'
    elseif isFile 'CMakeLists.txt' then
        require('r.plugins.tasks.mappings').cmake()
        vim.bo.makeprg = 'make'
        vim.b.makeFile = 'CMakeLists.txt'
        vim.b.debugBin = 'build/' .. dirname
        vim.b.cpp_type = 'CMake'
    elseif isFile 'Makefile' then
        vim.b.makeFile = 'Makefile'
        vim.bo.makeprg = 'make'
        if isFile(dirname .. '.qbs') or isFile 'config.make' or isFile 'addons.make' then
            require('r.plugins.tasks.mappings').oF()
            vim.b.makeBin = 'bin/' .. dirname
            vim.b.debugBin = 'bin/' .. dirname .. '_debug'
            vim.b.wasm = 'bin/' .. dirname .. '.html'
            vim.b.cpp_type = 'oF'
        else
            vim.b.cpp_type = 'Make'
        end
    elseif isFile 'platformio.ini' then
        vim.bo.makeprg = 'pio run'
        require('r.plugins.tasks.mappings').micro()
        vim.b.makeFile = 'platformio.ini'
        vim.b.cpp_type = 'Pio'
    elseif isFile 'build.gradle' then
        require('r.plugins.tasks.mappings').makeGradle()
        vim.b.makeFile = 'build.gradle'
        vim.bo.makeprg = './gradlew'
        vim.b.cpp_type = 'CDroid'
    else
        vim.bo.makeprg = vim.g.is_win32 and 'clang++' or 'g++'
        require('r.plugins.tasks.mappings').ctests()
        vim.b.debugBin = vim.fn.expand '%<'
        vim.b.cpp_type = 'Single'
    end
end

function clang.set_ctype()
    if isFile 'Makefile.pdlibbuilder' then
        require('r.plugins.tasks.mappings').pdc()
        vim.b.c_type = 'PD'
    elseif isFile 'Makefile' then
        require('r.plugins.tasks.mappings').makeC()
        vim.bo.makeprg = 'make'
        vim.b.makeFile = 'Makefile'
        vim.b.c_type = 'Make'
    else
        vim.bo.makeprg = vim.g.is_win32 and 'clang' or 'gcc'
        require('r.plugins.tasks.mappings').ctests()
        vim.b.debugBin = vim.fn.expand '%<'
        vim.b.c_type = 'Single'
    end
end

local site_mappings = {
    cppref = {
        base_url = 'https://www.cplusplus.com/search.do',
        query_param = 'q',
    },
    glref = {
        base_url = 'https://docs.gl/gl4',
        query_param = nil, -- No query param, path-based
    },
    unrealref = {
        base_url = 'https://www.unrealengine.com/en-US/bing-search',
        query_param = 'keyword',
        additional_params = {
            x = '0',
            y = '0',
            filter = 'UE4 Documentation',
        },
    },
    arduinoref = {
        base_url = 'https://www.arduino.cc/reference/en',
        query_param = nil, -- No query param, path-based
    },
    teensypins = {
        base_url = 'https://www.pjrc.com/teensy/pinout.html',
        query_param = nil, -- No query param, path-based
    },
    teensyspecs = {
        base_url = 'https://www.pjrc.com/teensy/techspecs.html',
        query_param = nil, -- No query param, path-based
    },
}

-- Utility function to construct URLs dynamically
local function construct_url(site, query)
    local mapping = site_mappings[site]
    if not mapping then
        error('Invalid site: ' .. site)
    end

    local url = mapping.base_url

    if mapping.query_param then
        -- Add query parameter if it exists
        query = vim.fn.escape(query, ':/?&=')
        url = url .. '?' .. mapping.query_param .. '=' .. query
    else
        -- Append query as a path (e.g., for glref)
        url = url .. '/' .. query
    end

    -- Add additional parameters if they exist
    if mapping.additional_params then
        for key, value in pairs(mapping.additional_params) do
            url = url .. '&' .. key .. '=' .. value
        end
    end

    return url
end

-- Generic function to open a reference in the browser
function clang.open_reference(site, query)
    query = query or vim.fn.expand '<cword>' -- Use word under cursor if no query is provided
    local url = construct_url(site, query)

    -- Open the URL in the browser
    local ok, err = pcall(function()
        require('r.utils').open_in_browser(url)
    end)
    if not ok then
        vim.notify('Failed to open URL: ' .. err, vim.log.levels.ERROR)
    end
end

------------------------------------------------------------------------
--                                Cpp Setup	                          --
------------------------------------------------------------------------

---Search Cplusplus.com for symbol
function clang.cppref()
    clang.open_reference 'cppref'
end

---Search OpenGL reference manual for symbol
function clang.glref()
    clang.open_reference 'glref'
end

function clang.unrealref()
    clang.open_reference 'unrealref'
end

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
------------------------------------------------------------------------

-- print serial monitor
function clang.monitor()
    local cmd = 'pio device monitor'
    require('r.extensions').toggleTerm(cmd, 'pio')
end

function clang.teensypins()
    clang.open_reference 'teensypins'
end

function clang.teensyspecs()
    clang.open_reference 'teensyspecs'
end

function clang.arduinoref()
    clang.open_reference 'arduinoref'
end

function clang.ardRef(cmd)
    local url = 'https://search.arduino.cc/search?tab=reference&q=' .. cmd
    require('r.utils').open_in_browser(url)
end

return clang
