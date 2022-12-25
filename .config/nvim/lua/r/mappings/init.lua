local wk = require 'which-key'
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Vim config files                      --
------------------------------------------------------------------------

local open = function(path)
    return function()
        local cmd = 'edit'
        if vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) ~= '' then
            cmd = 'tabnew'
        end
        vim.cmd[cmd] { args = { vim.fn.stdpath 'config' .. '/' .. path } }
    end
end

local num = 1
local function open_term(split)
    return function()
        local open_num = nil
        if vim.v.count ~= 0 then
            open_num = vim.v.count
        else
            open_num = num
            num = num + 1
        end
        vim.notify('Opening terminal indexed ' .. open_num)
        if not split then
            require('harpoon.term').gotoTerminal(open_num)
            return
        end
        local args = { idx = open_num }
        if split == 'split' then
            args.create_with = 'botright new | terminal'
        elseif split == 'vsplit' then
            args.create_with = 'belowright vnew | terminal'
        elseif split == 'tabnew' then
            args.create_with = 'tabnew | terminal'
        end
        -- vim.cmd[split]()
        require('harpoon.term').gotoTerminal(args)
    end
end

local function config_files()
    wk.register {
        ['<leader>'] = {
            a = {
                name = 'vimrc files',
                -- Update plugins
                P = { require('lazy').sync, 'Update packages' },
                -- Reload config
                R = { require('r.utils').restart, 'Reload Vim' },

                -- Internal `after/plugin` file
                c = { open 'after/plugin/plugin.lua', 'User defined commands' },
                -- Main vimRC
                r = { open 'init.lua', 'VimRC' },
                -- Plugin config and list
                p = { open 'lua/r/lazy.lua', 'Plugin config' },

                -- Vim options
                o = {
                    name = 'Options',
                    o = { open 'lua/r/settings/init.lua', 'vim options' },
                    a = { open 'lua/r/settings/autocmds.lua', 'Autocmds' },
                    t = { open 'lua/r/settings/tabline.lua', 'Tabline' },
                    w = { open 'lua/r/settings/winbar.lua', 'Winbar' },
                },

                -- Plugin settings and configurations
                s = {
                    name = 'Plugin settings',
                    t = { open 'lua/r/plugins/telescope.lua', 'Telescope' },
                    s = { open 'lua/r/plugins/treesitter.lua', 'Treesitter' },
                    f = { open 'lua/r/plugins/folds.lua', 'Foldtext' },
                    c = { open 'lua/r/plugins/completion.lua', 'Completion' },
                    p = { open 'lua/r/plugins/init.lua', 'Small configs' },
                    e = { open 'lua/r/plugins/statusline.lua', 'Express statusline' },
                    n = { open 'lua/r/plugins/noice.lua', 'Noice UI' },
                },

                -- All keymaps (plugin and internal)
                m = {
                    name = 'Mappings',
                    m = { open 'lua/r/mappings/init.lua', 'Common' },
                    l = { open 'lua/r/mappings/lsp.lua', 'Lsp' },
                    c = { open 'lua/r/mappings/clang.lua', 'C/C++' },
                    u = { open 'lua/r/mappings/util.lua', 'Misc' },
                    t = { open 'lua/r/mappings/telescope.lua', 'Telescope' },
                    s = { open 'lua/r/mappings/treesitter.lua', 'Treesitter' },
                    g = { open 'lua/r/mappings/git.lua', 'Git' },
                    p = { open 'lua/r/mappings/pairs.lua', 'Unimpaired' },
                },

                -- LSP settings and extensions
                l = {
                    name = 'Lsp',
                    s = { open 'lua/r/lsp/init.lua', 'Functions and Inits' },
                    r = { open 'lua/r/lsp/rename.lua', 'Incremental rename' },
                    c = { open 'lua/r/lsp/clangd.lua', 'Clangd' },
                    l = { open 'lua/r/lsp/ltex.lua', 'Ltex LS' },
                    t = { open 'lua/r/lsp/texlab.lua', 'Texlab LSP' },
                },

                -- Dap configs and tools
                d = {
                    name = 'Debug adapter protocol',
                    a = { open 'lua/r/debuggers/adapters.lua', 'Adapters' },
                    c = { open 'lua/r/debuggers/configs.lua', 'Configurations' },
                    d = { open 'lua/r/debuggers/init.lua', 'DAP' },
                },

                -- Local plugins and extensions
                e = {
                    name = 'Custom plugins and extensions',
                    c = { open 'lua/r/extensions/cpp.lua', 'Cpp Workstation' },
                    e = { open 'lua/r/extensions/init.lua', 'General' },
                    d = { open 'lua/r/extensions/diagnostics/init.lua', 'Diagnostic extensions' },
                    q = { open 'lua/r/extensions/qf.lua', 'Quickfix and Loclist' },
                    s = { open 'lua/r/extensions/project/scratchpad.lua', 'ScratchPad' },
                    p = { open 'lua/r/extensions/project/init.lua', 'Initiate project' },
                },

                -- Basic utility functions
                u = {
                    name = 'Common & utility functions',
                    u = { open 'lua/r/utils/init.lua', 'General' },
                    t = { open 'lua/r/utils/tables.lua', 'Filter tables' },
                },

                -- Filetype specific configs
                f = {
                    name = 'Filetype Plugins',
                    c = { open 'after/ftplugin/cpp.lua', 'Cpp' },
                    g = { open 'after/ftplugin/glsl.lua', 'Glsl' },
                    j = { open 'after/ftplugin/javascript.lua', 'JavaScript' },
                    l = { open 'after/ftplugin/lua.lua', 'Lua' },
                    o = { open 'after/ftplugin/org.lua', 'Orgmode' },
                    t = { open 'after/ftplugin/tex.lua', 'Latex' },
                    f = { open 'filetype.lua', 'Ftdetect' },
                },

                -- Treesitter highlight queries
                q = {
                    name = 'Treesitter queries',
                    m = { open 'after/queries/markdown/highlights.scm', 'Markdown' },
                    o = { open 'after/queries/org/highlights.scm', 'Org' },
                },
            },
        },
    }
