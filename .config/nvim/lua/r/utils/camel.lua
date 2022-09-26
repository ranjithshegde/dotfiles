-- stylua: ignore start
local forward_to_end_list = {
    [[\d+]],                                          -- numner
    [[\u+\ze%(\u\l|\d)]],                             -- ALLCAPS followed by CamelCase or number
    [[\l+\ze%(\u|\d)]],                               -- lowercase followed by ALLCAPS
    [[\u\l+]],                                        -- CamelCase
    [[%(\a|\d)+\ze[\-_] ]],                           -- underscore_notation
    [[%(\k@!\S)+]],                                   -- non-keyword
    [[%([\-_]@!\k)+>]]                                -- word
}
local forward_to_end = [[\v]] .. table.concat(forward_to_end_list, "|")

local forward_to_next_list = {
    [[<\D]],                                         -- word
    [[^$]],                                          -- empty line
    [[%(^|\s)+\zs\k@!\S]],                           -- non-keyword after whitespaces
    [[><]],                                          -- non-whitespace after word
    [[[\{\}\[\]\(\)\<\>\&"'."'".'] ]],               -- brackets, parens, braces, quotes
    [[\d+]],                                         -- number
    [[\l\+\zs%(\u|\d)]],                             -- lowercase followed by capital letter or number
    [[\u+\zs%(\u\l|\d)]],                            -- ALLCAPS followed by CamelCase or number
    [[\u\l+]],                                       -- CamelCase
    [[\u@<!\u+]],                                    -- ALLCAPS
    [[[\-_]\zs%(\u\+|\u\l+|\l+|\d+)]]                -- underscored followed by ALLCAPS, CamelCase, lowercase, or number
}
local forward_to_next = [[\v]] .. table.concat(forward_to_next_list, "|")
-- stylua: ignore end

local function move(direction, count, mode)
    local i = 0
    while i < count do
        if direction == 'e' or direction == 'ge' then
            direction = direction == 'e' and direction or 'be'
            vim.fn.search(forward_to_end, 'W' .. direction)
            if mode == 'o' then
                local save_ww = vim.o.whichwrap
                vim.opt.whichwrap:append 'l'
                vim.api.nvim_feedkeys('l', 'n', false)
                vim.o.whichwrap = save_ww
            end
        else
            direction = direction == 'w' and '' or direction
            vim.fn.search(forward_to_next, 'W' .. direction)
        end
        i = i + 1
    end
end

local camelCase = {}

function camelCase.Motion(direction, count, mode)
    if mode == 'v' then
        vim.api.nvim_feedkeys('gv', 'n', false)
    end

    if mode == 'v' or mode == 'iv' then
        if vim.o.selection ~= 'exclusive' and direction == 'w' then
            vim.api.nvim_feedkeys('l', 'n', false)
        end
    end

    move(direction, count, mode)

    if mode == 'v' or mode == 'iv' then
        if
            vim.o.selection == 'exclusive'
            and function()
                return direction == 'e' or direction == 'ge'
            end
        then
            vim.api.nvim_feedkeys('l', 'n', false)
        elseif
            vim.o.selection ~= 'exclusive'
            and function()
                return direction ~= 'e' and direction == 'ge' or mode == 'iv' and direction == 'w'
            end
        then
            vim.api.nvim_feedkeys('h', 'n', false)
        end
    end
    if vim.o.foldopen == [[hor|all]] then
        vim.api.nvim_feedkeys('zv', 'n', false)
    end
end

function camelCase.InnerMotion(direction, count)
    vim.api.nvim_feedkeys('l', 'n', false)
    if direction == 'b' then
        camelCase.Motion('b', count, 'n')
        vim.api.nvim_feedkeys('v', 'n', false)
        camelCase.Motion('e', count, 'iv')
    else
        camelCase.Motion('b', 1, 'n')
        vim.api.nvim_feedkeys('v', 'n', false)
        camelCase.Motion(direction, count, 'iv')
    end

    if vim.o.foldopen == [[hor|all]] then
        vim.api.nvim_feedkeys('zv', 'n', false)
    end
end

function camelCase.CreateMotionMappings(leader)
    if not leader then
        leader = ''
    end
    for _, mode in ipairs { 'n', 'o', 'v' } do
        for _, motion in ipairs { 'w', 'b', 'e', 'ge' } do
            local targetMapping = '<Plug>CamelCaseMotion_' .. motion
            vim.keymap.set(mode == 'v' and 'x' or mode, leader .. motion, targetMapping, { silent = true })
        end
    end

    for _, mode in ipairs { 'o', 'v' } do
        for _, motion in ipairs { 'w', 'b', 'e', 'ge' } do
            local targetMapping = '<Plug>CamelCaseMotion_i' .. motion
            vim.keymap.set(mode == 'v' and 'x' or mode, 'i' .. leader .. motion, targetMapping, { silent = true })
        end
    end

    if vim.o.foldopen == [[hor|all]] then
        vim.api.nvim_feedkeys('zv', 'n', false)
    end
end

function camelCase.init()
    if vim.g.loaded_camelcasemotion ~= nil then
        print 'Already loaded'
        return
    end
    vim.g.loaded_camelcasemotion = 1

    print 'Loading Camel'

    if vim.fn.exists(vim.g.camelcasemotion_key) == 1 then
        camelCase.CreateMotionMappings(vim.g.camelcasemotion_key)
    else
        camelCase.CreateMotionMappings()
    end

    for _, mode in ipairs { 'n', 'o', 'v' } do
        for _, motion in ipairs { 'w', 'b', 'e', 'ge' } do
            local targetMapping = '<Plug>CamelCaseMotion_' .. motion
            vim.keymap.set(mode, targetMapping, function()
                camelCase.Motion(motion, vim.v.count1, mode)
            end, { silent = true })
        end
    end

    for _, mode in ipairs { 'o', 'v' } do
        for _, motion in ipairs { 'w', 'b', 'e', 'ge' } do
            local targetMapping = '<Plug>CamelCaseMotion_i' .. motion
            vim.keymap.set(mode, targetMapping, function()
                camelCase.InnerMotion(motion, vim.v.count1)
            end, { silent = true })
        end
    end
end

return camelCase
