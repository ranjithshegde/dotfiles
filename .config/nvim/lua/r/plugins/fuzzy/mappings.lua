------------------------------------------------------------------------
--                              FZF-LUA                               --
------------------------------------------------------------------------

local fzf = function(name, args)
    return function()
        require('fzf-lua')[name](args)
    end
end

local function fzf_cd(dir, prompt, cwd)
    if dir then
        return function()
            require('r.plugins.fuzzy.settings').cd_folder(prompt, cwd)
        end
    end
    return function()
        require('r.plugins.fuzzy.settings').cd_files(prompt, cwd)
    end
end

local maps = {
    ['<Space>'] = {
        name = 'FZF',
        b = { fzf 'buffers', 'Buffers' },
        c = { fzf 'commands', 'Vim commands' },
        C = { fzf 'command_history', 'Command history' },
        h = { fzf 'help_tags', 'Help' },
        H = { fzf 'highlights', 'Highlights' },
        j = { fzf 'jumps', 'Jump history' },
        l = { fzf 'loclist', 'local quickfix list' },
        m = { fzf 'man_pages', 'Man pages' },
        -- n = { tel_ext 'noice', 'Notifications' },
        q = { fzf 'quickfix', 'Quickfix list' },
        r = { fzf 'lsp_references', 'Lsp References' },
        R = { fzf 'reloader', 'Reload lua modules' },
        s = { fzf('lsp_document_symbols', { winopts = { row = 1, col = 0 } }), 'Lsp symbols in buffer' },
        S = { fzf 'lsp_live_workspace_symbols', 'Grep lsp workspace symbols' },
        t = {
            name = 'Treesitter',
            n = { fzf 'treesitter', 'TreeSitter nodes in buffer' },
            f = {
                function()
                    require('refactoring').select_refactor()
                end,
                'Treesitter Refactoring options',
                mode = { 'n', 'v' },
            },
        },
        T = { fzf 'tagstack', 'Lsp Ctags' },
        z = { fzf('grep_curbuf', { winopts = { row = 1, col = 0 } }), 'Fuzzy find in buffer' },
        ["'"] = { fzf 'marks', 'Marks' },
        ['"'] = { fzf 'registers', 'Registers' },
        ['='] = { fzf 'spell_suggest', 'Spell suggest' },
        ['/'] = { fzf 'grep', 'Grep CWORD in directory' },
        ['<Space>'] = { fzf 'builtin', 'Builtin Searchers' },
        ['<CR>'] = { fzf 'resume', 'Resume last picker' },
        p = {
            function()
                require('r.plugins.fuzzy.settings').project()
            end,
            'Projects',
        },
        k = {
            function()
                require('fzf-lua').lsp_workspace_symbols { query = vim.fn.expand '<cword>' }
            end,
            'Search lsp workspace symbol',
        },
        d = {
            name = 'diagnostics',
            b = { fzf 'diagnostics_document', 'buffer diagnostics' },
            w = { fzf 'diagnostics_workspace', 'Workspace diagnostics' },
        },
        G = {
            name = 'git commands',
            b = { fzf 'git_branches', 'Branches' },
            c = { fzf 'git_commits', 'Commit history' },
            s = { fzf 'git_status', 'Status' },
            f = { fzf 'git_files', 'Tracked files' },
        },
        g = {
            name = 'Live grep in',
            g = { fzf 'live_grep', 'current directory' },
            s = {
                fzf(
                    'live_grep',
                    { cwd = '~/Workspaces/supercollider/', prompt_title = 'SuperCollider Workspace grep' }
                ),
                'grep SuperCollider',
            },
            o = {
                fzf('live_grep', { cwd = '~/Workspaces/openFrameworks/', prompt_title = 'oF Workspace grep' }),
                'ofWorkspace',
            },
            w = { fzf('live_grep', { cwd = '~/Documents/Orgs/', prompt_title = 'Org Wiki' }), 'Org Grep' },
            d = {
                fzf('live_grep', { cwd = '~/.config', prompt_title = 'Dotfiles' }),
                'grep dotfiles',
            },
            ['?'] = {
                function()
                    require('fzf-lua').live_grep {
                        cwd = vim.fn.input { prompt = 'Enter directory: ', completion = 'dir' },
                    }
                end,
                'Choose directory',
            },
            ['.'] = {
                fzf('live_grep', {
                    cwd = '~/.config/nvim',
                    search_dirs = { 'init.lua', 'lua', 'after', 'plugin', 'ftdetect' },
                    prompt_title = 'vim config',
                }),
                'grep dotfiles',
            },
        },
        f = {
            name = 'find files in',
            f = { fzf 'files', 'Current directory' },
            h = { fzf('files', { cwd = '~' }), 'Home directory' },
            r = { fzf 'oldfiles', 'Vim recent files' },
            R = { fzf('files', { cwd = '/usr/share/nvim/runtime/' }), 'Vim runtime files' },
            C = {
                fzf_cd(false, 'C++ Practice files/dirs', '$CWORK/Scratch'),
                'Open C practice',
            },
            c = { fzf_cd(true, 'C++ Practice files/dirs', '$CWORK/Scratch'), 'Open C practice' },
            s = {
                fzf_cd(true, 'SuperCollider Directory', '~/Workspaces/supercollider/'),
                'SuperCollider files',
            },
            b = {
                fzf('files', { cwd = '~/.local/bin/', prompt_title = 'Scripts and binaries in local' }),
                'scripts & binaries',
            },
            d = {
                fzf('files', { cwd = '~/.config/', find_command = { 'fd', '--hidden' }, prompt_title = 'Dotfiles' }),
                'Dotfiles',
            },
            V = { fzf_cd(true, 'Vim plugins', '~/.local/share/nvim/lazy/'), 'Vim plugin Directory' },
            v = {
                fzf('files', { cwd = '~/.local/share/nvim/lazy', prompt_title = 'Plugin files' }),
                'Vim plugin Directory',
            },
            o = {
                fzf('files', { cwd = '~/Workspaces/openFrameworks/', prompt_title = 'oF Workspace files' }),
                'OfWorkspace',
            },
            ['?'] = {
                function()
                    require('fzf-lua').files {
                        cwd = vim.fn.input { prompt = 'Enter directory: ', completion = 'dir' },
                    }
                end,
                'Choose directory',
            },
            ['.'] = {
                fzf('files', { cwd = '~/.config/nvim', prompt_title = 'Neovim configuration files' }),
                'Neovim config files',
            },
        },
    },
}

local new_maps = require('r.utils.maps').convert_config(maps)
require('which-key').add(new_maps)
