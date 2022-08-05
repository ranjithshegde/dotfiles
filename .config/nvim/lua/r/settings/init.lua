local o = vim.opt

------------------------------------------------------------------------
--                              General                               --
------------------------------------------------------------------------

return function()
    vim.cmd.colorscheme "nightfox"
    local tab = 4
    o.title = true
    o.number = true
    o.showmatch = true
    o.expandtab = true
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
    o.updatetime = 300
    o.timeoutlen = 100
    o.conceallevel = 1
    o.mouse = "n"
    o.foldcolumn = "auto"
    o.jumpoptions = "view"
    o.foldmethod = "expr"
    o.inccommand = "split"
    o.spelloptions = "camel"
    o.grepformat = "%f:%l:%c:%m"
    o.grepprg = "rg --vimgrep --smart-case --hidden"
    o.spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"

    o.completeopt = { "menu", "menuone", "noinsert", "noselect" }
    o.guifont = {
        "FiraCode Nerd Font:style=Medium",
        "Noto Sans Devanagari:style=Medium",
        "JoyPixels",
        "Hack Nerd Font",
        "Noto Sans Mono:style=Regular",
        "DejaVuSansMono Nerd Font:style=book",
    }
    o.fillchars = {
        fold = " ",
        foldopen = "▾",
        foldsep = "│",
        foldclose = "▸",
        horiz = "━",
        horizup = "┻",
        horizdown = "┳",
        stlnc = "»",
        vert = "┃",
        vertleft = "┫",
        vertright = "┣",
        verthoriz = "╋",
    }
    o.dictionary = {
        "/usr/share/dict/us",
        "/usr/share/dict/british",
    }

    o.shortmess:append "c"
    o.foldopen:append "jump"
    o.clipboard:append "unnamedplus"
    o.sessionoptions:append "terminal,tabpages"
    o.foldexpr = "nvim_treesitter#foldexpr()"

    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.markdown_folding = 1
    vim.g.tex_conceal = "abdmgs"
    vim.g.symbols_outline = { auto_preview = false, width = 40 }

    -- ************** Disable builtin plugins ---------------------------------------------------------
    for _, plugin in pairs(require("r.utils.tables").disabled_builtins) do
        vim.g["loaded_" .. plugin] = 1
    end
    vim.g.did_load_ftplugin = 1

    -- ************** HighlightOnYank ---------------------------------------------------------
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
        end,
        desc = "Highlight yanked text",
    })
end
