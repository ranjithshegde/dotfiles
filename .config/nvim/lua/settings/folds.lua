------------------------------------------------------------------------
--                              FoldText                              --
------------------------------------------------------------------------

local function handler(virt_text, lnum, end_lnum, width, truncate, ctx)
    local result = {}

    local counts = ("    %d    "):format(end_lnum - lnum)
    local suffix = " ⋯⋯  "
    local padding = ""

    local end_virt_text = ctx.end_virt_text

    local sufWidth = (2 * vim.fn.strdisplaywidth(suffix)) + vim.fn.strdisplaywidth(counts)
    for _, v in ipairs(end_virt_text) do
        sufWidth = sufWidth + vim.fn.strdisplaywidth(v[1])
    end

    local target_width = width - sufWidth
    local cur_width = 0

    for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]

        local chunk_width = vim.fn.strdisplaywidth(chunk_text)
        if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
        else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = vim.fn.strdisplaywidth(chunk_text)

            if cur_width + chunk_width < target_width then
                padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
        end
        cur_width = cur_width + chunk_width
    end

    table.insert(result, { suffix, "UfoFoldedEllipsis" })
    table.insert(result, { counts, "MoreMsg" })
    table.insert(result, { suffix, "UfoFoldedEllipsis" })

    for _, v in ipairs(end_virt_text) do
        table.insert(result, v)
    end

    table.insert(result, { padding, "" })

    return result
end

return function()
    require("ufo").setup {
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = handler,

        provider_selector = function(_, _)
            return ""
        end,
        enable_fold_end_virt_text = true,
    }
    -- vim.api.nvim_set_hl(0, "FoldColumn", { fg = "red" })
end
