local ftmaps = {}
local map = vim.keymap.set

------------------------------------------------------------------------
--                              Latex                                 --
------------------------------------------------------------------------

function ftmaps.tex()
    map("n", "<F3>", "<cmd>TexWordCount<CR>", { buffer = true, desc = "Word count" })
    map("n", "<F4>", "<cmd>Make -C<CR>", { buffer = true, desc = "Clean tex files" })
    map("n", "<F5>", "<cmd>TexlabBuild<CR>", { buffer = true, desc = "Compile tex document" })
    map("n", "<F6>", "<cmd>TexlabForward<CR>", { buffer = true, desc = "Launch zathura" })
end

------------------------------------------------------------------------
--                              SuperCollider                         --
------------------------------------------------------------------------

local open = function(path)
    return string.format("<cmd>tab drop ~/.config/%s<CR>", path)
end

function ftmaps.scnvim()
    map("n", "<F1>", require("scnvim").start, { buffer = true, desc = "Launch Sclang" })
    map("n", "<F2>", "scnvim#statusline#sclang_poll()", { expr = true, buffer = true, desc = "Display server status" })
    map("n", "<F3>", function()
        require("scnvim").send("Server.local.boot", true)
    end, { buffer = true, desc = "Boot local server", expr = true })

    map("n", "<F4>", function()
        require("scnvim").send("WFS.startup", true)
    end, { buffer = true, desc = "Boot WFS server", expr = true })

    map("n", "<leader>s", open "SuperCollider/startup.scd", { buffer = true, desc = "open startup file" })
end

------------------------------------------------------------------------
--                              Lua                                   --
------------------------------------------------------------------------

function ftmaps.lua()
    vim.keymap.set("n", "<F6>", "<cmd>w<cr><cmd>source %<CR>", { buffer = true, desc = "Evaluate current file" })
end

return ftmaps
