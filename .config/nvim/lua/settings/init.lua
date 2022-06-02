local settings = {}
local o = vim.opt

------------------------------------------------------------------------
--                              General                               --
------------------------------------------------------------------------

function settings.options()
    vim.cmd "colo duskfox"
    local tab = 4
    o.number = true
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
    o.scrolloff = 10
    o.updatetime = 300
    o.timeoutlen = 100
    o.conceallevel = 1
    o.laststatus = 3
    o.foldmethod = "expr"
    o.inccommand = "split"
    o.spelloptions = "camel"
    o.grepformat = "%f:%l:%c:%m"
    o.grepprg = "rg --vimgrep --smart-case --hidden"
    o.spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
    o.fillchars = {
        fold = ".",
        horiz = "━",
        horizup = "┻",
        horizdown = "┳",
        stlnc = "»",
        vert = "┃",
        vertleft = "┫",
        vertright = "┣",
        verthoriz = "╋",
    }
    o.shortmess:append "c"
    o.listchars:append "eol:↲"
    o.clipboard:append "unnamedplus"
    o.sessionoptions:append "terminal,tabpages"
    o.foldexpr = "nvim_treesitter#foldexpr()"
    o.completeopt = "menu,menuone,noinsert,noselect"
    o.foldtext = [[luaeval('require("settings").foldText()')]]
    o.tabline = [[%!luaeval('require("statusline").tabs()')]]
    o.dictionary = { "/usr/share/dict/us", "/usr/share/dict/british" }

    vim.g.netrw_altv = 1
    vim.g.netrw_winsize = 15
    vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 4
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.markdown_folding = 1
    vim.g.fold_preview = true
    vim.g.tex_conceal = "abdmgs"
    vim.g.symbols_outline = { auto_preview = false, width = 40 }

    -- ************** Disable builtin plugins ---------------------------------------------------------
    for _, plugin in pairs(require("utils.tables").disabled_builtins) do
        vim.g["loaded_" .. plugin] = 1
    end
    vim.g.did_load_ftplugin = 1

    -- ************** HighlightOnYank ---------------------------------------------------------
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
        end,
    })
end

function settings.foldText()
    local foldlines = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldend, true)
    local text = string.format(
        "%s%s%s",
        string.gsub(foldlines[1], "\\t", string.rep(" ", vim.api.nvim_get_option "tabstop")),
        "    +    (" .. (vim.v.foldend - vim.v.foldstart - 1) .. " lines)    +    ",
        vim.fn.trim(foldlines[#foldlines])
    )

    return text
end

return settings
