------------------------------------------------------------------------
--                          scratchPad                                --
------------------------------------------------------------------------

local shell = require('r.utils').silent_shell

local function isFile(file)
    local stat = vim.uv.fs_stat(file)
    if stat ~= nil then
        return stat
    else
        return false
    end
end

local function croot()
    local files = { 'compile_flags.txt', '.clang-format' }
    if not isFile(files[1]) then
        shell { 'touch', files[1] }
    end
    if not isFile(files[2]) then
        shell { 'clang-format', '--style=webkit', '-dump-config', '>', '.clang_format' }
    end
end

local function execRoot(type)
    if type == 'cpp' then
        croot()
    elseif type == 'js' then
        shell { 'echo', "'{}'", '>', 'tsconfig.json' }
    end
end

local function openScratch(type)
    local workspace = vim.env.WORKSPACE
    if workspace == nil then
        workspace = vim.fn.input('Enter Worksapce Dir: ', '', 'file')
    end
    local dir = workspace .. type .. '/Scratch'
    if vim.uv.fs_stat(dir).type ~= 'directory' then
        shell { 'mkdir', '-p', dir }
    end
    vim.cmd.lcd(dir)

    vim.ui.input({ prompt = 'Enter filename or directory : ', completion = 'file' }, function(input)
        local stat = isFile(input)
        local ext = vim.fn.fnamemodify(input, ':e')
        if stat and stat.type == 'directory' or ext == '' then
            shell { 'mkdir', '-p', input }
            vim.cmd.lcd(input)
            execRoot(type)
            vim.ui.input({ prompt = 'Enter  filename: ', completion = 'file' }, function(i)
                vim.cmd.e(i)
            end)
        else
            execRoot(type)
            vim.cmd.e(input)
        end
    end)
end

return function(split, type)
    local opencmd
    if split then
        if split == 'tab' then
            opencmd = 'tabnew'
        elseif split == 'v' or split == 'vs' then
            opencmd = 'belowright vnew'
        else
            opencmd = 'enew'
        end
        vim.cmd(opencmd)
    end

    local ft = vim.bo.filetype
    if not type and not vim.tbl_contains(require('r.utils.tables').ignoreFiles, ft) then
        type = ft
    end

    if type then
        openScratch(type)
    else
        vim.ui.select(
            require('r.utils.tables').projectTypes,
            { prompt = 'Select language for scratchPad: ' },
            function(choice)
                openScratch(choice)
            end
        )
    end
end
