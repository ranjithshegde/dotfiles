------------------------------------------------------------------------
--                              statusline                            --
------------------------------------------------------------------------
local statusline = {}

statusline.el = function()
    require("el").reset_windows()

    local builtin = require "el.builtin"
    local extensions = require "el.extensions"
    local sections = require "el.sections"
    local subscribe = require "el.subscribe"
    local lsp_statusline = require "el.plugins.lsp_status"
    local separators = { left = "  ", right = "  " }

    --*********************************** File Icon ---------------------------------
    local file_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, bufnr)
        local icon = extensions.file_icon(_, bufnr)
        if icon then
            return icon .. " "
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
            [""] = "  ✄ ",
            t = "zsh  ▧ ",
        }

        local mode_color = {
            n = Colors.blue,
            i = Colors.orange,
            c = Colors.yellow,
            v = Colors.cyan,
            [""] = Colors.cyan,
            t = Colors.purple,
        }
        -- Text for mode
        local current_mode = alias[vim.fn.mode()]
        -- Get color for mode
        local current_bg = mode_color[vim.fn.mode()]
        local current_fg = Colors.white
        -- Set color
        vim.cmd(string.format("hi ElViMode guibg=%s guifg=%s", current_bg, current_fg))
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
        vim.cmd(string.format("hi ElScroll guibg=%s guifg=%s", Colors.yellow, Colors.purple))
        return chars[index]
    end

    --*********************************** SuperCollider ---------------------------------

    local scnvim = function()
        if Op "filetype" == "supercollider" then
            -- local tspos = Api.nvim_exec([[echo nvim_treesitter#statusline(20)]], true)
            local scstatus = "📡" .. Fn("scnvim#statusline#server_status", {})
            vim.cmd(string.format("hi ScStatus guibg=%s guifg=%s", Colors.blue, Colors.bg))
            return scstatus
        end
    end

    --*********************************** Git branch ---------------------------------
    local git_branch = subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
        local branch = extensions.git_branch(window, buffer)
        vim.cmd(string.format("hi ElGitBranch guibg=%s guifg=%s", Colors.bg, Colors.yellow))
        if branch then
            vim.fn.execute "PackerLoad gitsigns.nvim"
            return " " .. extensions.git_icon() .. " " .. branch
        end
    end)

    --*********************************** Git sign changes ---------------------------------
    local git_changes = subscribe.buf_autocmd("el_git_changes", "BufWritePost", function(window, buffer)
        vim.cmd(string.format("hi ElGitDiff guibg=%s guifg=%s", Colors.bg, Colors.blue))
        return extensions.git_changes(window, buffer)
    end)

    --*********************************** Status config ---------------------------------
    require("el").setup {
        generator = function(_, _)
            return {
                sections.highlight("ElViMode", mode),
                sections.highlight("ElGitBranch", git_branch),
                separators.left,
                sections.highlight("ElGitDiff", git_changes),
                separators.left,
                sections.split,
                sections.highlight("Diag", lsp_statusline.segment),
                sections.split,
                sections.highlight("ScStatus", scnvim),
                lsp_statusline.server_progress,
                sections.split,
                sections.highlight("DevIconH", file_icon),
                sections.highlight("Filename", builtin.tail_file),
                sections.collapse_builtin { " ", builtin.modified_flag },
                separators.right,
                -- builtin.quickfix,
                builtin.line_with_width(3),
                ":",
                builtin.column_with_width(2),
                separators.left,
                sections.highlight("ElGitBranch", builtin.percentage_through_file),
                sections.highlight("ElScroll", scroll),
                sections.collapse_builtin { builtin.help_list, builtin.readonly_list },
            }
        end,
    }
end

------------------------------------------------------------------------
--                              TabLine                               --
------------------------------------------------------------------------

function statusline.tabs()
    -- Separators
    local right_separator = " ❯❯ "
    local left_separator = " ❮❮ "
    -- Blank Between Components
    local space = " "

    --*********************************** Working Dir ---------------------------------
    local workDir = function()
        return vim.call("expand", "%")
    end

    --*********************************** File label ---------------------------------
    local getTabLabel = function(n)
        local current_win = Api.nvim_tabpage_get_win(n)
        local current_buf = Api.nvim_win_get_buf(current_win)
        local file_name = Api.nvim_buf_get_name(current_buf)
        if string.find(file_name, "term://") ~= nil then
            return " " .. Api.nvim_call_function("fnamemodify", { file_name, ":p:t" })
        end
        file_name = Api.nvim_call_function("fnamemodify", { file_name, ":p:t" })
        if file_name == "" then
            return "No Name"
        end

        local ext = vim.fn.fnamemodify(file_name, ":e")
        local icon = require("nvim-web-devicons").get_icon(file_name, ext)
        if icon ~= nil then
            return icon .. space .. file_name
        end
        return file_name
    end

    -- *********************************** Highlight groups ---------------------------------
    -- Set tabline colours
    local set_colours = function()
        Exec(string.format("hi TabLineSel guibg=%s guifg=%s", Colors.bg, Colors.white))
        Exec(string.format("hi TabLineSelSeparator guibg=%s guifg=%s", Colors.bg, Colors.white))
        Exec(string.format("hi TabLine guibg=None guifg=%s", Colors.purple))
        Exec(string.format("hi TabLineSeparator guibg=None guifg=%s", Colors.purple))
        Exec "hi TabLineFill guibg=None gui=None"
    end

    --*********************************** Tabline module ---------------------------------
    set_colours()
    local tabline = ""
    local tab_list = Api.nvim_list_tabpages()
    local current_tab = Api.nvim_get_current_tabpage()
    for _, val in ipairs(tab_list) do
        local file_name = getTabLabel(val)
        if val == current_tab then
            -- tabline = tabline .. " %#TabLineSelSeparator#" .. left_separator
            tabline = tabline .. " %#StatusLine#" .. left_separator
            tabline = tabline .. "%#StatusLine# " .. file_name
            tabline = tabline .. " %#StatusLine#" .. right_separator
        else
            -- tabline = tabline .. " %#TabLine#" .. left_separator
            tabline = tabline .. " %#StatusLineNC#" .. left_separator
            -- tabline = tabline .. "%#TabLineSeparator# " .. file_name
            tabline = tabline .. "%#StatusLineNC# " .. file_name
            tabline = tabline .. " %#StatusLineNC#" .. right_separator
        end
    end
    tabline = tabline .. "%="
    tabline = tabline
        .. "%#StatusLine#"
        .. left_separator
        .. "%#StatusLine# "
        .. workDir()
        .. "%#StatusLine#"
        .. right_separator
    tabline = tabline .. space
    return tabline
end
return statusline
