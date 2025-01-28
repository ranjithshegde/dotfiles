return {
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        cmd = 'Org',
        config = function()
            local menu = require 'r.plugins.orgmode.ui'
            require('orgmode').setup {
                org_agenda_files = {
                    '~/Documents/Agenda/*',
                    '~/Documents/Agenda/*/*',
                    '~/Documents/Agenda/*/*/*',
                    '~/Documents/Agenda/*/*/*/*',
                },
                org_default_notes_file = '~/Documents/notes.org',
                org_highlight_latex_and_related = 'entities',
                emacs_config = {
                    config_path = vim.env.XDG_CONFIG_HOME and vim.env.XDG_CONFIG_HOME .. '/emacs/init.el'
                        or '$HOME/.emacs.d/init.el',
                },
                ui = {
                    menu = {
                        handler = function(data)
                            menu
                                :new({
                                    window = {
                                        margin = { 1, 0, 1, 0 },
                                        padding = { 0, 1, 0, 1 },
                                        title_pos = 'center',
                                        border = 'single',
                                        zindex = 1000,
                                    },
                                    icons = {
                                        separator = '➜',
                                    },
                                })
                                :open(data)
                        end,
                    },
                },
            }
        end,
        init = function()
            require('r.utils').lazy_on_key('n', '<leader>o', 'Orgmode', function()
                require('lazy').load { plugins = { 'orgmode' } }
            end)
            local id = {}
            id.OrgMode = vim.api.nvim_create_augroup('OrgMode', { clear = true })
            -- Hack till upstream blink is fixed
            vim.api.nvim_create_autocmd('FileType', {
                group = id.OrgMode,
                pattern = 'org',
                once = true,
                callback = function()
                    require('blink.cmp').add_provider('orgmode', {
                        name = 'Orgmode',
                        module = 'orgmode.org.autocompletion.blink',
                    })
                end,
                desc = 'Add org completion source',
            })

            require('r.utils').register_au_id(id)
        end,
    },
    {
        'chipsenkbeil/org-roam.nvim',
        dependencies = 'nvim-orgmode/orgmode',
        ft = 'org',
        config = function()
            require('org-roam').setup {
                directory = '~/Documents/Wiki/',
                bindings = { prefix = '<leader>w' },
            }
        end,
        keys = { '<leader>w' },
    },
}
