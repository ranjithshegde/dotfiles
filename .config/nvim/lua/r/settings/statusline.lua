-- Blank Between Components
local space = " "

local right = ""
local left = " "

------------------------------------------------------------------------
--                              statusline                            --
------------------------------------------------------------------------

local builtin = require "el.builtin"
local extensions = require "el.extensions"
local sections = require "el.sections"
local subscribe = require "el.subscribe"

--*********************************** File Icon -------------------------
local file_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
    local icon, color = require("nvim-web-devicons").get_icon_color(buffer.name, buffer.extension)
    if icon then
        local table = vim.api.nvim_get_hl_by_name("statusline", true)
        vim.api.nvim_set_hl(0, "FileIcon", { bg = table["background"], fg = color, cterm = { bold = true } })
        return icon .. space
    end
    return ""
end)

--*********************************** Vim Mode --------------------------

local map = {
    ["n"] = "NORMAL",
    ["no"] = "O-PENDING",
    ["nov"] = "O-PENDING",
    ["noV"] = "O-PENDING",
    ["no\22"] = "O-PENDING",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["nt"] = "NORMAL",
    ["ntT"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "V-LINE",
    ["Vs"] = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S-LINE",
    ["\19"] = "S-BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["Rvc"] = "V-REPLACE",
    ["Rvx"] = "V-REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "EX",
    ["ce"] = "EX",
    ["r"] = "REPLACE",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

---@return string current mode name
local function get_mode()
    local mode_code = vim.api.nvim_get_mode().mode
    if map[mode_code] == nil then
        return mode_code
    end
    return map[mode_code]
end

local mode_to_highlight = {
    ["VISUAL"] = "MiniStatuslineModeVisual",
    ["V-BLOCK"] = "MiniStatuslineModeVisual",
    ["V-LINE"] = "MiniStatuslineModeVisual",
    ["SELECT"] = "MiniStatuslineModeVisual",
    ["S-LINE"] = "MiniStatuslineModeVisual",
    ["S-BLOCK"] = "MiniStatuslineModeVisual",
    ["REPLACE"] = "MiniStatuslineModeReplace",
    ["V-REPLACE"] = "MiniStatuslineModeReplace",
    ["INSERT"] = "MiniStatuslineModeInsert",
    ["COMMAND"] = "MiniStatuslineModeCommand",
    ["EX"] = "MiniStatuslineModeCommand",
    ["MORE"] = "MiniStatuslineModeCommand",
    ["CONFIRM"] = "MiniStatuslineModeCommand",
    ["TERMINAL"] = "MiniStatuslineModeOther",
    ["NORMAL"] = "MiniStatuslineModeNormal",
}

local function mode()
    local current_mode = get_mode()
    local current_hl = "%#" .. mode_to_highlight[current_mode] .. "# "
    return current_hl .. current_mode .. left .. " %##"
end

--*********************************** Scroll position -------------------
local function scroll()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local chars = {
        "_",
        "▁",
        "▂",
        "▃",
        "▄",
        "▅",
        "▆",
        "▇",
        "█",
    }
    local index = 1

    if current_line == 1 then
        index = 1
    elseif current_line == total_lines then
        index = #chars
    else
        local line_no_fraction = vim.fn.floor(current_line) / vim.fn.floor(total_lines)
        index = vim.fn.float2nr(line_no_fraction * #chars)
        if index == 0 then
            index = 1
        end
    end
    return chars[index]
end

--*********************************** SuperCollider ---------------------
local function scnvim(_, buffer)
    if vim.bo[buffer.bufnr].filetype == "supercollider" then
        local scstatus = require("scnvim.statusline").get_server_status()
        if scstatus ~= "" then
            return "📡 [" .. scstatus .. "]"
        end
    end
    return ""
end

--*********************************** Git branch ------------------------
local git_branch = subscribe.buf_autocmd("el_git_branch", "BufReadPre", function(window, buffer)
    local ft = vim.bo[buffer.bufnr].filetype
    if ft == "TelescopePrompt" then
        return
    end
    local branch = extensions.git_branch(window, buffer)
    if branch then
        require("packer").loader "gitsigns.nvim"
        return space .. extensions.git_icon() .. space .. branch
    end
end)

--*********************************** Git sign changes ------------------
local function git_changes(_, _)
    local st = vim.b.gitsigns_status
    if not st then
        return ""
    end
    local result = ""
    local add = st:match "+%d*"
    if add then
        add = add:gsub("+", " ")
        result = result .. "%#GitGutterAdd# " .. add
    end
    local change = st:match "~%d*"
    if change then
        change = change:gsub("~", " ")
        result = result .. "%#GitGutterChange# " .. change
    end
    local cut = st:match "-%d*"
    if cut then
        cut = cut:gsub("-", " ")
        result = result .. "%#GitGutterDelete# " .. cut
    end
    return result .. "%##"
end

--*********************************** Lsp status  -----------------------
local diagnostics = require("el.diagnostic").make_buffer(require("r.utils.diagnostics.format").formatter)

local tsNodes = require("r.utils.tables").tsNodes

local function gps(_, buffer)
    local fs = vim.bo[buffer.bufnr].filetype
    local context = require("r.settings.treesitter").statusline {
        indicator_size = vim.b.gps or 35,
        type_patterns = tsNodes.filetype[fs] or tsNodes.default,
        bufnr = buffer.bufnr,
    }
    if context == "" then
        return ""
    end
    context = "🇻  " .. context
    return context
end

--*********************************** Status config ---------------------
return function()
    require("el").reset_windows()
    require("r.utils.diagnostics.format").sethl("DiagnosticError", "DiagnosticWarn", "DiagnosticHint", "DiagnosticInfo")
    require("el").setup {
        generator = function(_, _)
            return {
                mode,
                sections.highlight("DiagnosticWarn", git_branch),
                git_changes,
                sections.split,
                diagnostics,
                sections.collapse_builtin { scnvim, space, gps },
                sections.split,
                sections.highlight("FileIcon", file_icon),
                sections.highlight("statusline", builtin.tail_file),
                sections.collapse_builtin {
                    space,
                    builtin.modified_flag,
                    space,
                    space,
                    "[",
                    builtin.line_with_width(3),
                    ":",
                    builtin.column_with_width(2),
                    "]",
                },
                space,
                sections.collapse_builtin {
                    "[ ",
                    builtin.help_list,
                    builtin.readonly_list,
                    " ]",
                },
                sections.highlight("DiagnosticWarn", builtin.percentage_through_file),
                sections.highlight("DiagnosticWarn", scroll),
                space,
                space,
            }
        end,
    }
end
