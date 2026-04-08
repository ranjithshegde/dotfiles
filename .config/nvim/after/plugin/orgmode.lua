local utils = require 'r.utils'
local settings = require 'r.plugins.orgmode'
local add = vim.pack.add

local opts = {
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
}

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
            require('orgmode').setup(opts)
        end)
        utils.lazy_command('Org', 'orgmode')
        utils.lazy_event('FileType', 'orgmode', 'org')
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

settings.org_init()

vim.keymap.set('n', '<leader>oa', '<cmd>Org agenda<cr>', { desc = 'Open org agenda' })
vim.keymap.set('n', '<leader>oc', '<cmd>Org capture<cr>', { desc = 'Open org capture' })
