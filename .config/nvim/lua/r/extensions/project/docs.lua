--[[
    cppref = {
        base_url = 'https://www.cplusplus.com/search.do',
        query_param = 'q',
    },
    glref = {
        base_url = 'https://docs.gl/gl4',
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
]]

local docs = {}

------------------------------------------------------------------------
--                                Env Setup	                          --
------------------------------------------------------------------------

-- Documentation sources
local site_mappings = {
    cppref = {
        base_url = 'https://en.cppreference.com/mwiki/index.php',
        query_param = 'title=Special:Search&search',
    },
    glref = {
        base_url = 'https://www.khronos.org/registry/OpenGL-Refpages/gl4',
        query_param = nil,
    },
    vulkanref = {
        base_url = 'https://registry.khronos.org/vulkan/specs/1.3-extensions/html',
        query_param = nil,
    },
    unrealref = {
        base_url = 'https://www.unrealengine.com/en-US/bing-search',
        query_param = 'keyword',
    },
    nvidia = {
        base_url = 'https://developer.nvidia.com/search',
        query_param = 'site_search',
    },
    arduino = {
        base_url = 'https://www.arduino.cc/reference/en',
        query_param = nil,
    },
}

-- Construct search URLs dynamically
local function construct_url(site, query)
    local mapping = site_mappings[site]
    if not mapping then
        error('Invalid site: ' .. site)
    end
    local url = mapping.base_url
    if mapping.query_param then
        query = vim.fn.escape(query, ':/?&=')
        url = url .. '?' .. mapping.query_param .. '=' .. query
    else
        url = url .. '/' .. query .. '.html'
    end
    return url
end

-- Open the search result in the browser
local function open_reference(site, query)
    if not query or query == '' then
        query = vim.fn.input 'Enter query: '
    end
    local url = construct_url(site, query)
    vim.fn.system { 'xdg-open', url }
end

------------------------------------------------------------------------
--                                Cpp Setup	                          --
------------------------------------------------------------------------

-- Define search functions
docs.cppref = function()
    open_reference('cppref', vim.fn.expand '<cword>')
end
docs.glref = function()
    open_reference('glref', vim.fn.expand '<cword>')
end
docs.vulkanref = function()
    open_reference('vulkanref', vim.fn.expand '<cword>')
end
docs.unrealref = function()
    open_reference('unrealref', vim.fn.expand '<cword>')
end
docs.nvidia = function()
    open_reference('nvidia', vim.fn.expand '<cword>')
end
docs.arduino = function()
    open_reference('arduino', vim.fn.expand '<cword>')
end

docs.mappings = function(buffer)
    require('which-key').add(require 'r.utils.expand_maps'({
        ['go'] = {
            name = 'Online help',
            a = { require('r.extensions.project.docs').arduino, 'Arduino' },
            c = { require('r.extensions.project.docs').cppref, 'C++ std reference' },
            g = { require('r.extensions.project.docs').glref, 'OpenGL reference' },
            u = { require('r.extensions.project.docs').unrealref, 'Unreal Engine reference' },
            v = { require('r.extensions.project.docs').vulkanref, 'Unreal Engine reference' },
        },
    }, { buffer = buffer }))
end

return docs
