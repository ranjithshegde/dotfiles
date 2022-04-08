local Statusline = {}

-- Blank Between Components
local space = " "

local colors = {
    bg = "#32302f",
    bg2 = "#008080",
    bg3 = "#d79921",
    white = "#fbf1c7",
    yellow = "#d79921",
    cyan = "#008080",
    grey = "#928374",
    green = "#98971a",
    purple = "#b16286",
    orange = "#d65d0e",
    blue = "#458588",
    red = "#cc241d",
}

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
        local table = vim.api.nvim_get_hl_by_name("Statusline", true)
        vim.api.nvim_set_hl(0, "FileIcon", { bg = table["background"], fg = color, cterm = { bold = true } })
        return icon .. space
    end
    return ""
end)

--*********************************** Vim Mode --------------------------
local function mode()
    local alias = {
        n = " ☉ ",
        i = " ✎ ",
        c = " ⌨ ",
        v = " ✄ ",
        V = " ✄ ",
        [""] = " ✄ ",
        t = "zsh ▧ ",
    }

    local mode_color = {
        n = colors.blue,
        i = colors.orange,
        c = colors.yellow,
        v = colors.cyan,
        V = colors.cyan,
        [""] = colors.cyan,
        t = colors.purple,
    }
    -- Text for mode
    local current_mode = alias[vim.fn.mode()]
    -- Get color for mode
    local current_bg = mode_color[vim.fn.mode()]
    local current_fg = colors.white
    -- Set color
    vim.api.nvim_set_hl(0, "ElViMode", { fg = current_fg, bg = current_bg })
    return current_mode
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
    if vim.api.nvim_buf_get_option(buffer.bufnr, "filetype") == "supercollider" then
        local scstatus = vim.fn["scnvim#statusline#server_status"]()
        if scstatus ~= "" then
            return "📡 [" .. scstatus .. "]"
        end
    end
    return ""
end

--*********************************** Git branch ------------------------
local git_branch = subscribe.buf_autocmd("el_git_branch", "BufReadPre", function(window, buffer)
    local ft = vim.api.nvim_buf_get_option(buffer.bufnr, "filetype")
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
local diagnostics = require("el.diagnostic").make_buffer(require("utils.diagnostics").formatter)

local default = {
    "class",
    "function",
    "method",
    "struct",
    "enum",
    "interface",
    "module",
    "type_spec",
    "section",
}

local ft = {
    c = {
        "function_definition",
        "struct",
        "enum",
        "linkage_specification",
    },
    cpp = {
        "class",
        "function_definition",
        "struct",
        "enum",
        "linkage_specification",
    },
    lua = {
        "function",
        "table_constructor",
        "module",
        "enum",
    },
    opencl = {
        "function_definition",
        "struct",
        "enum",
        "linkage_specification",
    },
    tex = {
        "chapter",
        "subsection",
        "section",
    },
}

local function gps(_, buffer)
    local fs = vim.api.nvim_buf_get_option(buffer.bufnr, "filetype")
    local context = require("settings.treesitter").statusline {
        indicator_size = vim.b.gps or 35,
        type_patterns = ft[fs] or default,
    }
    if context == "" then
        return ""
    end
    return "🇻  " .. context
end

--*********************************** Status config ---------------------
Statusline.el = function()
    require("el").reset_windows()
    require("utils.diagnostics").sethl("DiagnosticError", "DiagnosticWarn", "DiagnosticHint", "DiagnosticInfo")
    require("el").setup {
        generator = function(_, _)
            return {
                sections.highlight("ElViMode", mode),
                sections.highlight("DiagnosticWarn", git_branch),
                git_changes,
                sections.split,
                diagnostics,
                sections.collapse_builtin { scnvim, space, gps },
                sections.split,
                sections.highlight("FileIcon", file_icon),
                sections.highlight("Statusline", builtin.tail_file),
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
            }
        end,
    }
end

------------------------------------------------------------------------
--                              TabLine                               --
------------------------------------------------------------------------

--*********************************** File label -----------------------
local function getTabLabel(n)
    local current_win = vim.api.nvim_tabpage_get_win(n)
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local file_name = vim.api.nvim_buf_get_name(current_buf)

    local tail = vim.fn.fnamemodify(file_name, ":p:t")
    if tail == "" then
        return { "Empty buffer" }
    end

    local ext = nil
    if string.find(file_name, "term://") ~= nil then
        ext = "terminal"
    else
        ext = vim.fn.fnamemodify(tail, ":e")
    end

    local icon, color = require("nvim-web-devicons").get_icon_color(tail, ext)
    if icon ~= nil then
        local table = vim.api.nvim_get_hl_by_name("TablineSel", true)
        vim.api.nvim_set_hl(0, "IconColor", { bg = table["background"], fg = color, cterm = { bold = true } })
        return { tail, icon }
    else
        return { tail }
    end
end

--*********************************** File path ------------------------
local function rootDir()
    local val = vim.fn.expand "%"
    if string.find(val, "term://") ~= nil then
        val = " " .. vim.fn.fnamemodify(val, ":p:t")
    elseif val ~= "" then
        val = "🗀 " .. val
    end
    return val
end

--*********************************** Tabline module -------------------
function Statusline.tabs()
    local tabline = ""
    local tab_list = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_get_current_tabpage()
    for _, val in ipairs(tab_list) do
        local name = getTabLabel(val)
        if val == current_tab then
            if name[2] then
                tabline = tabline .. "%#IconColor#" .. space .. name[2] .. "%#TabLineSel# " .. name[1] .. space
            else
                tabline = tabline .. space .. "%#TabLineSel# " .. name[1] .. space
            end
        else
            tabline = tabline .. space .. "%#TabLine# " .. name[1] .. space
        end
    end
    tabline = tabline .. "%#TabLineFill#" .. "%="
    tabline = tabline .. "%#TabLineSel# " .. rootDir() .. space
    return tabline
end

return Statusline
