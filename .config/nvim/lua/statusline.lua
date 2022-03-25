local Statusline = {}

-- Blank Between Components
local space = " "

------------------------------------------------------------------------
--                              statusline                            --
------------------------------------------------------------------------

Statusline.el = function()
    require("el").reset_windows()

    local builtin = require "el.builtin"
    local extensions = require "el.extensions"
    local sections = require "el.sections"
    local subscribe = require "el.subscribe"
    local lsp_statusline = require "el.plugins.lsp_status"

    --*********************************** File Icon ---------------------------------
    local file_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
        local icon, color = require("nvim-web-devicons").get_icon_color(buffer.name, buffer.extension)
        if icon then
            local table = Api.nvim_get_hl_by_name("Statusline", true)
            Api.nvim_set_hl(0, "FileIcon", { bg = table["background"], fg = color, cterm = { bold = true } })
            return icon .. space
        end
        return ""
    end)

    --*********************************** Vim Mode ---------------------------------
    local mode = function()
        local alias = {
            n = "  ☉ ",
            i = "  ✎ ",
            c = "  ⌨ ",
            v = "  ✄ ",
            V = "  ✄ ",
            [""] = "  ✄ ",
            t = "zsh  ▧ ",
        }

        local mode_color = {
            n = Colors.blue,
            i = Colors.orange,
            c = Colors.yellow,
            v = Colors.cyan,
            V = Colors.cyan,
            [""] = Colors.cyan,
            t = Colors.purple,
        }
        -- Text for mode
        local current_mode = alias[vim.fn.mode()]
        -- Get color for mode
        local current_bg = mode_color[vim.fn.mode()]
        local current_fg = Colors.white
        -- Set color
        Api.nvim_set_hl(0, "ElViMode", { fg = current_fg, bg = current_bg })
        return current_mode
    end

    --*********************************** Scroll position ---------------------------------
    local scroll = function()
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

    --*********************************** SuperCollider ---------------------------------

    local scnvim = function(_, buffer)
        if Api.nvim_buf_get_option(buffer.bufnr, "filetype") == "supercollider" then
            local scstatus = "📡" .. vim.fn["scnvim#statusline#server_status"]()
            Api.nvim_set_hl(0, "ScStatus", { bg = Colors.blue, fg = Colors.bg })
            return scstatus
        end
    end

    local scContext = function(_, buffer)
        if Api.nvim_buf_get_option(buffer.bufnr, "filetype") == "supercollider" then
            local f = require("nvim-treesitter").statusline {
                indicator_size = 100,
                type_patterns = {
                    "class",
                    "function",
                    "method",
                    "interface",
                    "type_spec",
                    "table",
                    "if_statement",
                    "for_statement",
                },
            }
            local context = string.format("%s", f)

            if context == "vim.NIL" then
                return "   "
            end
            return "  " .. context
        end
    end

    --*********************************** Git branch ---------------------------------
    local git_branch = subscribe.buf_autocmd("el_git_branch", "BufReadPre", function(window, buffer)
        local branch = extensions.git_branch(window, buffer)
        if branch then
            vim.cmd "PackerLoad gitsigns.nvim"
            return " " .. extensions.git_icon() .. " " .. branch
        end
    end)

    --*********************************** Git sign changes ---------------------------------
    local git_changes = subscribe.buf_autocmd("el_git_changes", "BufWritePost", function(window, buffer)
        local st = extensions.git_changes(window, buffer)
        if not st then
            return
        end
        local add = st:match "+%d*"
        add = add:gsub("+", " ")
        local change = st:match "~%d*"
        change = change:gsub("~", " ")
        local cut = st:match "-%d*"
        cut = cut:gsub("-", " ")
        return "%#GitGutterAdd# " .. add .. "%#GitGutterChange# " .. change .. "%#GitGutterDelete# " .. cut .. "%# #"
    end)

    --*********************************** Status config ---------------------------------
    require("el").setup {
        generator = function(_, _)
            return {
                sections.highlight("ElViMode", mode),
                sections.highlight("DiagnosticWarn", git_branch),
                space,
                git_changes,
                space,
                sections.split,
                lsp_statusline.segment,
                sections.highlight("ScStatus", scnvim),
                sections.highlight("ScStatus", scContext),
                sections.split,
                sections.highlight("FileIcon", file_icon),
                sections.highlight("Statusline", builtin.tail_file),
                sections.collapse_builtin {
                    space,
                    builtin.modified_flag,
                    space,
                    space,
                    builtin.line_number,
                    ":",
                    builtin.column_number,
                    space,
                },
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
local getTabLabel = function(n)
    local current_win = Api.nvim_tabpage_get_win(n)
    local current_buf = Api.nvim_win_get_buf(current_win)
    local file_name = Api.nvim_buf_get_name(current_buf)

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
        local table = Api.nvim_get_hl_by_name("TablineSel", true)
        Api.nvim_set_hl(0, "IconColor", { bg = table["background"], fg = color, cterm = { bold = true } })
        return { tail, icon }
    else
        return { tail }
    end
end

--*********************************** File path ------------------------
local rootDir = function()
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
    local tab_list = Api.nvim_list_tabpages()
    local current_tab = Api.nvim_get_current_tabpage()
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
