local function ui_handler(data)
    local popup = require 'nui.popup' {
        enter = false,
        focusable = false,
        relative = 'editor',
        position = '50%',
        size = {
            width = 60,
            height = #data.items + 2,
        },
        border = {
            style = 'single',
            text = {
                top = data.title,
                top_align = 'center',
            },
        },
        win_options = {
            winhighlight = 'Normal:Winbar,FloatBorder:Cursor',
        },
    }

    local lines = {}
    local keymaps = {}

    for _, item in ipairs(data.items) do
        if item.key and item.label then
            table.insert(lines, string.format(' %s ➜ %s', item.key, item.label))
            keymaps[item.key] = item.action
        end
    end

    popup:mount()
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
    vim.cmd.redraw() -- Force redraw like in the original

    -- Get character and handle it immediately, like in the original
    local char = vim.fn.nr2char(vim.fn.getchar())
    local action = keymaps[char]

    -- Close window first, then execute action if exists
    popup:unmount()
    vim.cmd.redraw() -- Force redraw after unmount too

    if action then
        action()
    end
end

local templates = {
    r = {
        description = 'Refilable Task',
        template = '* TODO %?\n%u',
        headline = 'Tasks',
        target = '~/Documents/Agenda/refile.org',
    },
    t = {
        description = 'Personal Task',
        template = '* TODO %?\n%u',
        headline = 'Tasks',
        target = '~/Documents/Agenda/Personal.org',
    },
    T = {
        description = 'Work Task',
        template = '* TODO %?\n%u',
        headline = 'Tasks',
        target = '~/Documents/Agenda/work.org',
    },
    c = {
        description = 'Personal calendar entry',
        template = '* MEET %?\nSCHEDULED: %^{Meeting Time}T\n',
        headline = 'Calendar',
        target = '~/Documents/Agenda/Personal.org',
    },
    C = {
        description = 'Work calendar entry',
        template = '* MEET %?\nSCHEDULED: %^{Meeting Time}T\n',
        headline = 'Calendar',
        target = '~/Documents/Agenda/work.org',
    },
    g = {
        description = 'GameDev Task',
        template = '* TODO %?\n%u',
        headline = 'Tasks',
        target = '~/Documents/Agenda/GameDev.org',
    },
    G = {
        description = 'GameDev calendar entry',
        template = '* MEET %?\nSCHEDULED: %^{Meeting Time}T\n',
        headline = 'Calendar',
        target = '~/Documents/Agenda/GameDev.org',
    },
}

local function org_init()
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
end

return {
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        cmd = 'Org',
        init = org_init,
        config = function()
            require('orgmode').setup {
                org_agenda_files = {
                    '~/Documents/Agenda/*',
                    '~/Documents/Agenda/*/*',
                    '~/Documents/Agenda/*/*/*',
                    '~/Documents/Agenda/*/*/*/*',
                },
                org_default_notes_file = '~/Documents/notes.org',
                org_todo_keywords = {
                    'TODO(t)',
                    'NEXT(n)',
                    'PROGRESS(p)',
                    'WAITING(w)',
                    'MEET(m)',
                    '|',
                    'DONE(d)',
                    'CANCELLED(c)',
                    'DELEGATED(l)',
                },
                win_split_mode = { 'float' },
                org_hide_emphasis_markers = true,
                org_log_into_drawer = 'LOGBOOK',
                org_highlight_latex_and_related = 'entities',
                org_startup_indented = true,
                org_indent_mode_turns_off_org_adapt_indentation = false,
                org_indent_mode_turns_on_hiding_stars = false,
                org_id_link_to_org_use_id = true,
                ui = { menu = { handler = ui_handler } },
                org_capture_templates = templates,
            }
        end,
        keys = {
            {
                '<leader>oa',
                function()
                    return Org.agenda()
                end,
            },
            {
                '<leader>oc',
                function()
                    return Org.capture()
                end,
            },
        },
    },
    {
        'chipsenkbeil/org-roam.nvim',
        dependencies = 'nvim-orgmode/orgmode',
        config = function()
            require('org-roam').setup {
                directory = '~/Documents/Wiki/',
                bindings = { prefix = '<leader>w' },
            }
        end,
        keys = { '<leader>w' },
    },
}
