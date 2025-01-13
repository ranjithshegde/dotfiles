local lang = {}

local wk = require 'which-key'

------------------------------------------------------------------------
--                              Cpp                                   --
------------------------------------------------------------------------
function lang.cpp(buf)
    wk.add(require 'r.utils.expand_maps'({
        [','] = {
            k = {
                name = 'Online help',
                c = {
                    function()
                        require('r.extensions.cpp').creference(vim.fn.expand '<cword>')
                    end,
                    'C++ std reference',
                },
                g = {
                    function()
                        require('r.extensions.cpp').glRef(vim.fn.expand '<cword>')
                    end,
                    'OpenGL reference',
                },
                u = {
                    function()
                        require('r.extensions.cpp').unRef(vim.fn.expand '<cword>')
                    end,
                    'Unreal Engine reference',
                },
            },
        },
        ['<leader>m'] = {
            function()
                vim.cmd.tabnew(vim.b.makeFile)
            end,
            'Open Makefile',
        },
    }, { buffer = buf }))
end

return lang
