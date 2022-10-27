vim.keymap.set(
    'n',
    '<CR>',
    require('orgWiki.wiki').followOrCreate,
    { buffer = true, desc = 'Follow file under cursor' }
)
vim.keymap.set('n', '<BS>', require('orgWiki.wiki').back, { buffer = true, desc = 'Return to previous file' })
vim.keymap.set('n', ']w', require('orgWiki.wiki').gotoNext, { buffer = true, desc = 'Jump to next link' })
vim.keymap.set('n', '[w', require('orgWiki.wiki').gotoPrev, { buffer = true, desc = 'Jump to previous link' })
vim.keymap.set('n', 'K', require('orgWiki.wiki').hover, { buffer = true, desc = 'Preview link in popup window' })

local id = {}
id.OrgMode = vim.api.nvim_create_augroup('OrgMode', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.org',
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd.normal 'gggqG'
        vim.fn.winrestview(view)
    end,
    desc = 'Format Org file on save',
})
require('r.utils').register_au_id(id)
