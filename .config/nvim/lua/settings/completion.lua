local completion = {}
local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function completion.init()
    require("mappings").autoComplete()
    vim.g.completion_chain_complete_list = {
        supercollider = {
            { complete_items = { "snippet", "path" } },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        org = {
            { complete_items = { "snippet", "path" } },
            { mode = "omni" },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        glsl = {
            { complete_items = { "snippet" } },
            { mode = "user" },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
        default = {
            { complete_items = { "lsp", "snippet", "path" } },
            { mode = "<c-p>" },
            { mode = "<c-n>" },
        },
    }
    vim.g.completion_auto_change_source = 0
    vim.g.completion_popup_border = "double"
    vim.g.completion_disable_filetypes = { "TelescopePrompt", "markdown", "text", "vimwiki" }
    require("luasnip.loaders.from_vscode").lazy_load()
    vim.g.completion_enable_snippet = "luasnip"

    augroup("CompletionAttach", {})
    aucmd("FileType", {
        group = "CompletionAttach",
        callback = function()
            require("completion").on_attach()
        end,
    })
    aucmd("FileType", {
        group = "CompletionAttach",
        pattern = "supercollider,glsl,conf,org,cmake",
        command = "let g:completion_auto_change_source = 1",
    })
    aucmd("FileType", {
        group = "CompletionAttach",
        pattern = "cpp,c,hpp,lua,python,java,javascript,typescript",
        command = "let g:completion_auto_change_source = 0",
    })
end

function completion.pairs()
    local npairs = require "nvim-autopairs"
    local Rule = require "nvim-autopairs.rule"
    local ts_conds = require "nvim-autopairs.ts-conds"
    npairs.setup()
    npairs.add_rules {
        Rule("|", "|", "supercollider"),
        Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node { "table_constructor" }),
        Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node { "table_constructor" }),
    }
end

function completion.luasnip()
    vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*.scd, *.sc, *.sc_help, *.quarks",
        group = "LspSettings",
        callback = function()
            require("luasnip").add_snippets("supercollider", require("scnvim/utils").get_snippets())
        end,
    })
end

return completion
