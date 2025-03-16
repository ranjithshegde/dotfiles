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

local function init()
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
end

------------------------------------------------------------------------
--                              Modules                               --
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
        { section = 'startup' },
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

-- ************** general ---------------------------------------------
local opts = {
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

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    init = init,
    opts = opts,
    keys = {
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
    },
}
