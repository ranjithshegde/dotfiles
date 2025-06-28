-- Plugin configuration
local settings = require 'r.plugins.orgmode.settings'

return {
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        cmd = 'Org',
        init = settings.org_init,
        dependencies = {
            'lukas-reineke/headlines.nvim',
            opts = { org = { codeblock_highlight = '' } },
        },
        opts = {
            org_agenda_files = settings.paths.agenda_files,
            org_agenda_custom_commands = settings.agenda_custom_commmands,
            org_capture_templates = settings.capture_templates,
            org_default_notes_file = vim.fs.joinpath(settings.paths.root, 'Notes.org'),
            org_todo_keywords = settings.todo_keywords,
            win_split_mode = { 'float' },
            org_hide_emphasis_markers = true,
            org_log_into_drawer = 'LOGBOOK',
            org_highlight_latex_and_related = 'entities',
            org_startup_indented = true,
            org_indent_mode_turns_off_org_adapt_indentation = false,
            org_indent_mode_turns_on_hiding_stars = false,
            org_id_link_to_org_use_id = true,
            ui = {
                menu = { handler = settings.ui_handler },
                input = { use_vim_ui = true },
            },
        },
        keys = {
            { '<leader>oa', '<cmd>Org agenda<cr>' },
            { '<leader>oc', '<cmd>Org capture<cr>' },
        },
    },
    {
        'chipsenkbeil/org-roam.nvim',
        dependencies = 'nvim-orgmode/orgmode',
        opts = {
            directory = vim.fs.joinpath(settings.paths.root, 'Wiki'),
            bindings = { prefix = '<leader>w', goto_next_node = ']w', goto_prev_node = '[w' },
        },
        keys = { '<leader>w' },
    },
}
