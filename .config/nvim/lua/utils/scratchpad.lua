------------------------------------------------------------------------
--                          scratchPad                                --
------------------------------------------------------------------------
local exec = vim.api.nvim_command

local function isFile(file)
    if vim.loop.fs_stat(file) ~= nil then
        return true
    else
        return false
    end
end

local function croot()
    local files = { "compile_flags.txt", ".clang-format" }
    if not isFile(files[1]) then
        exec("!touch " .. files[1])
    end
    if not isFile(files[2]) then
        exec "!clang-format -style=webkit -dump-config > .clang-format"
    end
end

local function execRoot(type)
    if type == "cpp" then
        croot()
    elseif type == "js" then
        exec "!echo '{}' > tsconfig.json"
    end
end

local function openScratch(type)
    local dir = vim.env.WORKSPACE .. type .. "/Scratch"
    if not vim.loop.fs_stat(dir).type == "directory" then
        vim.cmd("!mkdir -p " .. dir)
    end
    vim.cmd("lcd " .. dir)

    vim.ui.input({ prompt = "enter directory name: ", completion = "file" }, function(input)
        vim.fn.execute("!mkdir -p " .. input)
        vim.fn.execute("lcd " .. input)
        execRoot(type)
    end)
    vim.ui.input({ prompt = "Enter  filename: ", completion = "file" }, function(input)
        vim.cmd("e " .. input)
    end)
end

return function(type, split)
    if not type then
        type = vim.api.nvim_buf_get_option(0, "filetype")
    end
    local opencmd
    if split then
        if split == "tab" then
            opencmd = "tabnew"
        elseif split == "v" or split == "vs" then
            opencmd = "belowright vnew"
        else
            opencmd = "belowright new"
        end
        vim.cmd(opencmd)
    end

    if type ~= "" then
        openScratch(type)
    else
        vim.ui.select(
            require("utils.tables").projectTypes,
            { prompt = "Select language for scratchPad: " },
            function(choice)
                openScratch(choice)
            end
        )
    end
end
