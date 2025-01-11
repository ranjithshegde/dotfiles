local orgmaps = {}
local map = vim.keymap.set

-- ******************************** orgWiki -----------------------
function orgmaps.wiki()
    require('which-key').add(require('r.utils.maps').convert_maps {
        ['<leader>w'] = {
            name = 'orgWiki',
            w = { require('orgWiki.wiki').openIndex, 'Open Index' },
            d = { require('orgWiki.wiki').deleteLink, 'Delete link under cursor' },
            i = { require('orgWiki.diary').diaryIndexOpen, 'Open Diary index' },
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

            ['<leader>'] = {
                name = 'Diary entries',
                w = { require('orgWiki.diary').diaryTodayOpen, 'Today' },
                i = { require('orgWiki.diary').diaryGenerateIndex, 'Reindex' },
                y = { require('orgWiki.diary').diaryYesterdayOpen, 'Yesterday' },
                m = { require('orgWiki.diary').diaryTomorrowOpen, 'Tomorrow' },
                t = {
                    function()
                        require('orgWiki.diary').diaryTodayOpen 'tab drop'
                    end,
                    'Today in a new tab',
                },
            },
        },
    })
end

function orgmaps.ft()
    map('n', '<CR>', require('orgWiki.wiki').followOrCreate, { buffer = true, desc = 'Follow file under cursor' })
    map('n', '<BS>', require('orgWiki.wiki').back, { buffer = true, desc = 'Return to previous file' })
    map('n', ']w', require('orgWiki.wiki').gotoNext, { buffer = true, desc = 'Jump to next link' })
    map('n', '[w', require('orgWiki.wiki').gotoPrev, { buffer = true, desc = 'Jump to previous link' })
    map('n', 'K', require('orgWiki.wiki').hover, { buffer = true, desc = 'Preview link in popup window' })
end

return orgmaps
