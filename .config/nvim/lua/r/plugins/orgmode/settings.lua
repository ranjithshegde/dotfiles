local settings = {
    paths = {
        root = vim.fs.joinpath(vim.env.HOME, 'Documents/Mandala'),
    },
}

settings.paths.agenda = vim.fs.joinpath(settings.paths.root, 'Agenda')

settings.paths.agenda_files = {
    settings.paths.agenda .. '/*/*/*',
    settings.paths.agenda .. '/*/*',
    settings.paths.agenda .. '/*',
}

settings.todo_keywords = {
    'TODO(t)',
    'NEXT(n)',
    'PROGRESS(p)',
    'WAITING(w)',
    'MEET(m)',
    'APPOINTMENT(s)',
    'FOLLOWUP(f)',
    '|',
    'DELEGATED(l)',
    'DONE(d)',
    'CANCELLED(c)',
}

-- Helper functions
local function get_agenda_path(path)
    return vim.fs.joinpath(settings.paths.agenda, path)
end

-- UI handler for menus
function settings.ui_handler(data)
    local popup = require 'nui.popup' {
        enter = false,
        focusable = false,
        relative = 'editor',
        position = '50%',
        size = {
            width = 60,
            height = #(data.items or {}) + 2,
        },
        border = {
            style = 'single',
            text = {
                top = data.title or 'org menu',
                top_align = 'center',
            },
        },
        win_options = {
            winhighlight = 'normal:winbar,floatborder:Normal',
        },
    }

    local lines, keymaps = {}, {}
    for _, item in ipairs(data.items or {}) do
        if item.key and item.label then
            table.insert(lines, string.format(' %s ➜ %s', item.key, item.label))
            keymaps[item.key] = item.action
        end
    end

    popup:mount()
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
    vim.cmd.redraw()

    local char = vim.fn.nr2char(vim.fn.getchar())
    local action = keymaps[char]
    popup:unmount()
    vim.cmd.redraw()

    if action then
        action()
    end
end

-- Template helpers
local function make_task_template(name)
    return {
        description = name .. ' Task',
        template = '* TODO %?\n%u',
        headline = name == 'Projects' and 'Project Tasks' or name .. ' Tasks',
        target = get_agenda_path(name .. '/Tasks.org'),
    }
end

local function make_meeting_template(name)
    return {
        description = name .. ' Meeting',
        template = '* MEET %?\n%u',
        headline = name == 'Projects' and 'Project Meetings' or name .. ' Meetings',
        target = get_agenda_path(name .. '/Meetings.org'),
    }
end

-- Simplified command creation
local function make_agenda_command(name)
    return {
        description = name,
        types = {
            {
                type = 'tags_todo',
                org_agenda_overriding_header = name .. ' Tasks',
                org_agenda_category_filter_preset = 'Tasks',
                org_agenda_files = { settings.paths.agenda .. '/' .. name .. '/*' },
            },
            {
                type = 'tags_todo',
                org_agenda_overriding_header = name .. ' Meetings',
                org_agenda_category_filter_preset = 'Meetings',
                org_agenda_files = { settings.paths.agenda .. '/' .. name .. '/*' },
            },
        },
    }
end

-- Config setup
function settings.org_init()
    local id = { OrgMode = vim.api.nvim_create_augroup('OrgMode', { clear = true }) }

    vim.api.nvim_create_autocmd('FileType', {
        group = id.OrgMode,
        pattern = 'org',
        once = true,
        callback = function(args)
            require('blink.cmp').add_source_provider('orgmode', {
                name = 'Orgmode',
                module = 'orgmode.org.autocompletion.blink',
            })
            vim.keymap.set('i', '<S-CR>', function()
                require('orgmode').action 'org_mappings.meta_return'
            end, { silent = true, buffer = args.buf })
        end,
        desc = 'Add org completion source, map <S-CR>',
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = id.OrgMode,
        pattern = 'org',
        command = 'setlocal winhighlight=Folded:Headline',
        desc = 'Stop conflicting hl between fold and headline',
    })

    require('r.utils').register_au_id(id)
end

settings.agenda_custom_commmands = {
    d = {
        description = 'Today',
        types = {
            {
                type = 'agenda',
                org_agenda_overriding_header = 'My daily agenda',
                org_agenda_span = 'day',
            },
        },
    },
    w = make_agenda_command 'Work',
    p = make_agenda_command 'Projects',
    n = make_agenda_command 'Personal',
    h = make_agenda_command 'Household',
}

settings.capture_templates = {
    -- Work templates
    w = 'Work',
    wt = make_task_template 'Work',
    wm = make_meeting_template 'Work',

    -- Project templates
    p = 'Projects',
    pt = make_task_template 'Projects',
    pm = make_meeting_template 'Projects',

    -- Personal templates
    P = 'Personal',
    Pt = make_task_template 'Personal',
    Pm = make_meeting_template 'Personal',

    -- Household templates
    h = 'Household',
    hc = {
        description = 'Chores',
        template = '* TODO %?\n%u',
        headline = 'Household Tasks',
        target = get_agenda_path 'Household/Tasks.org',
    },
    ha = {
        description = 'Household Appointment',
        template = '* APPOINTMENT %?\n%u',
        headline = 'Household Appointments',
        target = get_agenda_path 'Household/Appointments.org',
    },

    -- Special templates
    t = {
        description = 'Deferred Task (Tickler)',
        template = '* TODO %?\nSCHEDULED: %t',
        headline = 'Tickler',
        target = get_agenda_path 'Tickler.org',
    },
    x = {
        description = 'General Note',
        template = '* %u %?\n',
        headline = 'General Notes',
        target = settings.paths.root .. '/Notes.org',
        date_tree = true,
    },
    j = {
        description = 'Journal',
        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
        target = settings.paths.root .. 'Journal.org',
        date_tree = true,
    },
}

return settings
