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
            require('r.plugins.fzf.settings').cd_folder(prompt, cwd)
        end
    end
    return function()
        require('r.plugins.fzf.settings').cd_files(prompt, cwd)
    end
end

local kind = {
    'Function',
    'Class',
    'Object',
    'Method',
}

local function top_level_kind(item)
    for _, v in ipairs(kind) do
        if item.kind:match(v) then
            return true
        end
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
        m = { '<cmd>Noice fzf<CR>', 'Messages' },
        M = { fzf 'man_pages', 'Man pages' },
        O = { fzf 'lsp_live_workspace_symbols', 'Grep lsp workspace symbols' },
        q = { fzf 'quickfix', 'Quickfix list' },
        t = { fzf 'treesitter', 'TreeSitter nodes in buffer' },
        T = { fzf 'tagstack', 'Lsp Ctags' },
        z = { fzf 'blines', 'Gerp current buffer lines' },
        Z = { fzf 'zoxide', 'Zoxide to Oil' },
        ["'"] = { fzf 'marks', 'Marks' },
        ['"'] = { fzf 'registers', 'Registers' },
        ['='] = { fzf 'spell_suggest', 'Spell suggest' },
        ['/'] = { fzf 'grep_cword', 'Grep CWORD in directory' },
        ['<Space>'] = { fzf 'builtin', 'Builtin Searchers' },
        ['<CR>'] = { fzf 'resume', 'Resume last picker' },
        k = {
            function()
                require('fzf-lua').lsp_workspace_symbols { query = vim.fn.expand '<cword>' }
            end,
            'Search lsp workspace symbol',
        },
        r = {
            fzf('lsp_references', { winopts = require('r.plugins.fzf.settings').layouts.center_stack }),
            'Lsp References',
        },
        s = {
            fzf('lsp_document_symbols', {

                winopts = require('r.plugins.fzf.settings').layouts.partial_stack,
                regex_filter = top_level_kind,
            }),
            'Lsp symbols in buffer',
        },
        S = {
            fzf('lsp_workspace_symbols', {

                winopts = require('r.plugins.fzf.settings').layouts.partial_stack,
                regex_filter = top_level_kind,
            }),
            'Lsp symbols in buffer',
        },
        d = {
            name = 'diagnostics',
            b = { fzf 'diagnostics_document', 'buffer diagnostics' },
            w = { fzf 'diagnostics_workspace', 'Workspace diagnostics' },
        },
        G = {
            name = 'git commands',
            b = { fzf 'git_branches', 'Branches' },
            B = { fzf 'git_blame', 'Blame' },
            c = { fzf 'git_commits', 'Commit history' },
            C = { fzf 'git_bcommits', 'Buffer commit history' },
            s = { fzf 'git_stash', 'Stashes' },
            f = { fzf 'git_files', 'Tracked files' },
        },
        o = {
            name = 'Orgmode',
            a = {
                fzf_cd(false, 'Org Agenda', '$HOME/Documents/Mandala/Agenda'),
                'Org Agenda',
            },
            w = {
                fzf_cd(false, 'Org Wiki', '$HOME/Documents/Mandala/Wiki/'),
                'Org Wiki',
            },
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
            d = {
                fzf('live_grep', { cwd = '~/.config', prompt_title = 'Dotfiles' }),
                'grep dotfiles',
            },
            v = {
                fzf('live_grep', { cwd = '~/.local/share/nvim/lazy', prompt_title = 'Plugin files' }),
                'Vim plugin Directory',
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

            c = { fzf_cd(true, 'C++ Practice files/dirs', '$CWORK/Scratch'), 'Open C practice' },
            C = {
                fzf_cd(false, 'C++ Practice files/dirs', '$CWORK/Scratch'),
                'Open C practice',
            },
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
            O = {
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

local new_maps = require 'r.utils.expand_maps'(maps)
require('which-key').add(new_maps)
