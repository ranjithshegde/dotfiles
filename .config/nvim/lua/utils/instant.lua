------------------------------------------------------------------------
--                              Co-authoring                          --
------------------------------------------------------------------------

local instant = {}

-- Start Instant server
function instant.Start()
    local id = vim.fn.input "Enter extension: "
    Exec "PackerLoad instant.nvim"
    Exec("InstantStartServer 192.168.178." .. id .. " 8080")
    require("mappings").coauthor()
end

-- Start Single session
function instant.Session()
    local id = vim.fn.input "Enter extension: "
    Exec("InstantStartSession 192.168.178." .. id .. " 8080")
end

-- Start Single buffer
function instant.Single()
    local id = vim.fn.input "Enter extension: "
    Exec("InstantStartSingle 192.168.178." .. id .. " 8080")
end

-- Follow a user
function instant.Follow()
    local name = vim.fn.input "User to follow: "
    Exec("InstantFollow " .. name)
end

-- Join Single session
function instant.JoinSession()
    Exec "PackerLoad instant.nvim"
    local id = vim.fn.input "Enter extension: "
    Exec("InstantJoinSession 192.168.178." .. id .. " 8080")
    utils.Follow()
end

-- Join Single buffer
function instant.JoinSingle()
    Exec "PackerLoad instant.nvim"
    local id = vim.fn.input "Enter extension: "
    Exec("InstantJoinSingle 192.168.178." .. id .. " 8080")
    utils.Follow()
end

function instant.wordProcessor()
    local o = vim.opt_local
    o.wrap = true
    o.linebreak = true
    o.expandtab = false
    o.spell = true
    o.spelllang = "en_us,en_gb"
    o.complete:append "k"
    o.thesaurus = vim.fn.expand "~/.config/nvim/thesaurus/mthesaur.txt"
    require("mappings").wordProcessor()
end

return instant
