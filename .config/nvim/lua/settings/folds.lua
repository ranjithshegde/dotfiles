------------------------------------------------------------------------
--                              FoldText                              --
------------------------------------------------------------------------

local function handler(virt_text, lnum, end_lnum, width, truncate)
    local result = {}

    local counts = ("    %d    "):format(end_lnum - lnum)

    local suffix = " ⋯ "
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local target_width = width - sufWidth

    local cur_width = 0
    for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]

        if string.find(chunk[1], "%.%.%.") then
            print("found ", chunk[1])
            table.insert(result, { " ⋯  ", "UfoFoldedEllipsis" })
            table.insert(result, { counts, "MoreMsg" })
        else
            local chunk_width = vim.fn.strdisplaywidth(chunk_text)
            if target_width > cur_width + chunk_width then
                table.insert(result, chunk)
            else
                chunk_text = truncate(chunk_text, target_width - cur_width)
                local hl_group = chunk[2]
                table.insert(result, { chunk_text, hl_group })
                chunk_width = vim.fn.strdisplaywidth(chunk_text)

                if cur_width + chunk_width < target_width then
                    suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
                end
                break
            end
            cur_width = cur_width + chunk_width
        end
    end

    return result
end

return function()
    require("ufo").setup {
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = handler,

        provider_selector = function(_, _)
            return ""
        end,
    }
    -- require("ufo").closeAllFolds()
    vim.keymap.set("n", "<C-p>", function()
        require("ufo").peekFoldedLinesUnderCursor(20, false, false)
    end, { desc = "Preview folded text" })
end
