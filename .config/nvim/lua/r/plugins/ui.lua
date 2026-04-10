local ui = {}

------------------------------------------------------------------------
--                              Snacks                                --
------------------------------------------------------------------------

local cached_workspace_folders = nil

local function get_workspace_folders()
    if cached_workspace_folders then
        return cached_workspace_folders
    end
    cached_workspace_folders = require('r.utils.tables').workspace_folderes
    return cached_workspace_folders
end

local sf = function(module, cmd, args)
    return function()
        if not cmd and not args then
            ---@diagnostic disable-next-line
            Snacks[module]()
        else
            ---@diagnostic disable-next-line
            Snacks[module][cmd](args and args)
        end
    end
end

local snacks_keys = {
    { ']r', sf('words', 'jump', vim.v.count1), desc = 'Next Reference', mode = { 'n', 't' } },
    { '[r', sf('words', 'jump', -vim.v.count1), desc = 'Prev Reference', mode = { 'n', 't' } },
    { '<leader>go', sf 'gitbrowse', desc = 'Open git remote for current file' },
    { '<leader>sa', sf 'scratch', desc = 'Create scratch buffer' },
    { '<leader>ss', sf('scratch', 'select'), desc = 'Select scratch buffer' },
    {
        '<Space>p',
        sf('picker', 'projects', { dev = get_workspace_folders() }),
        desc = 'Projects',
    },
    { '<leader><leader>e', sf 'explorer', desc = 'Toggle Explorer' },
}

------------------------------------------------------------------------
--                              Snacks Modules                        --
------------------------------------------------------------------------

local default = { enabled = true }

-- ************** Startup screen  --------------------------------------
local dashboard = {
    sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        {
            title = 'Orgmode',
            icon = ' ',
        },
        {
            title = 'Agenda',
            indent = 3,
            action = function()
                require('orgmode').agenda:agenda()
            end,
            key = 'a',
        },
        {
            title = 'Capture',
            indent = 3,
            action = '<leader>oc',
            key = 'C',
            padding = 1,
            gap = 2,
        },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
        -- { section = 'startup' },
    },
}

-- ************** Indent guides  --------------------------------------
local indent_hl = {
    'SnacksIndent1',
    'SnacksIndent2',
    'SnacksIndent3',
    'SnacksIndent4',
    'SnacksIndent5',
    'SnacksIndent6',
    'SnacksIndent7',
    'SnacksIndent8',
}

local indent = {
    animate = { enabled = false },
    scope = {
        enabled = true,
        underline = true,
        hl = indent_hl,
    },
    indent = { only_current = true },
    chunk = {
        enabled = true,
        hl = indent_hl,
        char = {
            corner_top = '╭',
            corner_bottom = '╰',
        },
    },
}

function ui.snacks_init()
    local id = { OilRename = vim.api.nvim_create_augroup('OilRename', { clear = true }) }
    vim.api.nvim_create_autocmd('User', {
        group = id.OilRename,
        pattern = 'OilActionsPost',
        callback = function(event)
            if event.data.actions[1].type == 'move' then
                ---@diagnostic disable-next-line
                Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
            end
        end,
        desc = 'Initiate lsp rename via Snacks on Oil file rename',
    })

    require('r.utils').register_au_id(id)

    ---@diagnostic disable-next-line
    vim.print = function(...)
        ---@diagnostic disable-next-line
        return Snacks.debug.inspect(...)
    end

    for _, item in ipairs(snacks_keys) do
        local mode = item[4] or 'n'
        local key = item[1]
        local callback = item[2]
        local desc = item[3]
        vim.keymap.set(mode, key, function()
            callback()
        end, { desc = desc })
    end
end

-- ************** general ---------------------------------------------
ui.snacks_opts = {
    dashboard = dashboard,
    dim = default,
    gitbrowse = default,
    image = default,
    indent = indent,
    notifier = default,
    scope = { treesitter = { blocks = { enabled = true } } },
    rename = default,
    statuscolumn = { folds = { open = true } },
    words = { jumplist = false },
    zen = { toggle = { dim = true } },
}

------------------------------------------------------------------------
--                              Lualine                               --
------------------------------------------------------------------------

local center_sep = '%='

local function rootDir()
    local val = vim.fn.expand '%'
    if string.find(val, 'term://') then
        val = ' ' .. vim.fn.fnamemodify(val, ':p:t')
    elseif val then
        val = '🗀 ' .. vim.fs.dirname(val)
    end
    return val
end

local tab_cond = function()
    return #vim.api.nvim_list_tabpages() > 1
end

------------------------------------------------------------------------
--                  Statusline Winbar Tabline                         --
------------------------------------------------------------------------
local line_sections = {
    lualine_a = { 'mode' },
    lualine_b = {
        'branch',
        {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
        },
    },
    lualine_c = {
        center_sep,
        'diagnostics',
        {
            'filename',
            newfile_status = true,
            symbols = {
                readonly = '🔒',
                modified = '✏️',
                unnamed = '📄',
                newfile = '🗎',
            },
        },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
}

function ui.lualine()
    local lualine = require 'lualine'

    local config = lualine.get_config()

    config.sections = line_sections
    config.options.disabled_filetypes.statusline = { 'snacks_dashboard', 'trouble' }

    config.options.section_separators = { right = '', left = '' }
    config.options.component_separators = ''

    -- ************** Tabline ----------------------------------------------
    config.tabline = {
        lualine_a = { { 'tabs', cond = tab_cond } },
        lualine_c = { { 'buffers', cond = tab_cond } },
        lualine_z = { { rootDir, cond = tab_cond } },
    }
    config.options.always_show_tabline = false

    config.options.disabled_filetypes.winbar = require('r.utils.tables').ignoreFiles

    config.extensions = { 'lazy', 'man', 'quickfix' }

    lualine.setup(config)
end

return ui
