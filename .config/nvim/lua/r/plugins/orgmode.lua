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

-- UI handler for orgmode menus using native Neovim float APIs
function settings.ui_handler(data)
    local items = data.items or {}
    local lines = {}
    local keymaps = {}

    for _, item in ipairs(items) do
        if item.key and item.label then
            table.insert(lines, string.format('  %s  ➜  %s', item.key, item.label))
            keymaps[item.key] = item.action
        end
    end

    -- Create scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = 'wipe'

    -- Window dimensions
    local width = 0
    for _, l in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(l))
    end
    width = math.max(width + 2, 30)
    local height = #lines

    -- Center in editor
    local row = math.floor((vim.o.lines - height - 2) / 2)
    local col = math.floor((vim.o.columns - width - 2) / 2)

    local win = vim.api.nvim_open_win(buf, false, {
        relative = 'editor',
        row = row,
        col = col,
        width = width,
        height = height,
        style = 'minimal',
        border = 'rounded',
        title = ' ' .. (data.title or 'Org Menu') .. ' ',
        title_pos = 'center',
        footer = ' <key> to select  <Esc> to close ',
        footer_pos = 'center',
    })

    -- Highlight: dim the arrow, accent the key
    for i, item in ipairs(items) do
        if item.key then
            vim.api.nvim_buf_add_highlight(buf, 0, 'DiagnosticOk', i - 1, 2, 2 + #item.key)
            vim.api.nvim_buf_add_highlight(buf, 0, 'Comment', i - 1, 2 + #item.key, 2 + #item.key + 5)
        end
    end

    vim.wo[win].winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:Title'
    vim.cmd.redraw()

    -- Block for a single keypress then close
    local ok, char = pcall(vim.fn.nr2char, vim.fn.getchar())
    vim.api.nvim_win_close(win, true)
    vim.cmd.redraw()

    if ok and char ~= '\27' then -- \27 = Esc
        local action = keymaps[char]
        if action then
            action()
        end
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

settings.config = {
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

return settings
