local completion = {}

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function completion.init()
   require("mappings").autoComplete()
    G.completion_chain_complete_list = {
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
    G.completion_auto_change_source = 0
    G.completion_popup_border = "double"
    G.completion_disable_filetypes = { "TelescopePrompt", "markdown", "text", "vimwiki" }
    require("luasnip.loaders.from_vscode").lazy_load()
    G.completion_enable_snippet = "luasnip"

    AuGroup("CompletionAttach", {})
    AuCmd("FileType", {
        group = "CompletionAttach",
        callback = function()
            require("completion").on_attach()
        end,
    })
    AuCmd("FileType", {
        group = "CompletionAttach",
        pattern = "supercollider,glsl,conf,org,cmake",
        command = "let g:completion_auto_change_source = 1",
    })
    AuCmd("FileType", {
        group = "CompletionAttach",
        pattern = "cpp,c,hpp,lua,python,java,javascript,typescript",
        command = "let g:completion_auto_change_source = 0",
    }) 
end

return completion
