local settings = {}

local o = vim.opt
require("impatient").enable_profile()

function settings.options()
    require("nightfox").load()
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
    o.foldmethod = "expr"
    o.inccommand = "split"
    o.spelloptions = "camel"
    o.grepprg = "rg --vimgrep --smart-case --hidden"
    o.grepformat = "%f:%l:%c:%m"
    o.fillchars = "stlnc:»,vert:║,fold:."
    o.listchars:append "eol:↲"
    -- o.listchars = "tab:<->,eol:↲,space:→"
    o.completeopt = "menu,menuone,noinsert,noselect"
    o.dictionary = os.getenv "XDG_DATA_HOME" .. "/dict/words"
    o.tabline = [[%!luaeval('require("statusline").tabs()')]]
    o.sessionoptions:append "terminal,tabpages"
    o.clipboard:append "unnamedplus"
    o.shortmess:append "c"
    G.termdebug_wide = 1
    G.markdown_folding = 1
    G.tex_conceal = "abdmgs"
    G.loaded_ruby_provider = 0
    G.loaded_perl_provider = 0
    G.netrw_browsex_viewer = "xdg-open"
    G.symbols_outline = { auto_preview = false, width = 40 }

    -- Folds for filetype
    if Op "filetype" ~= "vimwiki" and Op "filetype" ~= "markdown" then
        o.foldexpr = "nvim_treesitter#foldexpr()"
    end

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
    AuCmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
        end,
    })
end

------------------------------------------------------------------------
--                              VimWiki                               --
------------------------------------------------------------------------

function settings.vimwiki()
    local l = {}
    l.path = "$HOME/Documents/vimWiki"
    l.syntax = "markdown"
    l.ext = ".md"
    l.auto_diary_index = 1
    l.auto_toc = 1
    l.auto_generte_links = 1
    l.nested_syntaxes = { cpp = "cpp" }
    l.autowriteall = 1
    G.vimwiki_list = { l }
    G.vimwiki_markdown_link_ext = 1
    G.vimwiki_auto_chdir = 1
    G.vimwiki_folding = "expr"
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
