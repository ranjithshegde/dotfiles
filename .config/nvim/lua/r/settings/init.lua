local o = vim.o
local opt = vim.opt

------------------------------------------------------------------------
--                              General                               --
------------------------------------------------------------------------

return function()
    vim.cmd.colorscheme 'tokyonight-night'
    local tab = 4
    o.exrc = true
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
    o.scrolloff = 10
    o.laststatus = 3
    o.foldlevel = 99
    o.conceallevel = 1
    o.timeoutlen = 100
    o.updatetime = 1000
    o.foldlevelstart = 99
    o.mouse = 'n'
    o.foldcolumn = 'auto'
    o.jumpoptions = 'view'
    o.inccommand = 'split'
    o.spelloptions = 'camel'
    o.grepformat = '%f:%l:%c:%m'
    o.grepprg = 'rg --vimgrep --smart-case --hidden'
    o.spellfile = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'

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
    opt.wildoptions:append 'fuzzy'
    opt.diffopt:append 'linematch:60'
    opt.clipboard:append 'unnamedplus'
    opt.sessionoptions:append 'terminal,tabpages'

    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_python3_provider = 0
    vim.g.tex_flavor = 'latex'
    vim.g.tex_conceal = 'abdmgs'

    if vim.g.is_win32 then
        o.shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'powershell'
        o.shellcmdflag =
            '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        vim.cmd 'set shellquote= shellxquote='
    end
end
