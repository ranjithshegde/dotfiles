local utils = require 'r.utils'
local settings = require 'r.plugins.orgmode'
local add = vim.pack.add

add({ 'https://github.com/lukas-reineke/headlines.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('headlines', plug.spec.name, function()
            require('headlines').setup {
                org = {
                    codeblock_highlight = 'markdownCodeBlock',
                },
            }
        end)
        utils.lazy_command('Org', 'headlines')
        utils.lazy_event('FileType', 'headlines', 'org')
    end,
    confirm = false,
})

add({ 'https://github.com/nvim-orgmode/orgmode' }, {
    load = function(plug)
        utils.lazy_plugin('orgmode', plug.spec.name, function()
            require('orgmode').setup(settings.config)
        end)
        utils.lazy_command('Org', 'orgmode')
        utils.lazy_event('FileType', 'orgmode', 'org')

        settings.org_init()

        vim.keymap.set('n', '<leader>oa', '<cmd>Org agenda<cr>', { desc = 'Open org agenda' })
        vim.keymap.set('n', '<leader>oc', '<cmd>Org capture<cr>', { desc = 'Open org capture' })
    end,
    confirm = false,
})

add({ 'https://github.com/chipsenkbeil/org-roam.nvim' }, {
    load = function(plug)
        utils.lazy_plugin('org-roam', plug.spec.name, function()
            require('org-roam').setup {
                directory = vim.fs.joinpath(settings.paths.root, 'Wiki'),
                bindings = { prefix = '<leader>w', goto_next_node = ']w', goto_prev_node = '[w' },
            }
        end)
        utils.lazy_on_key('n', '<leader>w', 'OrgRoam', function()
            require 'org-roam'
        end)
    end,
    confirm = false,
})
