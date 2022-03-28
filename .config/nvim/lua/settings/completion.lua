local completion = {}

------------------------------------------------------------------------
--                             Completion                             --
------------------------------------------------------------------------

function completion.init()
    local cmp = require "cmp"
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end
    local luasnip = require "luasnip"

    cmp.setup {
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<C-k>"] = cmp.mapping(function()
                require("utils.langServers").next()
            end, { "i", "s" }),
            ["<C-j>"] = cmp.mapping(function()
                require("utils.langServers").prev()
            end, { "i", "s" }),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-o>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm { select = true },
            ["<C-l>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-h>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
        }, {
            { name = "orgmode" },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = string.format(
                    "%s %s",
                    require("utils.langServers").kind_symbols[vim_item.kind],
                    vim_item.kind
                )
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    path = "[Path]",
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
        experimental = { ghost_text = true },
    }
    require("luasnip.loaders.from_vscode").lazy_load()
end

return completion
