local docs = {}

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Set C environment based on type [with makefile, microcontroller, cmake project or plain c]
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
function docs.open_reference(site, query)
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
function docs.cppref()
    docs.open_reference 'cppref'
end

---Search OpenGL reference manual for symbol
function docs.glref()
    docs.open_reference 'glref'
end

function docs.unrealref()
    docs.open_reference 'unrealref'
end

-----------------------------------------------------------------------
--                    MicroControllers  	                          --
------------------------------------------------------------------------

function docs.teensypins()
    docs.open_reference 'teensypins'
end

function docs.teensyspecs()
    docs.open_reference 'teensyspecs'
end

function docs.arduinoref()
    docs.open_reference 'arduinoref'
end

function docs.ardRef(cmd)
    local url = 'https://search.arduino.cc/search?tab=reference&q=' .. cmd
    require('r.utils').open_in_browser(url)
end

return docs
