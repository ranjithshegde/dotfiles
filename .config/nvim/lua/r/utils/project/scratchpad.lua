------------------------------------------------------------------------
--                          scratchPad                                --
------------------------------------------------------------------------

local function isFile(file)
    local stat = vim.loop.fs_stat(file)
    if stat ~= nil then
        return stat
    else
        return false
    end
end

local function croot()
    local files = { "compile_flags.txt", ".clang-format" }
    if not isFile(files[1]) then
        require("r.utils").silent_shell { "touch", files[1] }
    end
    if not isFile(files[2]) then
        require("r.utils").silent_shell { "clang-format", "--style=webkit", "-dump-config", ">", ".clang_format" }
    end
end

local function execRoot(type)
    if type == "cpp" then
        croot()
    elseif type == "js" then
        require("r.utils").silent_shell { "echo", "'{}'", ">", "tsconfig.json" }
    end
end

local function openScratch(type)
    local dir = vim.env.WORKSPACE .. type .. "/Scratch"
    if not vim.loop.fs_stat(dir).type == "directory" then
        require("r.utils").silent_shell { "mkdir", "-p", dir }
    end
    vim.cmd.lcd(dir)

    vim.ui.input({ prompt = "Enter filename or directory : ", completion = "file" }, function(input)
        local stat = isFile(input)
        ---@diagnostic disable-next-line: missing-parameter
        local ext = vim.fn.fnamemodify(input, ":e")
        if stat and stat.type == "directory" or ext == "" then
            vim.cmd { cmd = "!", args = { "mkdir", "-p", input }, mods = { silent = true } }
            vim.fn.execute("lcd " .. input)
            execRoot(type)
            vim.ui.input({ prompt = "Enter  filename: ", completion = "file" }, function(i)
                vim.cmd.e(i)
            end)
        else
            execRoot(type)
            vim.cmd.e(input)
        end
    end)
end

return function(type, split)
    if not type then
        type = vim.bo.filetype
    end
    local opencmd
    if split then
        if split == "tab" then
            opencmd = "tabnew"
        elseif split == "v" or split == "vs" then
            opencmd = "belowright vnew"
        else
            opencmd = "enew"
        end
        vim.cmd(opencmd)
    end

    if type ~= "" then
        openScratch(type)
    else
        vim.ui.select(
            require("r.utils.tables").projectTypes,
            { prompt = "Select language for scratchPad: " },
            function(choice)
                openScratch(choice)
            end
        )
    end
end
