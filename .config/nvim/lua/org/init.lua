local wiki = {}

local exec = vim.api.nvim_command

local createLink = function(words)
    if words:match "/" then
        local path = vim.fn.fnamemodify(words, ":p:h")
        exec("!mkdir -p " .. path)
        local tag = vim.fn.input "Enter link name: "
        local link = { string.format("[[%s][%s]]", words, tag) }
        return link
    else
        local tag = vim.fn.fnamemodify(words, ":r")
        local link = { string.format("[[%s][%s]]", words, tag) }
        return link
    end
end

local followLink = function(link)
    if vim.loop.fs_stat(link) then
        vim.cmd("e " .. link)
        vim.cmd "lcd %:h:t"
    else
        vim.cmd("cd " .. vim.fn.expand "%:p:h")
        vim.cmd("e " .. link)
    end
end

local findLinkString = function(line)
    line = line:match "%[.*%]%[.*%]"
    if not line then
        print "No links were found"
        return nil
    end
    return line
end

local findPath = function(link)
    link = link:gsub("%[%[", "")
    if not link then
        print "Link does not follow proper syntax"
        return nil
    end

    link = link:gsub("%]%[.*", "")
    if not link then
        print "Syntax error: Wrong formatting of link"
        return nil
    end
    return link
end

local createPath = function(word)
    print "Link does not point to file"
    local line
    vim.ui.select({ "yes", "no" }, { prompt = "Create link? " }, function(choice)
        if choice == "yes" then
            local link = createLink(word)
            vim.api.nvim_put(link, "l", true, true)
            line = link[1]
        else
            return nil
        end
    end)
    return line
end

function wiki.fs()
    local line = vim.api.nvim_get_current_line()
    local word = vim.fn.expand "<cWORD>"

    line = findLinkString(line)

    if not line then
        line = createPath(word)
        if not line then
            return
        end
    end

    line = findPath(line)
    if not line then
        return
    end

    followLink(line)
end

function wiki.deleteLink()
    local line = vim.api.nvim_get_current_line()
    line = findLinkString(line)

    if not line then
        return
    end
    vim.api.nvim_del_current_line()
    -- vim.ui.select({ "yes", "no" }, { prompt = "Delete files /or folders?" }, function(choice)
    --     if choice == "yes" then
    --         line = findPath(line)
    --         print(line)
    --     else
    --         return
    --     end
    -- end)
end

return wiki
