local M = {}

local opts

M.textobj = function(local_opts)
    local diagnostics = vim.diagnostic.get(0, local_opts or {})

    if vim.tbl_count(diagnostics) == 0 then
        return
    end

    local current_line = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

    local closest_so_far = nil

    for _, v in pairs(diagnostics) do
        if
            (
                closest_so_far == nil
                or (v.lnum + 1 < closest_so_far.lnum + 1)
                or ((v.lnum + 1 == closest_so_far.lnum + 1) and (v.col + 1 < closest_so_far.col + 1))
            )
            and (v.lnum + 1 > current_line[1] or (v.lnum + 1 == current_line[1] and v.end_col >= current_line[2] - 1))
        then
            closest_so_far = v
        end
    end

    if closest_so_far == nil then
        closest_so_far = diagnostics[1]
    end

    vim.fn.setcursorcharpos(closest_so_far.lnum + 1, closest_so_far.col + 1)
    vim.cmd "normal! v"
    vim.fn.setcursorcharpos(closest_so_far.end_lnum + 1, closest_so_far.end_col)
end

M.setup = function(o)
    opts = vim.tbl_deep_extend("force", { create_default_keymaps = true }, o or {})

    if opts.create_default_keymaps then
        for _, mode in ipairs { "x", "o" } do
            vim.keymap.set(
                mode,
                "ig",
                ":<C-U>lua require('r.utils.diagnostics.textobjects').textobj()<CR>",
                { silent = true, desc = "inside error_object" }
            )
        end
    end
end

return M
