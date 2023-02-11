return {
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        config = function()
            require('orgmode').setup_ts_grammar()
            require('orgmode').setup {
                org_agenda_files = {
                    '~/Documents/Orgs/*',
                    '~/Documents/Orgs/*/*',
                    '~/Documents/Orgs/*/*/*',
                    '~/Documents/Orgs/*/*/*/*',
                },
                org_highlight_latex_and_related = 'entities',
                emacs_config = { config_path = '$XDG_CONFIG_HOME/emacs/init.el' },
            }
        end,
        init = function()
            local id = {}
            id.OrgMode = vim.api.nvim_create_augroup('OrgMode', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'org',
                callback = function()
                    require('r.plugins.orgmode.mappings').ft()
                end,
            })

            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*.org',
                callback = function()
                    local view = vim.fn.winsaveview()
                    vim.cmd.normal 'gggqG'
                    vim.fn.winrestview(view)
                end,
                desc = 'Format Org file on save',
            })
            require('r.utils').register_au_id(id)

            vim.api.nvim_create_user_command('Agenda', function()
                require('orgmode').action 'agenda.prompt'
            end, { desc = 'Open Orgmode agenda' })
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
        config = {
            disable_mappings = true,
            wiki_path = { '~/Documents/Orgs/', '~/Documents/Projects/' },
            diary_path = '~/Documents/Orgs/diary/',
        },
    },
}