end

------------------------------------------------------------------------
--                              General mappings                      --
------------------------------------------------------------------------

return function()
    config_files()

    local opts = { nowait = true, silent = true }
    -- Extend C-keys
    map('n', '<C-;>', ';')
    map('n', '<C-,>', ',')
    map('n', '<C-i>', '<C-i>', { desc = 'Dont map C-i to Tab' })
    map({ 'n', 'i', 's' }, '<BS>', '<BS>', { desc = 'Dont map C-h to backspace' })

    --line movement
    map('x', 'K', ":move '<-2<CR>gv", { desc = 'Move line up' })
    map('x', 'J', ":move '>+1<CR>gv", { desc = 'Move line down' })
    -- visual cut for replase
    map({ 'v', 's' }, 'P', '"_dP', opts)
    -- Indent
    map('v', '<', '<gv', opts)
    map('v', '>', '>gv', opts)

    -- Toggle folds
    map('n', '<Tab>', 'za', { desc = 'Toggle fold current' })
    map('n', '<S-Tab>', 'zA', { desc = 'Toggle fold All' })
    -- open folds when searching
    map('n', 'n', 'nzzzv', { desc = 'jump to next search result' })
    map('n', 'N', 'Nzzzv', { desc = 'jump to previous search result' })
    map('n', 'J', 'mzJ`z', { desc = 'Adjoin next line' })

    --Quickfix
    map('n', '-', function()
        require('r.extensions.qf').toggle_qf 'q'
    end, { desc = 'Toggle quickfix' })
    map('n', '_', function()
        require('r.extensions.qf').toggle_qf 'l'
    end, { desc = 'Toggle loclist' })
    -- ScratchPad
    map('n', '<leader>S', function()
        require 'r.extensions.project.scratchpad' 'tab'
    end, { desc = 'Open ScratchPad' })

    -- Misc
    map('n', 'gx', function()
        local word = vim.fn.expand '<cWORD>'
        local begin = word:find '%('
        if begin then
            word = word:sub(begin + 1):gsub('%)', '')
        else
            begin = word:find '%['
            if begin then
                word = word:gsub('%[', '')
                local ends = word:find '%]'
                if ends then
                    word = word:sub(begin, ends - 1)
                end
            end
        end

        require('r.utils').open_in_browser(word)
    end, { desc = 'exec word under cursor' })

    map('n', 'gm', function()
        local virt = vim.fn.virtcol '$'
        vim.fn.cursor { 0, virt / 2 }
    end, { desc = 'Move cursor to middle of the line' })

    -- Terminals and Jobs
    map('n', '<leader>C', function()
        require('overseer').run_template { name = 'shell' }
    end, { desc = 'Run quick command with Overseer' })

    map('n', '<leader>c', function()
        require('overseer').run_template()
    end, { desc = 'Run task  with Overseer' })

    map({ 'n', 't' }, '<F9>', function()
        vim.cmd.stopinsert()
        require('r.extensions').toggleTerm('zsh', 'shell', 1)
    end, {
        desc = 'Toggle current/default terminal',
    })

    wk.register {
        ['<leader>t'] = {
            name = 'Launch terminal in split',
            h = { open_term 'split', 'Horizontal' },
            v = { open_term 'vsplit', 'Vertical' },
            t = { open_term 'tabnew', 'New tab' },
        },
    }

    map('n', "<leader>'", function()
        require('harpoon.ui').nav_next()
    end, { desc = 'Navigate to next harpooned file' })

    map('n', '<leader>`', function()
        require('harpoon.ui').nav_prev()
    end, { desc = 'Navigate to previous harpooned file' })

    map('n', '<leader><Tab>', open_term(), { desc = 'Navigate to harpooned terminal' })

    map('n', '<leader><leader>', function()
        require('harpoon.ui').toggle_quick_menu()
    end, { desc = 'Open harpoon list' })

    map('n', '<leader><Space>', function()
        require('harpoon.mark').add_file()
    end, { desc = 'Harpoon current file' })
end
