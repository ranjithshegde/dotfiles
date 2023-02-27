------------------------------------------------------------------------
--                              FoldText                              --
------------------------------------------------------------------------

local function no_folds(bufnr, ft, buftype)
    if ft == '' then
        return true
    elseif buftype ~= '' then
        return true
    end
    local win = vim.fn.bufwinid(bufnr)
    if vim.tbl_contains(require('r.utils.tables').ignoreFiles, ft) then
        return true
    elseif vim.fn.win_gettype(win) == 'popup' then
        return true
    end
end

local function fallback_selector(bufnr)
    local function handleFallbackException(err, providerName)
        if type(err) == 'string' and err:match 'UfoFallbackException' then
            vim.pretty_print(providerName)
            return require('ufo').getFolds(bufnr, providerName)
        else
            vim.pretty_print(err)
            return require('promise').reject(err)
        end
    end

    return require('ufo')
        .getFolds(bufnr, 'lsp')
        :catch(function(err)
            return handleFallbackException(err, 'treesitter')
        end)
        :catch(function(err)
            return handleFallbackException(err, 'indent')
        end)
end

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' ⋯⋯    %d  ⋯⋯  '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)

            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

local ufo = {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
}

function ufo.config()
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99

    require('ufo').setup {
        open_fold_hl_timeout = 1,

        provider_selector = function(bufnr, ft, buftype)
            return no_folds(bufnr, ft, buftype) and '' or fallback_selector
        end,

        enable_get_fold_virt_text = true,
        fold_virt_text_handler = handler,
        close_fold_kinds = { 'region' },
    }

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
end

return ufo
