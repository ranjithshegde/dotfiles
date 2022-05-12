local completion = {}

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function completion.init()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    cmp.setup {
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-o>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm { select = false },
            ["<C-h>"] = cmp.mapping(function(_)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, { "i", "s" }),
            ["<C-l>"] = cmp.mapping(function(_)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end, { "i", "s" }),
            ["<C-j>"] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-p>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-n>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "orgmode" },
            { name = "path" },
        }, {
            {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end,
                },
            },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = string.format(
                    "%s %s",
                    require("utils.tables").kindSymbols[vim_item.kind],
                    vim_item.kind
                )
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    path = "[Path]",
                    buffer = "[Buffer]",
                    orgmode = "[Org]",
                })[entry.source.name]
                return vim_item
            end,
        },
        window = {
            completion = {
                scrollbar = "║",
            },
            documentation = {
                border = "double",
            },
        },
    }
    require("luasnip.loaders.from_vscode").lazy_load()

    local fs = vim.api.nvim_buf_get_option(0, "filetype")
    if fs == "cpp" or fs == "c" then
        require("lsp.clangd").clangCmp()
    end

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = "FormatOptions",
        callback = function()
            require("utils.langServers").index = 1
        end,
    })
    local isCmp = true
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if isCmp then
            cmp.mapping.close()
            isCmp = false
        else
            isCmp = true
            require("utils").feedkey("<C-e>", "n")
            cmp.complete()
        end
        return "<C-N>"
    end, { expr = true })
end

function completion.pairs()
    local npairs = require "nvim-autopairs"
    npairs.setup { check_ts = true }

    local Rule = require "nvim-autopairs.rule"
    local ts_conds = require "nvim-autopairs.ts-conds"
    npairs.add_rules {
        Rule("|", "|", "supercollider"),
        Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node "table_constructor"),
        Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node "table_constructor"),
    }

    require("cmp").event:on(
        "confirm_done",
        require("nvim-autopairs.completion.cmp").on_confirm_done { map_char = { tex = "" } }
    )
end

function completion.luasnip()
    vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*.scd, *.sc, *.sc_help, *.quark",
        group = "LspSettings",
        callback = function()
            require("luasnip").add_snippets("supercollider", require("scnvim/utils").get_snippets())
        end,
        once = true,
    })
    local types = require "luasnip.util.types"
    require("luasnip").config.set_config {
        history = true,
        updateevents = "TextChanged, TextChangedI",
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "✿" } },
                },
            },
        },
    }
end

return completion
