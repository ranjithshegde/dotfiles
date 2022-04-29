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
    map("n", "<F2>", "<cmd>SCNvimStatusLine<cr>", { buffer = true, desc = "Display server status" })
    map("n", "<F3>", function()
        require("scnvim").send("Server.local.boot", true)
    end, { buffer = true, desc = "Boot local server", expr = true })

    map("n", "<F4>", function()
        require("scnvim").send("WFS.startup", true)
    end, { buffer = true, desc = "Boot WFS server", expr = true })

    map("n", "<F5>", "<Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("i", "<F5>", "<esc><Plug>(scnvim-send-block)", { buffer = true, desc = "Evaluate SC code block" })
    map("v", "<F5>", "<Plug>(scnvim-send-selection)", { buffer = true, desc = "Evaluate SC visual block" })
    map("n", "<F6>", "<Plug>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("i", "<F6>", "<Plug><esc>(scnvim-send-line)", { buffer = true, desc = "Evaluate SC line" })
    map("n", "<leader>s", open "SuperCollider/startup.scd", { buffer = true, desc = "open startup file" })

    map("n", ",s", function()
        require("scnvim.completion.signature").show { border = "rounded" }
    end, { buffer = true, desc = "SC signature help" })
end

------------------------------------------------------------------------
--                              Lua                                   --
------------------------------------------------------------------------

local scratch = vim.env.HOME .. "/Software/Workspaces/lua/Scratch/"

local function openScratch()
    vim.cmd("lcd " .. scratch)
    vim.ui.input({ prompt = "Enter  filename: ", completion = "file" }, function(input)
        vim.cmd("e " .. input)
    end)
end

function ftmaps.lua()
    vim.keymap.set("n", "<F6>", "<cmd>w<cr><cmd>source %<CR>", { buffer = true, desc = "Evaluate current file" })
    vim.keymap.set("n", "<leader>s", function()
        openScratch()
    end, { buffer = true, desc = "Open a scratch file" })
end

return ftmaps
