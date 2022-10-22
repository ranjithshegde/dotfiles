local o = vim.o
local opt = vim.opt

------------------------------------------------------------------------
--                              General                               --
------------------------------------------------------------------------

return function()
    vim.cmd.colorscheme 'duskfox'
    local tab = 4
    o.title = true
    o.number = true
    o.expandtab = true
    o.smartcase = true
    o.ignorecase = true
    o.shiftround = true
    o.splitbelow = true
    o.splitright = true
    o.termguicolors = true
    o.relativenumber = true
    o.hlsearch = false
    o.tabstop = tab
    o.shiftwidth = tab
    o.softtabstop = tab
    o.cmdheight = 0
    o.laststatus = 3
    o.scrolloff = 10
    o.updatetime = 1000
    o.timeoutlen = 100
    o.conceallevel = 1
    o.mouse = 'n'
    o.foldcolumn = 'auto'
    o.jumpoptions = 'view'
    o.foldmethod = 'expr'
    o.inccommand = 'split'
    o.spelloptions = 'camel'
    o.grepformat = '%f:%l:%c:%m'
    o.foldexpr = 'nvim_treesitter#foldexpr()'
    o.grepprg = 'rg --vimgrep --smart-case --hidden'
    o.spellfile = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'

    opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }
    opt.guifont = {
        'FiraCode Nerd Font:style=Medium:h12',
        'Noto Sans Devanagari:style=Medium:h10',
        'JoyPixels:h12',
    }
    opt.fillchars = {
        fold = ' ',
        foldopen = '▾',
        foldsep = '│',
        foldclose = '▸',
        horiz = '━',
        horizup = '┻',
        horizdown = '┳',
        stlnc = '»',
        vert = '┃',
        vertleft = '┫',
        vertright = '┣',
        verthoriz = '╋',
    }
    opt.dictionary = {
        '/usr/share/dict/us',
        '/usr/share/dict/british',
    }

    opt.shortmess:append 'cs'
    opt.foldopen:append 'jump'
    opt.clipboard:append 'unnamedplus'
    opt.sessionoptions:append 'terminal,tabpages'

    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_python3_provider = 0
    vim.g.markdown_folding = 1
    vim.g.tex_conceal = 'abdmgs'
    vim.g.tex_flavor = 'latex'
    vim.g.symbols_outline = { auto_preview = false, width = 40 }

    -- ************** Disable builtin plugins ---------------------------------------------------------
    for _, plugin in pairs(require('r.utils.tables').disabled_builtins) do
        vim.g['loaded_' .. plugin] = 1
    end
    vim.g.did_load_ftplugin = 1

    -- ************** HighlightOnYank ---------------------------------------------------------
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
        end,
        desc = 'Highlight yanked text',
    })
end
