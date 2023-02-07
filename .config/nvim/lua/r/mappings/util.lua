local utilmaps = {}
local wk = require 'which-key'
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Utilities                             --
------------------------------------------------------------------------

local function ranger(path, cmd, opts)
    return function()
        if vim.g.is_win32 then
            vim.notify(
                'ranger is not available in Windows. Use `:Telescope file-browser` instead',
                vim.log.levels.ERROR,
                { title = 'Ranger' }
            )
            return
        end
        vim.api.nvim_open_win(
            0,
            true,
            opts or { relative = 'editor', row = 0, col = 30, width = 150, height = 150, border = 'double' }
        )
        require('r.extensions').ranger(path, cmd)
    end
end

function utilmaps.ranger()
    wk.register {
        ['<leader>r'] = {
            name = 'Ranger file picker',
            r = { ranger('%:p:h', 'e '), 'from current file' },
            R = { ranger('.', 'e '), 'from current directory' },
            v = { ranger('%:h', 'vs '), 'in a split from current file' },
            V = { ranger('.', 'vs '), 'in a split from current directory' },
            t = { ranger('%:p:h', 'tab drop '), 'in a new tab from current file' },
            T = { ranger('.', 'tab drop '), 'in a new tab from current directory' },
        },
    }
end

function utilmaps.wordProcessor()
    map('n', '<leader><Space>', function()
        vim.cmd.global "/^/pu=''"
    end, { desc = 'Double space entire file' })
    map('n', ',K', function()
        require('r.utils').dictionary(vim.fn.expand '<cword>')
    end, { desc = 'Lookup Wikitionary' })
    map('n', ',T', function()
        require('r.utils').thesaurus(vim.fn.expand '<cword>')
    end, { desc = 'Lookup Synonyms' })
end

-- ******************************** orgWiki -----------------------
function utilmaps.orgWiki()
    wk.register {
        ['<leader>w'] = {
            name = 'orgWiki',
            w = {
                function()
                    require('orgWiki.wiki').openIndex()
                end,
                'Open Index',
            },
            n = {
                function()
                    require('orgWiki.wiki').nextWiki 'tabnew'
                end,
                'Open next wiki Index',
            },
            c = {
                function()
                    require('orgWiki.wiki').select 'tabnew'
                end,
                'Open next wiki Index',
            },
            t = {
                function()
                    require('orgWiki.wiki').openIndex 'tab drop'
                end,
                'Open Index in a new tab',
            },
            d = {
                function()
                    require('orgWiki.wiki').deleteLink()
                end,
                'Delete link under cursor',
            },
            i = {
                function()
                    require('orgWiki.diary').diaryIndexOpen()
                end,
                'Open Diary index',
            },
            ['<leader>'] = {
                name = 'Diary entries',
                w = {
                    function()
                        require('orgWiki.diary').diaryTodayOpen()
                    end,
                    'Today',
                },
                t = {
                    function()
                        require('orgWiki.diary').diaryTodayOpen 'tab drop'
                    end,
                    'Today in a new tab',
                },
                i = {
                    function()
                        require('orgWiki.diary').diaryGenerateIndex()
                    end,
                    'Reindex',
                },
                y = {
                    function()
                        require('orgWiki.diary').diaryYesterdayOpen()
                    end,
                    'Yesterday',
                },
                m = {
                    function()
                        require('orgWiki.diary').diaryTomorrowOpen()
                    end,
                    'Tomorrow',
                },
            },
        },
    }
end

function utilmaps.noice()
    wk.register {
        ['<leader>n'] = {
            name = 'Noice',
            n = { vim.cmd.Noice, 'Noice window' },
            e = { vim.cmd.NoiceErrors, 'Open error list' },
            m = { vim.cmd.messages, 'Open messages' },
            c = {
                function()
                    vim.cmd.messages 'clear'
                end,
                'Clear all messaages',
            },
        },
    }
end

return utilmaps
