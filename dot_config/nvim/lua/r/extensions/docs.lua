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
        base_url = 'https://registry.khronos.org/OpenGL-Refpages/gl4',
        query_param = nil,
    },
    vulkanref = {
        base_url = 'https://registry.khronos.org/vulkan/specs/1.3-extensions/man/html',
        query_param = nil,
    },
    unrealref = {
        base_url = 'https://www.unrealengine.com/en-US/bing-search',
        query_param = 'keyword',
    },
    arduino = {
        base_url = 'https://www.arduino.cc/reference/en',
        query_param = nil,
    },
    teensypins = {
        base_url = 'https://www.pjrc.com/teensy/pinout.html',
        query_param = nil,
    },
    teensyspecs = {
        base_url = 'https://www.pjrc.com/teensy/techspecs.html',
        query_param = nil,
    },
    wikitionary = {
        base_url = 'https://en.wiktionary.org/wiki',
        query_param = nil,
    },
    thesaurus = {
        base_url = 'https://www.thesaurus.com/browse',
        query_param = nil,
    },
}

-- Construct search URLs dynamically
local function construct_url(site, query, html)
    local mapping = site_mappings[site]
    if not mapping then
        error('Invalid site: ' .. site)
    end
    local url = mapping.base_url
    if mapping.query_param then
        query = vim.fn.escape(query, ':/?&=')
        url = url .. '?' .. mapping.query_param .. '=' .. query
    else
        if html then
            url = url .. '/' .. query .. '.html'
        else
            url = url .. '/' .. query
        end
    end
    return url
end

-- Open the search result in the browser
local function open_reference(site, query, html)
    if not query or query == '' then
        query = vim.fn.input 'Enter query: '
    end
    local url = construct_url(site, query, html)
    require('r.utils').open_in_browser(url)
end

------------------------------------------------------------------------
--                                Doc Setup	                          --
------------------------------------------------------------------------

docs.cppref = function()
    open_reference('cppref', vim.fn.expand '<cword>')
end

docs.glref = function()
    open_reference('glref', vim.fn.expand '<cword>')
end

docs.vulkanref = function()
    open_reference('vulkanref', vim.fn.expand '<cword>', true)
end

docs.unrealref = function()
    open_reference('unrealref', vim.fn.expand '<cword>')
end

docs.arduino = function()
    open_reference('arduino', vim.fn.expand '<cword>')
end

docs.teensypins = function()
    open_reference 'teensypins'
end

docs.teensyspec = function()
    open_reference 'teensyspec'
end

docs.dictionary = function()
    open_reference('wikitionary', vim.fn.expand '<cword>')
end

docs.synomyms = function()
    open_reference('thesaurus', vim.fn.expand '<cword>')
end

return docs
