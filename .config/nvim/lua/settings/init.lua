local settings = {}

local o = vim.opt
require("impatient").enable_profile()

------------------------------------------------------------------------
--                              General                               --
------------------------------------------------------------------------

function settings.options()
    vim.cmd "colo duskfox"
    local tab = 4
    -- o.list = true
    o.number = true
    o.expandtab = true
    o.cursorline = true
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
    o.grepprg = "rg --vimgrep --smart-case --hidden"
    o.grepformat = "%f:%l:%c:%m"
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
    o.listchars:append "eol:↲"
    o.foldexpr = "nvim_treesitter#foldexpr()"
    o.completeopt = "menu,menuone,noinsert,noselect"
    o.dictionary = os.getenv "XDG_DATA_HOME" .. "/dict/words"
    o.tabline = [[%!luaeval('require("statusline").tabs()')]]
    o.sessionoptions:append "terminal,tabpages"
    o.clipboard:append "unnamedplus"
    o.shortmess:append "c"
    vim.g.termdebug_wide = 1
    vim.g.markdown_folding = 1
    vim.g.tex_conceal = "abdmgs"
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.netrw_browsex_viewer = "xdg-open"
    vim.g.symbols_outline = { auto_preview = false, width = 40 }

    -- ************** Disable builtin plugins ---------------------------------------------------------
    local disabled_built_ins = {
        "fzf",
        "tar",
        "zip",
        "gzip",
        "zipPlugin",
        "tarPlugin",
        "vimball",
        "vimballPlugin",
        "getscript",
        "getscriptPlugin",
        "2html_plugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "shada",
        "matchit",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
    }

    for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
    end

    -- ************** HighlightOnYank ---------------------------------------------------------
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
        end,
    })
end

------------------------------------------------------------------------
--                       Custom Folds            	                  --
------------------------------------------------------------------------

function settings.folds()
    require("pretty-fold").setup {
        fill_char = "━",
        sections = {
            left = {
                "━ ",
                function()
                    return string.rep("*", vim.v.foldlevel)
                end,
                " ━┫",
                "content",
                "     ",
                "number_of_folded_lines",
                " ┣",
            },
            right = {
                "┫ ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ┣━━",
            },
        },
    }
    require("pretty-fold.preview").setup {
        key = "l",
        border = "double",
    }
end

return settings
