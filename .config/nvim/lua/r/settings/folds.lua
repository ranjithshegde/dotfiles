------------------------------------------------------------------------
--                              FoldText                              --
------------------------------------------------------------------------

local function handler(virt_text, lnum, end_lnum, width, truncate, ctx)
    local result = {}

    local counts = ('    %d    '):format(end_lnum - lnum)
    local suffix = ' ⋯⋯  '
    local padding = ''

    local end_virt_text = ctx.get_fold_virt_text(end_lnum)

    local sufWidth = (2 * vim.api.nvim_strwidth(suffix)) + vim.api.nvim_strwidth(counts)

    local target_width = width - sufWidth
    local cur_width = 0

    for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]

        local chunk_width = vim.api.nvim_strwidth(chunk_text)
        if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
        else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = vim.api.nvim_strwidth(chunk_text)

            if cur_width + chunk_width < target_width then
                padding = padding .. (' '):rep(target_width - cur_width - chunk_width)
            end
            break
        end
        cur_width = cur_width + chunk_width
    end

    if end_virt_text[1] and end_virt_text[1][1] then
        end_virt_text[1][1] = end_virt_text[1][1]:gsub('[%s\t]+', '')
    end

    table.insert(result, { suffix, 'UfoFoldedEllipsis' })
    table.insert(result, { counts, 'MoreMsg' })
    table.insert(result, { suffix, 'UfoFoldedEllipsis' })

    vim.list_extend(result, end_virt_text)
    table.insert(result, { padding, '' })

    return result
end

return function()
    require('packer').loader 'promise-async'
    require('ufo').setup {
        open_fold_hl_timeout = 0,

        provider_selector = function(_, _)
            return ''
        end,

        enable_get_fold_virt_text = true,
        fold_virt_text_handler = handler,
    }
end
