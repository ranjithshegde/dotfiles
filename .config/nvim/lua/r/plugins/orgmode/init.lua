return {
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        cmd = 'Org',
        config = function()
            require('orgmode').setup {
                org_agenda_files = {
                    '~/Documents/Orgs/*',
                    '~/Documents/Orgs/*/*',
                    '~/Documents/Orgs/*/*/*',
                    '~/Documents/Orgs/*/*/*/*',
                },
                org_highlight_latex_and_related = 'entities',
                emacs_config = {
                    config_path = vim.env.XDG_CONFIG_HOME and vim.env.XDG_CONFIG_HOME .. '/emacs/init.el'
                        or '$HOME/.emacs.d/init.el',
                },
            }
        end,
        init = function()
            local id = {}
            id.OrgMode = vim.api.nvim_create_augroup('OrgMode', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = id.OrgMode,
                pattern = 'org',
                callback = function()
                    require('r.plugins.orgmode.mappings').ft()
                end,
                desc = 'Add orgwiki mappings',
            })
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
        'ranjithshegde/orgWiki.nvim',
        dev = true,
        init = function()
            require('r.utils').lazy_on_key('n', '<leader>w', 'OrgWiki', function()
                require('r.plugins.orgmode.mappings').wiki()
            end)
        end,
        opts = {
            disable_mappings = true,
            wiki_path = { '~/Documents/Orgs/', '~/Documents/Projects/' },
            diary_path = '~/Documents/Orgs/diary/',
        },
    },
}
