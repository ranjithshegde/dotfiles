local errmsg = ""

local function default_register()
    local values = vim.split(vim.opt.clipboard:get(), ",")
    if vim.tbl_contains(values, "unnamedplus") then
        return "+"
    elseif vim.tbl_contains(values, "unnamed") then
        return "*"
    else
        return '"'
    end
end

local vim_repeat = {}

local function maps()
    vim.keymap.set("n", "<Plug>(RepeatDot)", function()
        -- require("utils").feedkey("<C-U>", "n")
        if not vim_repeat.run(vim.v.count) then
            error(vim_repeat.errmsg())
        end
    end, { silent = true })

    vim.keymap.set("n", "<Plug>(RepeatUndo)", function()
        -- require("utils").feedkey("<C-U>", "n")
        vim_repeat.wrap("u", vim.v.count)
    end, { silent = true })

    vim.keymap.set("n", "<Plug>(RepeatUndoLine)", function()
        -- require("utils").feedkey("<C-U>", "n")
        vim_repeat.wrap("U", vim.v.count)
    end, { silent = true })

    vim.keymap.set("n", "<Plug>(RepeatRedo)", function()
        -- require("utils").feedkey("<C-U>", "n")
        vim_repeat.wrap([[<Lt>C-R>]], vim.v.count)
    end, { silent = true })
end

local function plug_maps()
    if vim.fn.hasmapto("<Plug>(RepeatDot)", "n") ~= 1 then
        vim.keymap.set("n", ".", "<Plug>(RepeatDot)", { desc = "Dot repeat" })
    end

    if vim.fn.hasmapto("<Plug>(RepeatUndo)", "n") ~= 1 then
        vim.keymap.set("n", "u", "<Plug>(RepeatUndo)", { desc = "Dot repeat undo" })
    end

    if vim.fn.maparg("U", "n") == "" and vim.fn.hasmapto("<Plug>(RepeatUndoLine)", "n") ~= 1 then
        vim.keymap.set("n", "U", "<Plug>(RepeatUndoLine)", { desc = "Dot repeat undo line" })
    end

    if vim.fn.hasmapto("<Plug>(RepeatRedo)", "n") ~= 1 then
        vim.keymap.set("n", "<C-R>", "<Plug>(RepeatRedo)", { desc = "Dot repeat redo" })
    end
end

function vim_repeat.enable()
    vim.g.repeat_tick = -1
    vim.g.repeat_reg = { "", "" }

    maps()
    plug_maps()

    vim.api.nvim_create_augroup("repeatPlugin", { clear = true })

    vim.api.nvim_create_autocmd({ "BufLeave", "BufWritePre", "BufReadPre" }, {
        group = "repeatPlugin",
        callback = function()
            vim.g.repeat_tick = (vim.g.repeat_tick == vim.b.changedtick or vim.g.repeat_tick == 0) and 0 or -1
        end,
        desc = "Set repeaat tick for vim-repeat",
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = "repeatPlugin",
        callback = function()
            if vim.g.repeat_tick == 0 then
                vim.g.repeat_tick = vim.b.changedtick
            end
        end,
        desc = "unset repeaat tick for vim-repeat",
    })
end

-- Special function to avoid spurious repeats in a related, naturally repeating
-- mapping when your repeatable mapping doesn't increase b:changedtick.
function vim_repeat.invalidate()
    -- vim.api.nvim_exec_autocmds("repear_custom_motion", {})
    vim.cmd "autocmd! repeat_custom_motion"
    vim.g.repeat_tick = -1
end

function vim_repeat.set(sequence, ...)
    local args = { ... }
    vim.g.repeat_sequence = sequence
    vim.g.repeat_count = #args ~= 0 and args[1] or vim.v.count
    vim.g.repeat_tick = vim.b.changedtick

    vim.api.nvim_create_augroup("repeat_custom_motion", { clear = true })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = "repeat_custom_motion",
        buffer = 0,
        callback = function()
            vim.g.repeat_tick = vim.b.changedtick
            vim.cmd "autocmd! repeat_custom_motion"
        end,
    })
    --
end

function vim_repeat.setreg(sequence, register)
    vim.g.repeat_reg = { sequence, register }
end

function vim_repeat.run(count)
    local ok = pcall(function()
        if vim.g.repeat_tick == vim.b.changedtick then
            local r = ""
            if vim.g.repeat_reg[0] == vim.g.repeat_sequence and not vim.tbl_isempty(vim.g.repeat_reg[1]) then
                -- Take the original register, unless another (non-default, we
                -- unfortunately cannot detect no vs. a given default register)
                -- register has been supplied to the repeat command (as an
                -- explicit override).
                local regname = vim.v.register == default_register() and vim.g.repeat_reg[1] or vim.v.register
                if regname == "=" then
                    -- This causes a re-evaluation of the expression on repeat, which
                    -- is what we want.
                    r = [["=]] .. vim.fn.getreg("=", 1) .. [[<CR>]]
                else
                    r = '"' .. regname
                end
            end

            local c = vim.g.repeat_count
            local s = vim.g.repeat_sequence
            local cnt = c == -1 and "" or (count and count or (c and c or ""))

            vim.api.nvim_feedkeys(s, "i", false)
            vim.api.nvim_feedkeys(r .. cnt, "ni", false)
        else
            -- vim.cmd("norm! " .. (count and count or "") .. ".")
            vim.api.nvim_feedkeys((count and count or "") .. ".", "ni", false)
        end
    end)

    if not ok then
        errmsg = vim.v.errmsg
        return 0
    end
    -- catch /^Vim(normal):/
    return 1
end

function vim_repeat.errmsg()
    return errmsg
end

function vim_repeat.wrap(command, count)
    local preserve = vim.g.repeat_tick == vim.b.changedtick
    vim.api.nvim_feedkeys((count and count or "") .. command, "n", false)
    if vim.opt.foldopen:get() == [[undo|all]] then
        vim.cmd "norm! zv"
    end
    if preserve then
        vim.g.repeat_tick = vim.b.changedtick
    end
end

return vim_repeat
